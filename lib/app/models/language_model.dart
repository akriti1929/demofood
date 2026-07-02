class LanguageModel {
  String? id;
  String? name;
  String? code;
  String? image;
  bool? active;
  bool? defaultLanguage;
  bool? isRtl;
  bool? isDeleted;

  LanguageModel({this.id, this.name, this.code, this.active, this.image, this.isRtl, this.isDeleted, this.defaultLanguage});

  @override
  String toString() {
    return 'LanguageModel{id: $id, name: $name, code: $code, active: $active, image:$image,isRtl:$isRtl,isDeleted:$isDeleted , defaultLanguage:$defaultLanguage}';
  }

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    active = json['active'];
    defaultLanguage = json['defaultLanguage'];
    code = json['code'];
    isRtl = json['isRtl'];
    isDeleted = json['isDeleted'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['active'] = active;
    data['defaultLanguage'] = defaultLanguage;
    data['code'] = code;
    data['isRtl'] = isRtl;
    data['isDeleted'] = isDeleted;
    return data;
  }
}
