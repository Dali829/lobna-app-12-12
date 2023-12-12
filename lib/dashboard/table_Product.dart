import 'dart:async';
import 'dart:convert';
import 'package:ecommerce/dashboard/addProduct.dart';
import 'package:ecommerce/models/productModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../service/links.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../main.dart';

class TableProduct extends StatefulWidget {
  @override
  State<TableProduct> createState() => _TableProductState();
}

class _TableProductState extends State<TableProduct> {
  late Future<List<ProductModel>> _Datas;

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

  List<ProductModel> mesData = [];

  Future<List<ProductModel>> getAll() async {
    String Url = "$linkProduct/${sharedPref?.getString("id")}";
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return mesData = parsed
          .map<ProductModel>((json) => ProductModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

//delete product
  Future deleteelement(idElem) async {
    try {
      String Url = "$deleteProduct${idElem}";
      await http.delete(
        Uri.parse(Url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      ).then((response) {
        if ((response.statusCode == 200)) {
          showCustomToast("product deleted");
          setState(() {
            _Datas = getAll();
          });
        } else {
          showCustomToast("error");
        }
      });
    } catch (e) {
      showCustomToast("error");
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
      String Url = "$updateProduct";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": id,
                champ: Input_controller.text,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('category updated');
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

  var _formKey = GlobalKey<FormState>();
  TextEditingController Input_controller = new TextEditingController();
  bool addTab = true;
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            FloatingActionButton.extended(
              label: (addTab) ? Text('Ajouter') : Text('Retour'), // <-- Text
              backgroundColor: Color(0xFF4A3298),
              icon: (addTab)
                  ? Icon(
                      // <-- Icon
                      Icons.add,
                      size: 24.0,
                    )
                  : Icon(
                      // <-- Icon
                      Icons.subdirectory_arrow_left_sharp,
                      size: 24.0,
                    ),
              onPressed: () {
                setState(() {
                  addTab = !addTab;
                });
              },
            ),
            (addTab)
                ? Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 700,
                        child: ListView(
                          children: <Widget>[
                            Center(
                                child: Text(
                              'Articles',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            )),
                            FutureBuilder<List<ProductModel>>(
                              future: _Datas,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return DataTable(
                                      columns: [
                                        DataColumn(
                                            label: Text('Nom',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Prix',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
                                        DataColumn(
                                            label: Text('Photo',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold))),
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
                                              DataCell(InkWell(
                                                onTap: () {
                                                  _showAlertDialog(
                                                      data.id, "productName");
                                                },
                                                child: Text(data.productName
                                                    .toString()),
                                              )),
                                              DataCell(InkWell(
                                                onTap: () {
                                                  _showAlertDialog(
                                                      data.id, "unitPrice");
                                                },
                                                child: Text(
                                                    data.unitPrice.toString()),
                                              )),
                                              DataCell(
                                                Image.memory(base64Decode(
                                                    data.productImage ?? "")),
                                              ),
                                              DataCell(InkWell(
                                                onTap: () {
                                                  deleteelement(data.id);
                                                },
                                                child: Icon(Icons.close,
                                                    color: Colors.red,
                                                    size: 23),
                                              )),
                                            ]),
                                          )
                                          .toList());
                                } else if (snapshot.hasError) {
                                  return Text("Verifer votre connexion");
                                }
                                return spinkit;
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : AddProduct(),
          ],
        ),
      ),
    );
  }
}
