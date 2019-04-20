import 'package:flutter/material.dart';
import 'package:share/share.dart';

class MemoDescView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MemoDescViewState();  
}
class MemoDescViewState extends State<MemoDescView>{

  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();

  void _updateCategory(){

  }
  void _shareMemo(){
    Share.share('sharing test');
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("memo desc"),
        actions: <Widget>[
          ButtonBar(            
            children: <Widget>[              
              IconButton(
                icon: Icon(Icons.star),
                onPressed: _updateCategory,
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: _shareMemo,
              ),            ],
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: _titleController,            
          ),
          TextField(
            controller: _contentsController,
            maxLines: 900,
          )          
        ],
      ),
    );
  }
}