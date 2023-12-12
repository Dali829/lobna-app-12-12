class profilModel {
  String id;
  String Name;
  String email;
  String role;
  String isAgent;
  String phone;
  String? avatar;
  profilModel(
      {required this.avatar,
      required this.id,
      required this.Name,
      required this.email,
      required this.role,
      required this.isAgent,
      required this.phone});
  factory profilModel.fromJson(Map<String, dynamic> json) {
    return profilModel(
        id: json['_id'],
        avatar: json['avatar'],
        Name: json['name'],
        email: json['email'],
        role: json['role'],
        isAgent: json['isAgent'],
        phone: json['phone']);
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "Name": Name,
        "email": email,
        "role": role,
        "isAgent": isAgent,
        "phone": phone,
        "avatar": avatar
      };
}
