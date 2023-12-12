import 'dart:convert';

List<UsersModel> UsersModelFromJson(String str) =>
    List<UsersModel>.from(json.decode(str).map((x) => UsersModel.fromMap(x)));

class UsersModel {
  String id;
  String Name;
  String email;
  String role;
  String isAgent;
  String StatutAgent;
  String agenceNAme;
  String agenceLieu;
  bool isBlocked;

  UsersModel(
      {required this.id,
      required this.Name,
      required this.email,
      required this.role,
      required this.isAgent,
      required this.StatutAgent,
      required this.agenceLieu,
      required this.agenceNAme,
      required this.isBlocked});
  factory UsersModel.fromMap(Map<String, dynamic> json) {
    return UsersModel(
        id: json['_id'],
        Name: json['name'],
        email: json['email'],
        role: json['role'],
        isAgent: json['isAgent'],
        agenceNAme: nullValNom(json),
        agenceLieu: nullValLieu(json),
        StatutAgent: json['StatutAgent'],
        isBlocked: json['isBlocked']);
  }
}

String nullValNom(test) {
  if (test['agence'] != null)
    return test['agence']['nomAgence'];
  else
    return 'vide';
}

String nullValLieu(test) {
  if (test['agence'] != null)
    return test['agence']['lieu'];
  else
    return 'vide';
}
