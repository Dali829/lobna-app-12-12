import 'package:flutter/material.dart';
import 'package:ecommerce/size_config.dart';

const kPrimaryColor = Color(0xFF9d79db);
const kPrimaryLightColor = Color(0xFF9d79db);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Colors.white, Color(0xFF9d79db)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Entrer votre email";
const String kInvalidEmailError = "Entrer Votre Email";
const String kPassNullError = "Entrer Votre password";
const String kShortPassError = "mot de passe est courte";
const String kMatchPassError = "Les mots de passe ne correspondent pas";
const String kNamelNullError = "Entrer Votre nom";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Entrer Votre Adresse";

final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
