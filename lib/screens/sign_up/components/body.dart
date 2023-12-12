import 'package:flutter/material.dart';
import 'package:ecommerce/constants.dart';
import 'package:ecommerce/size_config.dart';

import 'sign_up_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Container(
          height: 1200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              opacity: 0.2,
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.04), // 4%
                  Text("Créer un compte", style: headingStyle),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignUpForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),

                  SizedBox(height: getProportionateScreenHeight(20)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
