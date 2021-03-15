import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var temp;
  String weatherCondition;
  String locationTime = "Day";
  String offset;

  Future getCurrentWeather() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    http.Response response = await http
        .get(Uri.https("api.openweathermap.org", "/data/2.5/weather", {
      "lat": position.latitude.toString(),
      "lon": position.longitude.toString(),
      "appid": "779677f93655f5270a85f93caf4de06d",
      "units": "metric"
    }));
    var result = jsonDecode(response.body);
    var _weatherCondition = result["weather"];
    if (_weatherCondition == null) {
      Fluttertoast.showToast(
          msg: "Failed to find user's location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        this.weatherCondition = (result["weather"][0]["main"]).toString();
        this.temp = result['main']['temp'];
        this.offset = (result["timezone"]).toString();
      });
    }
    timeCalculation();
  }

  Future fetchWeather(String input) async {
    var searchResult = await http
        .get(Uri.https("api.openweathermap.org", "/data/2.5/weather", {
      "q": input,
      "appid": "779677f93655f5270a85f93caf4de06d",
      "units": "metric",
    }));
    var result = jsonDecode(searchResult.body);
    var _weatherCondition = result["weather"];
    if (_weatherCondition == null) {
      Fluttertoast.showToast(
          msg: "Search failed - Wrong or Missing location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        this.weatherCondition = (result["weather"][0]["main"]).toString();
        this.temp = (result["main"]["temp"].round()).toString();
        this.offset = (result["timezone"]).toString();
      });
      timeCalculation();
    }
  }

  void onTextFieldSubmitted(String input) {
    fetchWeather(input);
  }

  void timeCalculation() {
    var timeOfDay;
    var time = (DateTime.now()).toUtc();
    int localOffset = (int.parse(offset) / 3600).round();
    var addTime = time.add(Duration(hours: localOffset));
    DateFormat formatter = DateFormat('H');
    String localTime = formatter.format(addTime);
    if (int.parse(localTime) >= 05 && int.parse(localTime) <= 17) {
      timeOfDay = "Day";
    } else {
      timeOfDay = "Night";
    }
    setState(() {
      this.locationTime = timeOfDay;
    });
  }

  @override
  void initState() {
    super.initState();
    this.getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/$locationTime.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 150),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              temp != null
                                  ? temp.toString() + '\u00B0'
                                  : "Loading",
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                fontSize: 45.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              weatherCondition != null
                                  ? weatherCondition
                                  : "Loading",
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                color: Colors.white,
                                fontSize: 30.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 220),
                        Container(
                          width: size.width * 0.8,
                          child: TextField(
                            onSubmitted: (String input) {
                              onTextFieldSubmitted(input);
                            },
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              hintText: 'Search location',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
