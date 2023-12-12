import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../service/links.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/reservationModel.dart';

class ResDemandeAdmin extends StatefulWidget {
  @override
  State<ResDemandeAdmin> createState() => _ResDemandeAdminState();
}

class _ResDemandeAdminState extends State<ResDemandeAdmin> {
  late Future<List<ReservationModel>> _Datas;

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
  List<ReservationModel> mesData = [];

  Future<List<ReservationModel>> getAll() async {
    String Url = "$getReservations";
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return mesData = parsed
          .map<ReservationModel>((json) => ReservationModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  //update Element

  Future<void> _showAlertDialog(String idElem, String champ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('type ...'),
          content: SingleChildScrollView(
            child: Container(
              width: 200,
              child: TextFormField(
                controller: Input_controller,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade100,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (val) {
                  if (val?.length == 0) {
                    return "error";
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('modify'),
              onPressed: () {
                updateElement(idElem, champ);

                Timer(Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future updateElement(String id, String champ) async {
    try {
      String Url = "$updateReservations";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": id,
                "statut": champ,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('opération effectuée');
          setState(() {
            _Datas = getAll();
          });
        } else {
          showCustomToast('error');
        }
      });
    } catch (e) {
      showCustomToast('error');
    }
  }

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
                    'Réservations',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: FutureBuilder<List<ReservationModel>>(
                      future: _Datas,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DataTable(
                              columns: [
                                DataColumn(
                                    label: Text('Article',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Prix',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Client',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                                DataColumn(
                                    label: Text('Nombre \n de jours',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold))),
                              ],
                              rows: mesData
                                  .map(
                                    (data) => DataRow(cells: [
                                      DataCell(
                                          Text(data.productName.toString())),
                                      DataCell(Text(data.prix.toString())),
                                      DataCell(Text(data.nameAgent)),
                                      DataCell(Text(data.numbrJour.toString())),
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
