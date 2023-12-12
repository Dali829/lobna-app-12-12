import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../main.dart';
import '../../../models/reservationModel.dart';
import '../../../service/links.dart';
import '../../../size_config.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    super.initState();
    _Datas = getAll();
  }

  late Future<List<ReservationModel>> _Datas;
  List<ReservationModel> mesData = [];

  Future<List<ReservationModel>> getAll() async {
    String Url = "$getReservations/user/${sharedPref?.getString("id")}";
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
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: 1200,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          opacity: 0.2,
          fit: BoxFit.fitHeight,
        ),
      ),
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: FutureBuilder<List<ReservationModel>>(
            future: _Datas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.extended(
                          backgroundColor: Color(0xFFc18cc6),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 3, color: Colors.blue),
                              borderRadius: BorderRadius.circular(100)),
                          onPressed: () {
                            // Respond to button press
                          },
                          label: Text('Validées'),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Color(0xFFc18cc6),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 3, color: Color(0xFFc18cc6)),
                              borderRadius: BorderRadius.circular(100)),
                          foregroundColor: Colors.black,
                          onPressed: () {
                            // Respond to button press
                          },
                          label: Text('En cours'),
                        ),
                        FloatingActionButton.extended(
                          backgroundColor: Color(0xFFc18cc6),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(width: 3, color: Colors.red),
                              borderRadius: BorderRadius.circular(100)),
                          foregroundColor: Colors.black,
                          onPressed: () {
                            // Respond to button press
                          },
                          label: Text('Annulées'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Container(
                      height: height * 0.7,
                      child: ListView.builder(
                          itemCount: mesData.length,
                          itemBuilder: (context, i) {
                            return Column(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: mesData[i].statut == "Acceptee"
                                              ? Colors.blue
                                              : (mesData[i].statut == "Annulee"
                                                  ? Colors.red
                                                  : Color(0xFFc18cc6)),
                                          width: 4.0,
                                          style: BorderStyle.solid),
                                      borderRadius:
                                          BorderRadius.circular(50.0)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                          icon: SvgPicture.asset(
                                              "assets/icons/application-market-2.svg"),
                                          onPressed: () => {}),
                                      Column(
                                        children: [
                                          Text("Produit"),
                                          Text(mesData[i].productName),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Nbr jours"),
                                          Text(mesData[i].numbrJour.toString()),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text("Prix"),
                                          Text(mesData[i].prix.toString() +
                                              " dt"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height * 0.03),
                              ],
                            );
                          }),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Text("Verifer votre connexion");
              }
              return spinkit;
            },
          ),
        ),
      ),
    );
  }
}
