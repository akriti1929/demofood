// ignore_for_file: file_names

class AISettingModel {
  String? id;
  String? apiKey;
  String? content;
  String? maxToken;
  String? gptModel;
  bool? active;

  AISettingModel({this.id, this.apiKey, this.content, this.maxToken, this.gptModel, this.active});

  AISettingModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    apiKey = json['apiKey'];
    content = json['content'];
    maxToken = json['max_token'];
    gptModel = json['gpt_model'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['apiKey'] = apiKey;
    data['content'] = content;
    data['max_token'] = maxToken;
    data['gpt_model'] = gptModel;
    data['active'] = active;
    return data;
  }
}
