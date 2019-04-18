import 'package:flutter/material.dart';
import 'package:memo/dao/DbProvider.dart';
import 'package:memo/vo/Memo.dart';
import 'package:memo/view/MemoWritingView.dart';

class MemoListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemoListViewState();
}

class MemoListViewState extends State<MemoListView> {
  
  final dbProvider = DbProvider.dbProviderInstance;   
  void _routeMemoWriting(){
    Navigator.push(
      context, MaterialPageRoute(builder: (context)=> MemoWritingView())
    );
  }
  _removeMemo(int memoId){
    dbProvider.removeMemo(memoId);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('memoList'),        
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {},            
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
    return FutureBuilder<List<MemoVo>>(
      future: DbProvider.dbProviderInstance.getMemoList(),
      builder: (BuildContext context, AsyncSnapshot<List<MemoVo>> snapshot){
        if(snapshot.hasData){
          return ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: snapshot.data.length,            
            itemBuilder: (BuildContext context, int idx){
              MemoVo item = snapshot.data[idx];              
              return _buildRow(item);
            }
          );
        }
      }
    );
  }

  Widget _buildRow(MemoVo memo){
    return Dismissible(
      key: ObjectKey(memo.id),
      background: Container(
        color:Colors.red
      ),
      onDismissed: (direction){
        _removeMemo(memo.id);
      },
      child: ListTile(
        leading: Text(
          memo.category,
        ),
        title: Text(
          memo.title,                        
        ),
        subtitle: Text(
          memo.contents,
        ),
        trailing: RaisedButton(
          child: memo.category=='A'?Icon(Icons.star):Icon(Icons.star_border),                
          onPressed: () async {
            
          } 
        ),            
        onTap: (){
          setState(() {
              
          });
        },
      ),
    );
  }
}
