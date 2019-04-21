import 'package:flutter/material.dart';
import 'package:memo/dao/DbProvider.dart';
import 'package:memo/view/MemoDescView.dart';
import 'package:memo/vo/Memo.dart';
import 'package:memo/view/MemoWritingView.dart';
import 'package:share/share.dart';

class MemoListView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MemoListViewState();
}

class MemoListViewState extends State<MemoListView> {
  final dbProvider = DbProvider.dbProviderInstance;

  bool _reverseSort=false;

  void _routeMemoWriting() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MemoWritingView()));
  }

  void _routeMemoDesc(int memoId) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MemoDescView(memoId)));
  }

  void _removeMemo(int memoId) {
    dbProvider.removeMemo(memoId);
  }

  void _shareMemo(MemoVo memo){
    Share.share('${memo.title}\n${memo.contents}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('memoList'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context){
                  return AlertDialog(
                    title: Text("sort by ..."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("upd date"),
                        onPressed: (){
                          setState(() {
                            _reverseSort = !_reverseSort;

                          });
                        },
                      ),
                      FlatButton(
                        child: Text("title"),
                        onPressed: (){
                          setState(() {
                            _reverseSort = !_reverseSort;

                          });
                        },
                        // onPressed: ,
                      ),
                    ],
                  );
                }
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
              );
            },
          ),
        ],
      ),
      body: _buildMemoList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _routeMemoWriting,
      ),
    );
  }

  Widget _buildMemoList() {
    return FutureBuilder<List<MemoVo>>(
        future: DbProvider.dbProviderInstance.getMemoList(),
        builder: (BuildContext context, AsyncSnapshot<List<MemoVo>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int idx) {
                  MemoVo item = snapshot.data[idx];
                  return _buildRow(item);
                });
          }else{
            return Container(width: 0, height: 0,);
          }
        });
  }

  Widget _buildRow(MemoVo memo) {
    return Dismissible(
      key: ObjectKey(memo.id),
      background: Container(color: Colors.red),
      onDismissed: (direction) {
        _removeMemo(memo.id);
      },
      child: ListTile(
          // onTap: () => _routeMemoDesc(memo.id),
          leading: Text(
            memo.updDate,
          ),
          title: Text(
            memo.title,
          ),
          subtitle: Text(
            memo.contents,
          ),
          trailing: ButtonBar(
            children: <Widget>[
              GestureDetector(
                child: Icon(Icons.share),                
                onTap: (){
                  _shareMemo(memo);  
                } 
              ),
              memo.category == 'IMPORTANT'
                  ? Icon(Icons.star)
                  : Icon(Icons.star_border),
        ],
      )),
    );
  }
}
