import 'package:flutter/material.dart';
import 'package:memo/dao/DbProvider.dart';
import 'package:memo/vo/Memo.dart';
import 'package:share/share.dart';

class MemoDescView extends StatefulWidget {
  final memoId;
  MemoDescView(this.memoId);

  @override  
  State<StatefulWidget> createState() => MemoDescViewState(memoId);
}

DateTime now = DateTime.now();

class MemoDescViewState extends State<MemoDescView> {
  final memoId;
  MemoVo memo;
  MemoDescViewState(this.memoId);
  

  final dbProvider = DbProvider.dbProviderInstance;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentsController = TextEditingController();

  final String _updDate = "${now.year}${now.month}${now.day}";
  bool _isImportant = false;
  void _toggleIsImportant(bool v) {
    setState(() => _isImportant = v);
  }

  void _shareMemo() {
    Share.share('sharing test');
  }

  void _updateMemo() async {
    if(_contentsController.text.isNotEmpty){
      MemoVo memo = MemoVo(
        id:memoId,
        title:_titleController.text,
        contents:_contentsController.text,
        updDate:_updDate,
        category:_isImportant?"IMPORTANT":"NOMAL",
      );
      await dbProvider.updateMemo(memo);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("memo desc"),
        actions: <Widget>[
          ButtonBar(
            children: <Widget>[
              Checkbox(
                value: _isImportant,
                onChanged: (v) => _toggleIsImportant,
                activeColor: Colors.red,
              ),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () => _shareMemo,
              ),
            ],
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
