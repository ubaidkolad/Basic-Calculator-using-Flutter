import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  var num1 = 0, num2 = 0, sum = 0;

  final TextEditingController t1 = new TextEditingController(text: "");
  final TextEditingController t2 = new TextEditingController(text: "");

  void doAddition() {
    setState(() {
      num1 = int.parse(t1.text);
      num2 = int.parse(t2.text);
      sum = num1 + num2;
    });
  }

  void doSubtraction() {
    setState(() {
      num1 = int.parse(t1.text);
      num2 = int.parse(t2.text);
      sum = num1 - num2;
    });
  }

  void doMultiplication() {
    setState(() {
      num1 = int.parse(t1.text);
      num2 = int.parse(t2.text);
      sum = num1 * num2;
    });
  }

  void doDivision() {
    setState(() {
      num1 = int.parse(t1.text);
      num2 = int.parse(t2.text);
      sum = (num1 ~/ num2);
    });
  }

  void doClear() {
    setState(() {
      num1 = 0;
      num2 = 0;
      sum = 0;
      t1.text = "";
      t2.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator"),
      ),
      body: new Container(
        padding: EdgeInsets.all(30),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Output:$sum",
              style: new TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            new TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter First Number"),
              controller: t1,
            ),
            new TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "Enter Second Number"),
              controller: t2,
            ),
            new Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  child: new Text("+"),
                  onPressed: doAddition,
                  color: Colors.white30,
                ),
                new RaisedButton(
                    child: new Text("-"),
                    onPressed: doSubtraction,
                    color: Colors.white30)
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                    child: new Text("/"),
                    onPressed: doDivision,
                    color: Colors.white30),
                new RaisedButton(
                    child: new Text("*"),
                    onPressed: doMultiplication,
                    color: Colors.white30)
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  child: Text("Clear"),
                  color: Colors.white30,
                  onPressed: doClear,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
