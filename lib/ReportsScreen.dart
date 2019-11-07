
import 'dart:math';
import 'package:date_format/date_format.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
final _firestore = Firestore.instance;

class ReportsScreen extends StatefulWidget {
  static const String id = 'Reports_Screen';
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  
  var tomorow = new DateTime(year, month, day, 23, 59, 59, 99, 99);
  var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);
  var endDate = new DateTime(year, month, day, 23, 59, 59, 99, 99);

  Future<double> getTodayIn(
      DateTime start, DateTime end, List list, String currency) async {
    list.clear();
    final messsages = await _firestore
        .collection('transaction')
        .where('currency', isEqualTo: currency)
        .where('timestamp', isGreaterThan: start)
        .where('timestamp', isLessThan: end)
        .getDocuments();
    for (var msg in messsages.documents) {
      final price = msg.data['price'];
      setState(() {
        list.add(
          price,
        );
      });
    }
    var result = list.reduce((sum, element) => sum + element);
    return new Future(() => result);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var today = new DateTime(year, month, day, 0, 0, 0, 0, 0);



    var SumLL = 0.0;
    var IN$ = [];
    var INLL = [];
    var rangeIn$ = [];
    var rangeInLL = [];
    return Scaffold(
        appBar: AppBar(
          title: Text('Reports'),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('\$'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(today, tomorow, IN$, '\$'),
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('L.L'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(today, tomorow, INLL, 'L.L'),
            ),
            Row(
              children: <Widget>[
                Text('start Date:'),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1),
                          maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                      }, onConfirm: (date) {
                        setState(() {
                          startDate =date;
                        });



                        print(startDate);
                      }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      '${formatDate(startDate, [yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            Row(
              children: <Widget>[
                Text('End Date:'),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime(2019, 1, 1),
                          maxTime: DateTime(2025, 6, 7), onChanged: (date) {

                          }, onConfirm: (date) {
                            setState(() {
                              endDate =date.add(new Duration(hours: 23,minutes: 59,seconds: 59));
                            });




                          }, currentTime: DateTime.now(), locale: LocaleType.en);
                    },
                    child: Text(
                      '${formatDate(endDate, [yyyy, '-', mm, '-', dd])}',
                      style: TextStyle(color: Colors.blue),
                    )),
              ],
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('\$'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(startDate, endDate, rangeIn$, '\$'),
            ),
            FutureBuilder(
              builder: (BuildContext context, AsyncSnapshot<double> qttnumbr) {
                return Center(
                  child: Row(
                    children: <Widget>[
                      Text('L.L'),
                      Text(
                        '${qttnumbr.data}',
                        style: TextStyle(fontSize: 16, color: Colors.green),
                      ),
                    ],
                  ),
                );
              },
              initialData: 0.0,
              future: getTodayIn(startDate, endDate, rangeInLL, 'L.L'),
            ),

          ],
        ));
  }
}
