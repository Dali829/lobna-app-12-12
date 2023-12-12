
import 'package:flutter/material.dart';
import 'package:ecommerce/components/default_button.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckoutCard> createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController Input_controller = new TextEditingController();
  Future<void> _showAlertDialog(String idElem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        double width = MediaQuery.of(context).size.width;
        double height = MediaQuery.of(context).size.height;
        return AlertDialog(
          // <-- SEE HERE
          title: Column(
            children: [
              const Text(
                'PAYMENT DETAILS',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 20,
                thickness: 2,
                indent: 0,
                endIndent: 0,
                color: Colors.black,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Container(
              width: width * 1,
              child: Column(
                children: [
                  TextFormField(
                    controller: Input_controller,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (val) {
                      if (val?.length == 0) {
                        return "error";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: Input_controller,
                    decoration: InputDecoration(
                      hintText: 'Card Number',
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    validator: (val) {
                      if (val?.length == 0) {
                        return "error";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: width * 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.25,
                          child: TextFormField(
                            controller: Input_controller,
                            decoration: InputDecoration(
                              hintText: 'CVV',
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (val) {
                              if (val?.length == 0) {
                                return "error";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        Container(
                          width: width * 0.4,
                          child: TextFormField(
                            controller: Input_controller,
                            decoration: InputDecoration(
                              hintText: 'Code',
                              fillColor: Colors.grey.shade100,
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            validator: (val) {
                              if (val?.length == 0) {
                                return "error";
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: getProportionateScreenWidth(190),
                    child: DefaultButton(
                      text: "PAYMENT",
                      press: () {},
                    ),
                  ),
                  SizedBox(
                      width: getProportionateScreenWidth(190),
                      child: Image.asset("assets/images/cards.jpg")),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenWidth(15),
        horizontal: getProportionateScreenWidth(30),
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -15),
            blurRadius: 20,
            color: Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    text: "Total:\n",
                    children: [
                      TextSpan(
                        text: "\$64.99",
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
