import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Colors.green[900],
        ),
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Whatsapp'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
