import 'dart:async';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/categoryModel.dart';
import '../../../service/links.dart';
import '../constants.dart';
import 'addCategory.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class TableCategory extends StatefulWidget {
  @override
  State<TableCategory> createState() => _TableCategoryState();
}

class _TableCategoryState extends State<TableCategory> {
  late Future<List<CategoryModel>> _Datas;

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
  List<CategoryModel> mesData = [];

  Future<List<CategoryModel>> getAll() async {
    String Url = "$linkCategory";
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return mesData = parsed
          .map<CategoryModel>((json) => CategoryModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  //delete category
  Future deleteelement(idElem) async {
    try {
      String Url = "$deleteCategory${idElem}";
      await http.delete(
        Uri.parse(Url),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json"
        },
      ).then((response) {
        if ((response.statusCode == 200)) {
          showCustomToast("category deleted");
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

  Future<void> _showAlertDialog(String idElem) async {
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
                updateElement(idElem);

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

  String? base64String;

  Future _pickImageGallery(id) async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
    List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
    base64String = base64Encode(imageBytes);
    if (base64String != null) {
      updateImage(id);
    }
  }

  File? _selectedImage;
  Future updateElement(String id) async {
    try {
      String Url = "$updatecategory";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": id,
                "categoryName": Input_controller.text,
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

  Future updateImage(String id) async {
    try {
      String Url = "$updatecategory";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": id,
                "categoryPhoto": base64String,
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
            backgroundColor: kPrimaryColor,
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
                            'Categories',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          )),
                          FutureBuilder<List<CategoryModel>>(
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
                                                _showAlertDialog(data.id);
                                              },
                                              child: Text(
                                                  data.categoryName.toString()),
                                            )),
                                            DataCell(InkWell(
                                              onTap: () {
                                                _pickImageGallery(data.id);
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: (data.categoryPhoto !=
                                                        null)
                                                    ? Image.memory(base64Decode(
                                                        data.categoryPhoto ??
                                                            ""))
                                                    : Text('vide'),
                                              ),
                                            )),
                                            DataCell(InkWell(
                                              onTap: () {
                                                deleteelement(data.id);
                                              },
                                              child: Icon(Icons.close,
                                                  color: Colors.red, size: 23),
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
              : AddCategory(),
        ],
      ),
    ));
  }
}
