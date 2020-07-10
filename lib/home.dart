import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Test extends StatefulWidget {
  static String jobName = 'doctors';
  static String name;
  static int age;
  static bool single;
  static double salary;

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _isLoading = true;

  final _reference = FirebaseDatabase.instance.reference();

  Future<void> getData()async{
    await _reference.child('jobs/${Test.jobName}').once().then((snapshot){
      Test.name = snapshot.value['name'];
      Test.age = snapshot.value['age'];
      Test.single = snapshot.value['single'];
      Test.salary = snapshot.value['salary'];
      }
    );
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState() {
    getData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Test.jobName),
      ),
      body: Center(
        child: _isLoading ? CircularProgressIndicator() : Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(Test.name),
            Text(Test.age.toString()),
            Text(Test.salary.toString()),
            Text(Test.single ? 'Singele':'Married'),
            FlatButton(onPressed: (){
              _reference.child('jobs/${Test.jobName}/salary').remove();
            }, child: Icon(Icons.remove)),
            TextField(
              onSubmitted: (value){
                _reference.child('jobs/${Test.jobName}').update({
                  'salary':double.parse(value),
                  'hasChild':true,
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
