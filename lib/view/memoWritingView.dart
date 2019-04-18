import 'package:flutter/material.dart';
import 'package:memo/vo/Memo.dart';
import 'package:memo/dao/DbProvider.dart';

class MemoWritingView extends StatelessWidget {

  final dbProvider = DbProvider.dbProviderInstance;   
  final TextEditingController _contentsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("write your memo"),
      ),
      body: Column(
      children: <Widget>[
        Divider(),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
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

  void _saveMemo() async {
    final memo = MemoVo(      
      title:"title1",
      contents:"contents1",
      updDate:"20190101",
      category:"A",
    );
    print('memo::${memo.title}');
    await dbProvider.saveMemo(memo);
  }
}
