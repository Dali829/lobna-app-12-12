import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ecommerce/components/custom_surfix_icon.dart';
import 'package:ecommerce/components/form_error.dart';
import 'package:ecommerce/helper/keyboard.dart';
import 'package:ecommerce/screens/forgot_password/forgot_password_screen.dart';
import 'package:ecommerce/screens/login_success/login_success_screen.dart';
import '../../../components/default_button.dart';
import '../../../constants.dart';
import '../../../main.dart';
import '../../../service/links.dart';
import '../../../size_config.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  bool? remember = false;
  final List<String?> errors = [];

  Future postLogin({String? email, String? password}) async {
    try {
      String Url = loginAgent;
      await http
          .post(Uri.parse(Url),
              headers: {
                "Accept": "application/json",
                "content-type": "application/json"
              },
              body: jsonEncode({"email": email, "password": password}))
          .then((response) {
        print("Reponse status : ${response.statusCode}");
        print("Response body : ${response.body}");
        var myresponse = jsonDecode(response.body);

        if (response.statusCode == 200) {
          sharedPref?.setString("isLog", "true");
          sharedPref?.setString("id", myresponse["_id"]);
          sharedPref?.setString(
              "isBlocked", myresponse["isBlocked"].toString());
          sharedPref?.setString("role", myresponse["role"]);
          sharedPref?.setString("isAdmin", myresponse["isAdmin"].toString());
          sharedPref?.setString("name", myresponse["name"].toString());

          KeyboardUtil.hideKeyboard(context);
          Navigator.pushNamed(context, LoginSuccessScreen.routeName);
        } else {
          alertErrorLogin();
        }
      });
    } catch (e) {
      alertErrorLogin();
      print("errorrrrrrrrrr");
      print(e);
    }
  }

  void alertErrorLogin() {
    AwesomeDialog(
      autoHide: const Duration(seconds: 6),
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: "error",
    )..show();
  }

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  @override
  void initState() {
    super.initState();
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Mot de passe oublié",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                postLogin(email: email, password: password);
                /*KeyboardUtil.hideKeyboard(context);
                Navigator.pushNamed(context, LoginSuccessScreen.routeName);*/
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 4) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 4) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mot de passe",
        hintText: "Entrer votre mot de passe",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "Entrer votre email",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
