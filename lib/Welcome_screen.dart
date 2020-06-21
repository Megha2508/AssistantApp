import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Personal Assistant'),
          backgroundColor: Colors.green[900],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Text('Welcome!:)', style: TextStyle(fontSize: 25.0)),
                    Text(
                      'Please give notification access to your assistant app.',
                      style: TextStyle(fontSize: 15.0),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15.0),
                    FlatButton(
                      textColor: Colors.white,
                      color: Color(0xFF00e676),
                      onPressed: () {
                        Navigator.pushNamed(context, 'notification');
                      },
                      child: Text(
                        'Notification Settings',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Legal Notice'),
              ),
              FlatButton(
                onPressed: () {},
                child: Text('Privacy Policy'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
