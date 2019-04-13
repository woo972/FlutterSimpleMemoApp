import 'package:flutter/material.dart';

class MemoWritingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text("save"),
              )  
            ],
          )
        ],
      )
    );
  }

}