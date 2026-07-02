// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'package:admin_panel/app/constant/constants.dart';
import 'package:admin_panel/app/models/category_model.dart';
import 'package:admin_panel/app/models/sub_category_model.dart';
import 'package:http/http.dart' as http;

class ApiServices {
  static Map<String, String> headerOpenAI = {
    HttpHeaders.acceptHeader: 'application/json',
    HttpHeaders.connectionHeader: 'keep-alive',
    HttpHeaders.contentTypeHeader: 'application/json',
    'Authorization': "Bearer ${Constant.aiSetting!.apiKey}",
  };

  Future<String> generateFullProductData(
    String productName,
    List<CategoryModel> categoryList,
    List<SubCategoryModel> subCategoryList,
  ) async {
    final categoriesJson = categoryList
        .map((c) => {
              "id": c.id,
              "categoryName": c.categoryName,
              "active": c.active,
              "image": c.image,
            })
        .toList();

    final subCategoriesJson = subCategoryList
        .map((s) => {
              "id": s.id,
              "subCategoryName": s.subCategoryName,
              "categoryId": s.categoryId,
            })
        .toList();

    final systemPrompt = '''
You are a helpful assistant that returns ONLY a strict JSON object with **all fields combined**. NO markdown, NO extra text.  
Generate realistic data with the following structure:

{
  "itemName": "string",
  "description": "string",
  "categoryModel": {
    "id": "string",
    "categoryName": "string",
    "active": true,
    "image": "string"
  },
  "subCategoryModel": {
    "id": "string",
    "subCategoryName": "string",
    "categoryId": "string"
  },
  "price": "string",
  "discount": "string",
  "addons": [
    {"inStock": true, "name": "string", "price": "string"}
  ],
  "variations": [
    {
      "inStock": true,
      "name": "string",
      "optionList": [
        {"name": "string", "price": "string"}
      ]
    }
  ]
}

Rules:
1️⃣ Choose the most relevant category from the following list based on the product name "$productName":
${jsonEncode(categoriesJson)}

2️⃣ Choose the most relevant subcategory from the following list that matches the selected category:
${jsonEncode(subCategoriesJson)}

3️⃣ Price and discount must be numeric strings only (e.g., "200", "0"). Discount can be "0".  

4️⃣ Generate 0–3 realistic addons. If none, return an empty array [].  

5️⃣ Generate 0–2 realistic variations. If none, return an empty array [].  

6️⃣ The "description" field must be **long, multi-sentence, detailed**, describing features, taste, ingredients, or usage. Minimum 3–7 sentences.  

7️⃣ All fields must be realistic and filled. No empty strings unless unavoidable.  

8️⃣ Do NOT include any markdown, explanation, or extra text. Return ONLY JSON.
''';

    final userPrompt = 'Generate full product data for "$productName".';

    return _callOpenAI(systemPrompt, userPrompt);
  }

  // -------------------------------
  // 🔧 Common OpenAI call helper
  // -------------------------------
  Future<String> _callOpenAI(String systemPrompt, String userPrompt) async {
    final body = {
      "model": Constant.aiSetting!.gptModel,
      "messages": [
        {"role": "system", "content": systemPrompt},
        {"role": "user", "content": userPrompt}
      ],
      "max_tokens": int.parse(Constant.aiSetting!.maxToken.toString())
    };

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: headerOpenAI,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final content = decoded['choices']?[0]?['message']?['content'];
      if (content == null) {
        throw Exception('OpenAI response missing content');
      }
      return content.toString().trim();
    } else {
      throw Exception('OpenAI request failed: ${response.statusCode} ${response.body}');
    }
  }
}
