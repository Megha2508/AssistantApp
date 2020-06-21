import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

List intents = [];
List responses = [];

// ignore: must_be_immutable
class NewRule extends StatelessWidget {
  String intent;
  String response;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.green[900]),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: Colors.green[900], width: 3),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              alignment: PlaceholderAlignment.belowBaseline,
                              baseline: TextBaseline.alphabetic,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 245),
                                child: TextField(
                                  maxLines: null,
                                  decoration:
                                      InputDecoration(hintText: 'Message'),
                                  onChanged: (value) {
                                    intent = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(color: Colors.black),
                          children: <InlineSpan>[
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(maxWidth: 245),
                                child: TextField(
                                  maxLines: null,
                                  decoration:
                                      InputDecoration(hintText: 'Response'),
                                  onChanged: (value) {
                                    response = value;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text('Save'),
                        onPressed: () {
                          intents.add(intent);
                          responses.add(response);
                          print(intents.length);
                          Navigator.pushNamed(context, 'rule');
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
