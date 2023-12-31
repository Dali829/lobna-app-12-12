import 'package:flutter/material.dart';

import '../../../size_config.dart';
import 'categories.dart';
import 'discount_banner.dart';
import 'home_header.dart';
import 'special_offers.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              opacity: 0.2,
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: getProportionateScreenHeight(20)),
              HomeHeader(),
              SizedBox(height: getProportionateScreenWidth(10)),
              DiscountBanner(),
              Categories(),
              SpecialOffers(),
              SizedBox(height: getProportionateScreenWidth(80)),

              /* SizedBox(height: getProportionateScreenWidth(30)),*/
              /*PopularProducts(),*/
              /* SizedBox(height: getProportionateScreenWidth(30)),*/
            ],
          ),
        ),
      ),
    );
  }
}
