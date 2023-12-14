import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../main.dart';
import '../../../models/profilModel.dart';
import '../../../service/links.dart';
import '../../sign_in/sign_in_screen.dart';
import 'profile_menu.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    _Data = getClientById();
    print(sharedPref?.getString("id"));
    fToast = FToast();
    fToast?.init(context);
  }

  FToast? fToast;

  late Future<profilModel> _Data;
  late profilModel profil;
  final spinkit = SpinKitFadingCircle(
    itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Color(0xFF4A3298) : Colors.green,
        ),
      );
    },
  );

  Future<profilModel> getClientById() async {
    String Url = "$getAgentByID${sharedPref?.getString("id")}";
    http.Response futureprofil = await http.get(Uri.parse(Url));
    print(futureprofil.statusCode);
    print(futureprofil.body);
    if ((futureprofil.statusCode == 200) || (futureprofil.statusCode == 201)) {
      return profilModel.fromJson(json.decode(futureprofil.body));
    } else {
      throw Exception('can not load post data');
    }
  }
// image update

  String? base64String;

  Future _pickImageGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(returnedImage!.path);
    });
    List<int> imageBytes = File(_selectedImage!.path).readAsBytesSync();
    base64String = base64Encode(imageBytes);
    if (base64String != null) {
      updateImage();
    }
  }

  File? _selectedImage;

  Future updateImage() async {
    try {
      String Url = "$updateAgent";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": sharedPref?.getString("id"),
                "avatar": base64String,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('User updated');
          setState(() {
            _Data = getClientById();
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

  TextEditingController Input_controller = new TextEditingController();

  Future<void> _showAlertDialog(String champ) async {
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
                updateElement(champ);

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

  Future updateElement(String champ) async {
    print(champ);
    print(Input_controller.text);
    try {
      String Url = "$updateAgent";
      await http
          .put(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "id": sharedPref?.getString("id"),
                champ: Input_controller.text,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('user updated');
          setState(() {
            _Data = getClientById();
          });
        } else {
          showCustomToast('error');
        }
      });
    } catch (e) {
      showCustomToast('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          opacity: 0.2,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            FutureBuilder<profilModel>(
              future: _Data,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          fit: StackFit.expand,
                          clipBehavior: Clip.none,
                          children: [
                            (snapshot.data!.avatar != null)
                                ? CircleAvatar(
                                    backgroundImage: MemoryImage(base64Decode(
                                        snapshot.data?.avatar ?? " ")))
                                : CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/images/Logo.png"),
                                  ),
                            Positioned(
                                right: -16,
                                bottom: 0,
                                child: SizedBox(
                                    height: 46,
                                    width: 46,
                                    child: FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        side: BorderSide(color: Colors.white),
                                      ),
                                      color: Color(0xFFF5F6F9),
                                      onPressed: () {
                                        _pickImageGallery();
                                      },
                                      child: Center(
                                          child:
                                              Icon(Icons.camera_alt_outlined)),
                                    )))
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("bonjour"),
                      ProfileMenu(
                        text: snapshot.data!.Name,
                        icon: "assets/icons/User Icon.svg",
                        press: () => _showAlertDialog("name"),
                      ),
                      ProfileMenu(
                        text: snapshot.data!.email,
                        icon: "assets/icons/User Icon.svg",
                        press: () => _showAlertDialog("email"),
                      ),
                      ProfileMenu(
                        text: snapshot.data!.phone.toString(),
                        icon: "assets/icons/Phone.svg",
                        press: () => _showAlertDialog("phone"),
                      ),
                      ProfileMenu(
                        text: "Se Déconnecter",
                        icon: "assets/icons/Log out.svg",
                        press: () => Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => SignInScreen())),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Verifer votre connexion");
                }
                return spinkit;
              },
            ),
          ],
        ),
      ),
    );
  }
}
