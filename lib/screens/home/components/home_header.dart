import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import '../../../models/productModel.dart';
import '../../../service/links.dart';
import '../../../size_config.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  late Future<List<ProductModel>> _Datas;

  @override
  void initState() {
    super.initState();
    _Datas = getAll();
  }

  List<ProductModel> mesData = [];
  List<ProductModel> mesDataA = [];

  Future<List<ProductModel>> getAll() async {
    String Url = "$linkaAllProduct";
    final response = await http.get(Uri.parse(Url));

    if (response.statusCode == 200) {
      final parsed = json.decode(response.body).cast<Map<String, dynamic>>();

      return mesDataA = parsed
          .map<ProductModel>((json) => ProductModel.fromMap(json))
          .toList();
    } else {
      throw Exception('Vérifier votre connexion');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /* SearchField(),*/
              Container(
                width: SizeConfig.screenWidth * 0.6,
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  onChanged: (value) => setState(() {
                    if (value.length < 1) {
                      setState(() {
                        mesData = [];
                      });
                    } else {
                      mesData = mesDataA
                          .where((i) => i.productName
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    }
                  }),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20),
                          vertical: getProportionateScreenWidth(9)),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: "Rechercher ...",
                      prefixIcon: Icon(Icons.search)),
                ),
              ),
            ],
          ),
          FutureBuilder<List<ProductModel>>(
            future: _Datas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width,
                      height: height * 0.1 * mesData.length,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: kSecondaryColor.withOpacity(0.1),
                          width: 4,
                        ), //Border.all
                        borderRadius: BorderRadius.circular(0),
                        /*   boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: const Offset(
                              2.0,
                              2.0,
                            ), //Offset
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                          ), //BoxShadow
                          BoxShadow(
                            color: Colors.white,
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 0.0,
                            spreadRadius: 0.0,
                          ), //BoxShadow
                        ],*/
                      ),
                      child: ListView.builder(
                        itemCount: mesData.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                            height: height * 0.08,
                                            width: width * 0.2,
                                            child: Image.memory(base64Decode(
                                                mesData[index].productImage ??
                                                    ""))),
                                        SizedBox(width: width * 0.02),
                                        Text("-- " +
                                            mesData[index].productName +
                                            "-- "),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () => 'Null',
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.green)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: Row(
                                          children: [
                                            Icon(Icons.touch_app),
                                            Text('Reserve')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height * 0.04),
                            ],
                          );
                          /*ListTile(
                        title: Text(snapshot.data![index].id.toString()),
                        subtitle: Text(snapshot.data![index].categoryPhoto),
                      );*/
                        },
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Verifer votre connexion");
              }
              return CircularProgressIndicator();
            },
          )
        ],
      ),
    );
  }
}
