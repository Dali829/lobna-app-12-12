import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../models/categoryModel.dart';
import '../../../service/links.dart';
import '../../../size_config.dart';
import '../../cars/complete_cars.dart';
import 'section_title.dart';

class SpecialOffers extends StatefulWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  State<SpecialOffers> createState() => _SpecialOffersState();
}

class _SpecialOffersState extends State<SpecialOffers> {
  late Future<List<CategoryModel>> _Datas;

  @override
  void initState() {
    super.initState();
    _Datas = getAll();
  }

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "categories",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Container(
          child: FutureBuilder<List<CategoryModel>>(
            future: _Datas,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.only(bottom: 15.0),
                  height: 110,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          SpecialOfferCard(
                            image: snapshot.data![index].categoryPhoto ?? "",
                            category: snapshot.data![index].categoryName,
                            numOfBrands: 18,
                            press: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CarsScreen(
                                          idCategory: snapshot.data![index].id,
                                          nameCategory: snapshot
                                              .data![index].categoryName,
                                        )),
                              );
                            },
                          ),
                          SizedBox(width: getProportionateScreenWidth(5)),
                        ],
                      );
                      /*ListTile(
                        title: Text(snapshot.data![index].id.toString()),
                        subtitle: Text(snapshot.data![index].categoryPhoto),
                      );*/
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Verifer votre connexion");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.category,
    required this.image,
    required this.numOfBrands,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final int numOfBrands;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: getProportionateScreenWidth(20)),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Image.memory(
                  base64Decode(image),
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: MemoryImage(base64Decode(image)),
                        fit: BoxFit.cover),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(15.0),
                    vertical: getProportionateScreenWidth(10),
                  ),
                  child: Text.rich(
                    TextSpan(
                      style: TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "consulter")
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
