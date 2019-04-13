import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:memo/vo/Memo.dart';
import 'package:memo/view/memoWritingView.dart';

class MemoListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemoListViewState();
}

class MemoListViewState extends State<MemoListView> {
  
  final List<WordPair> _suggestions = <WordPair>[];
  final List<MemoVo> _memoList = <MemoVo>[];

  void _routeMemoWriting(){
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=> MemoWritingView())
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('memoList'),        
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),            
          ),
        ],
      ),      
      body:_buildMemoList(),   
      floatingActionButton: FloatingActionButton(
        onPressed: _routeMemoWriting,
      ),  
    );
  }

  Widget _buildMemoList(){
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemBuilder: (BuildContext context, int idx){
        if(idx >= _suggestions.length){
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[idx]);
      }
    );
  }

  Widget _buildRow(WordPair pair){
    return ListTile(
      title: Text(
        pair.asPascalCase,                
      ),
      trailing: Icon(
        Icons.star
      ),
      onTap: (){
        setState(() {
            
        });
      },
    );
  }
}
