import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

final amount = TextEditingController();
final tipPercent = TextEditingController();
double total, tip;
Color mainColor = Color(0xfffd0054);

bool isPositive() {
  double varAmount = double.parse(amount.text);
  if (varAmount > 0) {
    return true;
  } else {
    return false;
  }
}

bool calcTip() {
  double varAmount = double.parse(amount.text);
  double varTipPercent = double.parse(tipPercent.text);
  if (varTipPercent > 0) {
    tip = (varTipPercent / 100) * varAmount;
    total = varAmount + tip;
    return true;
  } else {
    return false;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Tipsy"),
        ),
        body: new Container(
          padding: const EdgeInsets.all(50.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Enter amount:",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: mainColor),
              ),
              new TextField(
                  keyboardType: TextInputType.number,
                  decoration: new InputDecoration(
                    hintText: "Amount",
                  ),
                  controller: amount),
              new Padding(padding: const EdgeInsets.only(top: 20.0)),
              new RaisedButton(
                  textColor: Colors.white,
                  color: mainColor,
                  child: new Text("Next"),
                  onPressed: () {
                    if (isPositive()) {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new SecondScreen()));
                    } else {
                      AlertDialog alert = AlertDialog(
                        title: Text("Incorrect Value"),
                        content:
                            Text("The entered value of amount is unsuitable"),
                        actions: [
                          FlatButton(
                            textColor: Colors.black,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('OKAY'),
                          ),
                        ],
                      );
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return alert;
                          });
                    }
                  }),
            ],
          ),
        ));
  }
}

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Tipsy"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(30.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              "Amount: " + amount.text,
              style: TextStyle(fontSize: 25, color: mainColor),
            ),
            new Padding(padding: const EdgeInsets.only(top: 20.0)),
            new Text(
              "Enter tip percent:",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: mainColor),
            ),
            new TextField(
              keyboardType: TextInputType.number,
              controller: tipPercent,
              decoration: new InputDecoration(
                hintText: "Tip percent",
              ),
            ),
            new Padding(padding: const EdgeInsets.only(top: 20.0)),
            new RaisedButton(
              textColor: Colors.white,
              color: mainColor,
              child: new Text("Calculate"),
              onPressed: () {
                AlertDialog alert;
                if (calcTip()) {
                  alert = AlertDialog(
                    title: Text("Result"),
                    content: Text("Amount Entered: " +
                        amount.text +
                        "\n" +
                        "Tip: " +
                        tip.toString() +
                        "\n" +
                        "Total: " +
                        total.toString()),
                    actions: [
                      FlatButton(
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('DONE'),
                      ),
                    ],
                  );
                } else {
                  alert = AlertDialog(
                    title: Text("Incorrect Value"),
                    content: Text("The entered value of tip is unsuitable"),
                    actions: [
                      FlatButton(
                        textColor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('OKAY'),
                      ),
                    ],
                  );
                }
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return alert;
                    });
              },
            )
          ],
        ),
      ),
    );
  }
}
