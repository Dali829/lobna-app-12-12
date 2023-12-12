import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../agentDashboard/agentDashboard.dart';
import '../../../components/default_button.dart';
import '../../../main.dart';
import '../../../models/categoryModel.dart';
import '../../../service/links.dart';
import '../../../size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DiscountBanner extends StatefulWidget {
  const DiscountBanner({
    Key? key,
  }) : super(key: key);

  @override
  State<DiscountBanner> createState() => _DiscountBannerState();
}

class _DiscountBannerState extends State<DiscountBanner> {
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

  @override
  void initState() {
    super.initState();
    _Datas = getAll();
    fToast = FToast();
    fToast?.init(context);
  }

  Future postElement() async {
    try {
      String Url = "$addAgence";
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "nomAgence": name_controller.text,
                "lieu": lieu_controller.text,
                "categorie": dropdownValue,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          updateElement(jsonDecode(response.body)["_id"]);
        } else {
          showCustomToast('error');
        }
      });
    } catch (e) {
      showCustomToast('error');
    }
  }

  Future updateElement(id) async {
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
                "StatutAgent": "en cours",
                "agence": id,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          showCustomToast('demande envoyée !! ');
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

  FToast? fToast;

  var _formKey = GlobalKey<FormState>();
  TextEditingController name_controller = new TextEditingController();
  TextEditingController lieu_controller = new TextEditingController();

  Future<void> _showAlertDialog(double width) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          // <-- SEE HERE
          title: const Text('Formulaire'),
          content: SingleChildScrollView(
            child: Container(
              width: width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Nom d'agence",
                    style: TextStyle(),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: width * 0.6,
                    child: TextFormField(
                      controller: name_controller,
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
                  SizedBox(height: 10),
                  Text(
                    "Lieu",
                    style: TextStyle(),
                  ),
                  SizedBox(height: 5),
                  Container(
                    width: width * 0.6,
                    child: TextFormField(
                      controller: lieu_controller,
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
                  SizedBox(height: 10),
                  Text(
                    "Catégorie",
                    style: TextStyle(),
                  ),
                  SizedBox(height: 5),
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
                          child: Text(item.categoryName.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Valider'),
              onPressed: () {
                postElement();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 414;
    double fem = MediaQuery.of(context).size.width / baseWidth;
    double ffem = fem * 0.97;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage("assets/images/Logo.png"),
          radius: 80,
        ),
        SizedBox(height: getProportionateScreenHeight(40)),
        (sharedPref?.getString("role") == "agent")
            ? ((sharedPref?.getString("isBlocked") == "false")
                ? Container(
                    width: width * 0.6,
                    child: DefaultButton(
                      text: "Consulter le Dashboard",
                      press: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DashboardAgentScreen()));
                      },
                    ),
                  )
                : Container(
                    width: width * 0.6,
                    child: DefaultButton(
                      text: "Vous etes bloquée",
                      press: () {},
                    ),
                  ))
            : (Container(
                width: width * 0.6,
                child: DefaultButton(
                  text: "Devenir un agent",
                  press: () {
                    _showAlertDialog(width);
                  },
                ),
              )),
        SizedBox(height: getProportionateScreenHeight(30)),
      ],
    );
  }
}
