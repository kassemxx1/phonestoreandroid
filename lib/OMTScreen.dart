import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'constants.dart';
final _firestore = Firestore.instance;
var now = new DateTime.now();
int day = now.day;
int year = now.year;
int month = now.month;
class OMTScreen extends StatefulWidget {
  static const String id='OMT_Screen';
  @override
  _OMTScreenState createState() => _OMTScreenState();
}

class _OMTScreenState extends State<OMTScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _textEditingController = TextEditingController();
    var IN = 0.0;
    var out = 0.0;
    var startDate =  DateTime(year, month, day, 0, 0, 0, 0, 0);


    Future<double> getqtt(String name,DateTime today) async {
      var qtts = [0.0];

      final messages = await _firestore
          .collection('omt')
          .where('name', isEqualTo: name).where(
          'timestamp', isGreaterThan: today)
          .getDocuments();
      for (var msg in messages.documents) {
        final qtt = msg['qtt'];
        qtts.add(qtt);
      }

      var result = qtts.reduce((sum, element) => sum + element);
      return new Future(() => result);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('OMT'),
      ),
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: _textEditingController,

                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,

                onChanged: (value) {
                  setState(() {
                    IN = double.parse(value);
                  });

                },
                decoration: KTextFieldImputDecoration.copyWith(
                    hintText: 'IN'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(

                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    out=double.parse(value);
                  });

                },
                decoration: KTextFieldImputDecoration.copyWith(
                    hintText: 'OUT'),
              ),
            ),
            MaterialButton(
                onPressed: ()async{
                  await _firestore.collection('omt').add({
                    'in':IN,
                    'out':out,
                    'timestamp':Timestamp.now(),
                  });
                  _textEditingController.clear();
                  getqtt('in', startDate);

                },
              child: Text('Send'),
            ),
            FutureBuilder(
                builder:
                    (BuildContext context,
                    AsyncSnapshot<double>
                    qttnumbr) {
                  return Center(
                    child: Text(
                      'Available : ${qttnumbr.data}',
                    ),
                  );
                },
                initialData: 1.0,
                future:
                   getqtt('in', startDate)),

          ],
        ),
      ) ,
    );
  }
}
