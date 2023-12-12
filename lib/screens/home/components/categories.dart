import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../size_config.dart';

class Categories extends StatefulWidget {
  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Map<String, dynamic>> categories = [
    {"icon": "assets/icons/Flash Icon.svg", "text": "Flash Deal"},
  ];

  final List<String> imgList = [
    "assets/images/carrou1.jpeg",
    "assets/images/carrou2.webp",
    "assets/images/carrou3.jpg",
    "assets/images/carrou4.jpeg",
    "assets/images/carrou5.jpeg",
  ];
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.all(getProportionateScreenWidth(0)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(height: 20),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10),
                        bottom: Radius.circular(30),
                      ),
                    ),
                    height: 200,
                    width: width * 0.9,
                    child: CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        aspectRatio: 16 / 9,
                        autoPlay: true,
                      ),
                      items: imgList
                          .map((item) => Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                ),
                                child: Center(
                                    child: Image.asset(item,
                                        fit: BoxFit.cover, width: 1000)),
                              ))
                          .toList(),
                    )),
                SizedBox(height: 20),
              ],
            ),
          ]),
    );
  }
}
