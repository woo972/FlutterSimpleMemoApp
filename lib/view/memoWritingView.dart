import 'package:flutter/material.dart';
import 'package:memo/vo/Memo.dart';
import 'package:memo/dao/DbProvider.dart';

DateTime now = DateTime.now();


class MemoWritingView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => MemoWritingViewState();
}

class MemoWritingViewState extends State<MemoWritingView> {

  final dbProvider = DbProvider.dbProviderInstance;     
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentsController = TextEditingController();
  
  final String _updDate = "${now.year}${now.month}${now.day}";  
  bool _isImportant = false;
  void _toggleIsImportant(bool v){   
    setState(() => _isImportant = v );
  }


  void _saveMemo() async {
    print('date:'+_updDate);
    if(_contentsController.text.isNotEmpty){
      MemoVo memo = MemoVo(
        title:_titleController.text,
        contents:_contentsController.text,
        updDate:_updDate,
        category:_isImportant?"IMPORTANT":"NOMAL",
      );
      await dbProvider.saveMemo(memo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("write your memo"),
        actions: <Widget>[
          Checkbox( 
            value: _isImportant,
            onChanged: _toggleIsImportant,                   
            activeColor: Colors.red,
          )
        ],
      ),
      body: Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _titleController,
                onChanged: (v) =>_titleController.text = v,                  
                decoration: InputDecoration(
                  labelText: "title", 
                  prefixIcon: Icon(Icons.mode_edit)
                ),
              ),              
            ),
            // important mark
            // date
          ],
        ),
        Divider(),
        Expanded(          
          child: TextField(
            controller: _contentsController,
            onChanged: (v) =>_contentsController.text = v,
            decoration: InputDecoration(
              labelText: "contents",
              prefixIcon: Icon(Icons.mode_edit)
            ),
          ),
        ),
        Divider(),
        ButtonBar(
          children: <Widget>[
            RaisedButton(
              child: Text("save"),
              onPressed: () {
                _saveMemo();
                Navigator.pop(context);
              },
            )
          ],
        )
      ],
    ));
  }


}
