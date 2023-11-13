class UserModel{
  String? name;
  int? age;
  int? phone;
  String? email;
  String? id;

  UserModel({
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.id
  });
  Map<String,dynamic> toJson()
  {
    final Map<String,dynamic> data=<String,dynamic>{};
    data["name"]=name;
    data["age"]=age;
    data["phone"]=phone;
    data["email"]=email;
    data["id"]=id;
    return data;
  }

  UserModel.fromJson(Map<String,dynamic> json)
  {
    name=json["name"];
    age=json["age"];
    phone=json["phone"];
    email=json["email"];
    id=json["id"];
  }

}