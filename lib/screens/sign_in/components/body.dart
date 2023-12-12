import 'package:flutter/material.dart';
import 'package:ecommerce/components/no_account_text.dart';
import '../../../size_config.dart';
import 'sign_form.dart';

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
                  SizedBox(height: SizeConfig.screenHeight * 0.04),
                  Text(
                    "Se connecter",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(28),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignForm(),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  NoAccountText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
