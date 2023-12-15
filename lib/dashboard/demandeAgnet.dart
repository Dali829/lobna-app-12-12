import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../service/links.dart';
import '../models/usersModel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TableDemande extends StatefulWidget {
  @override
  State<TableDemande> createState() => _TableDemandeState();
}

class _TableDemandeState extends State<TableDemande> {
  late Future<List<UsersModel>> _Datas;

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0xFF4A3298) : Colors.green,
        ),
      );
    },
  );
  @override
  void initState() {
    super.initState();
    _Datas = getAll();
    fToast = FToast();
    fToast?.init(context);
  }

  FToast? fToast;
  List<UsersModel> mesData = [];
  Future updateElement(stat, role, id) async {
    try {
      String Url = "$updateAgent";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({"id": id, "StatutAgent": stat, "role": role}))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('demande effectuée !! ');
          setState(() {
            _Datas = getAll();
          });
        } else {
          showCustomToast('errorjhbub');
        }
      });
    } catch (e) {
      showCustomToast('erroriojoij');
    }
  }

  Future<List<UsersModel>> getAll() async {
    String Url = "$linkUsers";
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return mesData = parsed
          .map<UsersModel>((json) => UsersModel.fromMap(json))
          .where(
              (i) => i.StatutAgent == "en cours" || i.StatutAgent == "validee")
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  //update Element

  showCustomToast(String libelle) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.blueGrey,
      ),
      child: Text(
        libelle,
        style: TextStyle(color: Colors.white),
      ),
    );

    fToast?.showToast(
      child: toast,
      toastDuration: const Duration(seconds: 3),
    );
  }

  var _formKey = GlobalKey<FormState>();
  TextEditingController Input_controller = new TextEditingController();
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 700,
              child: ListView(
                children: <Widget>[
                  Center(
                      child: Text(
                    'Demandes de passer \n vers compte Agent',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<UsersModel>>(
                      future: _Datas,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Nom',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('E-mail',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('agence',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('lieu',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                  label: Text('Action',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                              rows: mesData
                                  .map(
                                    (data) => DataRow(cells: [
                                      DataCell(Text(data.Name.toString())),
                                      DataCell(Text(data.email.toString())),
                                      DataCell(Text(data.agenceNAme)),
                                      DataCell(Text(data.agenceLieu)),
                                      DataCell(
                                        (data.StatutAgent != 'validee')
                                            ? Row(
                                                children: [
                                                  ElevatedButton(
                                                    child: Text("Accepter"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.blue,
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      updateElement("validee",
                                                          "agent", data.id);
                                                    },
                                                  ),
                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    child: Text("Annuler"),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.red,
                                                      elevation: 0,
                                                    ),
                                                    onPressed: () {
                                                      updateElement("non",
                                                          "user", data.id);
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Text("validée"),
                                      )
                                    ]),
                                  )
                                  .toList());
                        } else if (snapshot.hasError) {
                          return Text("Verifer votre connexion");
                        }
                        return spinkit;
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
