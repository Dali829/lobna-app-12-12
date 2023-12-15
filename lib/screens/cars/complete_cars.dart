import 'package:intl/intl.dart'; //Import intl in the file this is being done
import 'package:flutter/material.dart';
import 'package:ecommerce/components/coustom_bottom_nav_bar.dart';
import 'package:ecommerce/enums.dart';
import '../../main.dart';
import '../../models/productModel.dart';
import 'package:http/http.dart' as http;
import '../../../size_config.dart';
import 'dart:convert';
import '../../service/links.dart';

class CarsScreen extends StatefulWidget {
  final String idCategory;
  final String nameCategory;
  const CarsScreen(
      {Key? key, required this.idCategory, required this.nameCategory})
      : super(key: key);
  @override
  State<CarsScreen> createState() => _CarsScreenState(idCategory, nameCategory);
}

class _CarsScreenState extends State<CarsScreen> {
  _CarsScreenState(this.idCategory, this.nameCategory);
  String idCategory;
  String nameCategory;

  @override
  void initState() {
    super.initState();
    print(idCategory);
    _Datas = getAll();
  }

  String? idSelected = "";
  int? prixSelected;
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  Future addReservation() async {
    try {
      String Url = "$postReservation";
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({
                "datedebut":
                    '${dateRange.start.year}/${dateRange.start.month}/${dateRange.start.day}',
                "datefin":
                    '${dateRange.end.year}/${dateRange.end.month}/${dateRange.end.day}',
                "agent": sharedPref?.getString("id"),
                "product": idSelected,
                "numbrJour": dateRange.duration.inDays,
                "prix": prixSelected! * dateRange.duration.inDays,
              }))
          .then((response) {
        if ((response.statusCode == 200) || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "rented !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
          setState(() {
            _Datas = getAll();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "error !!",
              style: TextStyle(fontSize: 25),
            ),
            backgroundColor: Color(0xff7CDDC4),
            elevation: 400,
          ));
        }
      });
    } catch (e) {
      print(e);
    }
  }

  List<ProductModel> mesData = [];

  late Future<List<ProductModel>> _Datas;

  Future<List<ProductModel>> getAll() async {
    String Url = "$linkProductByCategory${idCategory}";
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

  DateTime? dateDeb;
  DateTime? dateFin;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var start = dateRange.start;
    final end = dateRange.end;
    final difference = dateRange.duration;
    return Scaffold(
      appBar: AppBar(
        title: Text(nameCategory),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (idSelected!.length > 1)
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 1, left: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  child: Text(
                                      'de ${start.year}/${start.month}/${start.day}'),
                                  onPressed: pickDataRange,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  child: Text(
                                      'à ${end.year}/${end.month}/${end.day}'),
                                  onPressed: pickDataRange,
                                ),
                              )
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${difference.inDays} jours',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '${difference.inDays * prixSelected!} DT',
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            TextButton(
                              child: const Text('Réserver'),
                              onPressed: () {
                                addReservation();
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              FutureBuilder<List<ProductModel>>(
                future: _Datas,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: SizeConfig.screenWidth,
                      height: height * 0.7,
                      child: ListView.builder(
                        itemCount: snapshot.data?.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                Center(
                                  /** Card Widget **/
                                  child: Card(
                                    elevation: 50,
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    child: SizedBox(
                                      width: SizeConfig.screenWidth * 1,
                                      height: 390,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width:
                                                  SizeConfig.screenWidth * 0.6,
                                              child: Image(
                                                image: MemoryImage(base64Decode(
                                                    snapshot.data![index]
                                                            .productImage ??
                                                        "")),
                                              ),
                                            ),
                                            //CircleAvatar
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Text(
                                              snapshot.data![index].productName,
                                              style: TextStyle(
                                                fontSize: 30,
                                                color: Color(0xFF5E40B8),
                                                fontWeight: FontWeight.w500,
                                              ), //Textstyle
                                            ), //Text
                                            const SizedBox(
                                              height: 20,
                                            ), //SizedBox
                                            Expanded(
                                              child: Text(
                                                snapshot.data![index]
                                                    .productDescription,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                ), //Textstyle
                                              ),
                                            ),
                                            Text(
                                              snapshot.data![index].unitPrice
                                                      .toString() +
                                                  " dt",
                                              style: TextStyle(
                                                fontSize: 25,
                                                color: Color(0xFF5E40B8),
                                                fontWeight: FontWeight.w500,
                                              ), //Textstyle
                                            ), //Text
                                            const SizedBox(
                                              height: 10,
                                            ), //SizedBox
                                            Container(
                                              width: SizeConfig.screenWidth,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  SizedBox(
                                                    width: 130,

                                                    child: ElevatedButton(
                                                      onPressed: () =>
                                                          setState(() {
                                                        idSelected = snapshot
                                                            .data![index].id;
                                                        prixSelected = snapshot
                                                            .data![index]
                                                            .unitPrice;
                                                      }),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .green)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(1),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons
                                                                .touch_app),
                                                            Text('Reserve')
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    // RaisedButton is deprecated and should not be used
                                                    // Use ElevatedButton instead

                                                    // child: RaisedButton(
                                                    //   onPressed: () => null,
                                                    //   color: Colors.green,
                                                    //   child: Padding(
                                                    //     padding: const EdgeInsets.all(4.0),
                                                    //     child: Row(
                                                    //       children: const [
                                                    //         Icon(Icons.touch_app),
                                                    //         Text('Visit'),
                                                    //       ],
                                                    //     ), //Row
                                                    //   ), //Padding
                                                    // ), //RaisedButton
                                                  ),
                                                  /* IconButton(
                                                    icon: SvgPicture.asset(
                                                        "assets/icons/Heart Icon.svg"),
                                                    onPressed: () {},
                                                  ),*/
                                                ],
                                              ),
                                            ) //SizedBox
                                          ],
                                        ), //Column
                                      ), //Padding
                                    ), //SizedBox
                                  ), //Card
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Verifer votre connexion");
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  Future pickDataRange() async {
    DateTimeRange? newDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: dateRange,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
  }
}
