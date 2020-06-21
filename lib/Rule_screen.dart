import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_dialogflow/flutter_dialogflow.dart';

import 'dart:async';
import 'features.dart';

int ruleCount = 0;
String message;
String response;
List<String> messages = [];

//void responseFun(query) async {
//  Dialogflow dialogflow = Dialogflow(token: "646e2f29b8d74160bd1acae3a2dc4f16");
//  AIResponse response = await dialogflow.sendQuery("$query");
//  String resp = (response.getMessageResponse());
//}

class RulesScreen extends StatefulWidget {
  @override
  _RulesScreenState createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  NotificationEvent event;

  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    Notifications notifications = new Notifications();
    StreamSubscription<NotificationEvent> _events;
    _events = notifications.stream.listen(onData);
  }

  // ignore: missing_return
  Widget onData(NotificationEvent event) {
    messages.add(event.getText());
    for (String i in intents) {
      if (event.getText() == i) {
        print("message is $i");
        var index = intents.indexOf(i);
        print("response is ${responses[index]}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('Rules'),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'Logout':
                    Navigator.pushNamed(context, 'rule');
                    break;
                  case 'Settings':
                    Navigator.pushNamed(context, 'settings');
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green[900],
                ),
                accountName: Text("Meghna Jain"),
                accountEmail: Text("meghnaj98@gmail.com"),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                      Theme.of(context).platform == TargetPlatform.android
                          ? Colors.green
                          : Colors.white,
                  child: Text(
                    "M",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              child: Padding(
                padding: EdgeInsets.all(5.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    color: Colors.grey,
                    child: Text('Refresh'),
                    onPressed: () {
//                      responseFun(message);
                      print(intents);
                      print(responses);
                      print(ruleCount);
                      AlertDialog(
                        content: SingleChildScrollView(
                          child: ListBody(children: <Widget>[onData(event)]),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.builder(
                  itemCount: intents.length,
                  itemBuilder: (context, index) {
                    final msg = intents[index];
                    final res = responses[index];
                    message = msg;
                    response = res;
                    index++;
                    return Dismissible(
                        background: Container(color: Colors.red),
                        key: Key(msg),
                        onDismissed: (direction) {
                          direction = DismissDirection.horizontal;
                          setState(() {
                            intents.remove(msg);
                            responses.remove(res);
                            ruleCount--;
                            print(ruleCount);
                          });
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("${intents[index]} dismissed")));
                        },
                        child: RuleBox(m: msg, r: res));
                  }),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.green[900],
          onPressed: () {
            setState(() {
              ruleCount++;
            });
            Navigator.pushNamed(context, 'newrule');
            print(ruleCount);
          },
        ),
      ),
    );
  }
}

class RuleBox extends StatelessWidget {
  RuleBox({this.m, this.r});

  final String m;
  final String r;
  @override
  // ignore: missing_return
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: Colors.green[900], width: 3),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('$m'),
              Divider(
                color: Colors.green[900],
              ),
              Text('$r'),
            ],
          ),
        ),
      ),
    );
  }
}
