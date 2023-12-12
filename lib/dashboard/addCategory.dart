import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import '../constants.dart';
import '../service/links.dart';

class AddCategory extends StatefulWidget {
  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController Name_controller = new TextEditingController();
  TextEditingController Desc_controller = new TextEditingController();

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast?.init(context);
  }

  String? base64String;
  FToast? fToast;
  Future postElement() async {
    try {
      String Url = "$postCategory";
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "categoryName": Name_controller.text,
                "categoryDescription": Desc_controller.text,
                "categoryPhoto": base64String,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('category added');
        } else {
          showCustomToast('error');
        }
      });
    } catch (e) {
      showCustomToast('error');
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
    print(base64String);
  }

  File? _selectedImage;
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

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
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
                                        child: Image.file(_selectedImage!))
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
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 10),
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
      ),
    );
  }
}
