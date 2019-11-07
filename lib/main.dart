import 'package:flutter/material.dart';
import 'MainScreen.dart';
import 'Selling.dart';
import 'PhoneList.dart';
import 'Invoices.dart';
import 'Recharge_Screen.dart';
import 'Accessories_Screen.dart';
import 'ReportsScreen.dart';
import 'OMTScreen.dart';
void main() => runApp(phone_sotre());

class phone_sotre extends StatefulWidget {
  @override
  _phone_sotreState createState() => _phone_sotreState();
}

class _phone_sotreState extends State<phone_sotre> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MainScreen.id,
      routes: {
        MainScreen.id : (context) => MainScreen(),
        PhonesScreen.id : (context) => PhonesScreen(),
        PhonesList.id :(context) => PhonesList(),
        Invoices.id:(context) => Invoices(),
        RechargeScreen.id:(context) => RechargeScreen(),
        AccessoriesScreen.id:(context) => AccessoriesScreen(),
        ReportsScreen.id:(context) => ReportsScreen(),
        OMTScreen.id:(context) =>OMTScreen(),

      },
    );
  }
}