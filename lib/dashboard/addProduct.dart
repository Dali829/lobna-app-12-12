import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import '../main.dart';
import '../models/categoryModel.dart';
import '../service/links.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';

class AddProduct extends StatefulWidget {
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController Name_controller = new TextEditingController();
  TextEditingController Desc_controller = new TextEditingController();
  TextEditingController Price_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
    _Datas = getAll();
  }

  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0xFF4A3298) : Colors.green,
        ),
      );
    },
  );

  FToast? fToast;
  Future postElement() async {
    try {
      String Url = "$posProduct";
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "productName": Name_controller.text,
                "productDescription": Desc_controller.text,
                "productImage": base64String,
                "unitPrice": int.parse(Price_controller.text),
                "categoryId": dropdownValue,
                "agent": sharedPref?.getString("id")
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('Product added');
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

  String? dropdownValue;
  List<CategoryModel> mesData = [];
  Future<List<CategoryModel>>? _Datas;
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

  Future _pickImageGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
    List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
    base64String = base64Encode(imageBytes);
  }

  String? base64String;

  File? _selectedImage;
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<CategoryModel>>(
        future: _Datas,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Nom",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: TextFormField(
                                    controller: Name_controller,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val?.length == 0) {
                                        return "Nom error";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: TextFormField(
                                    controller: Desc_controller,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (val) {
                                      if (val?.length == 0) {
                                        return "Description error";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Prix",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: TextFormField(
                                    controller: Price_controller,
                                    decoration: InputDecoration(
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                    validator: (val) {
                                      if (val?.length == 0) {
                                        return "Price error";
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Image",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: InkWell(
                                    child: Column(children: [
                                      _selectedImage != null
                                          ? Container(
                                              height: 200,
                                              width: 200,
                                              child:
                                                  Image.file(_selectedImage!))
                                          : Image.asset(
                                              "assets/images/camera.png",
                                              width: 40,
                                            ),
                                    ]),
                                    onTap: () {
                                      _pickImageGallery();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 100,
                                  child: Text(
                                    "Categorie",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Container(
                                  width: 200,
                                  child: DropdownButton<String>(
                                    hint: Text("Choisir categorie"),
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 24,
                                    elevation: 16,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue;
                                      });
                                    },
                                    items: mesData.map((item) {
                                      return DropdownMenuItem(
                                        value: item.id.toString(),
                                        child:
                                            Text(item.categoryName.toString()),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 10),
                              child: FloatingActionButton.extended(
                                label: Text('Ajouter'), // <-- Text
                                backgroundColor: kPrimaryColor,

                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    postElement();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text("Verifer votre connexion");
          }
          return spinkit;
        },
      ),
    );
  }
}
