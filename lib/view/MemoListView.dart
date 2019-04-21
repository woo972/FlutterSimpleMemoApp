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
  String _searchText="";
  Icon _searchIcon = Icon(Icons.search);
  Widget _appBarTitle = Text('search');
  TextEditingController _filter = TextEditingController();
  List<MemoVo> memoList = List<MemoVo>();
  List<MemoVo> tempList = List<MemoVo>();


  MemoListViewState(){
    _filter.addListener((){
      if(_filter.text.isEmpty){
        setState(() {
          _searchText=""; 
        });        
      }else{
        setState(() {
          _searchText = _filter.text;              
          memoList = List<MemoVo>();
          for(int idx=0; idx<tempList.length; idx++){
            if(tempList[idx].contents.contains(_searchText)){
              memoList.add(tempList[idx]);
            }
          }
          
        });

      }
    });
  }
  
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
  void _sortMemoList(String baseCol){
    if(baseCol == 'updDate'){
      memoList.sort((a, b){ 
        int rslt = a.updDate.toString().toLowerCase().compareTo(
            b.updDate.toString().toLowerCase());
        return _reverseSort? rslt: -1*rslt;
      });
    }else{
      memoList.sort((a, b){
        int rslt =  a.title.toString().toLowerCase().compareTo(
            b.title.toString().toLowerCase());
        return _reverseSort? rslt: -1*rslt;
      });
    }
  }

  void _showSearch(){
    setState((){
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
            prefixIcon: new Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('MemoList');
        _filter.clear();
      }      
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
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
                            _sortMemoList("updDate");
                        },
                      ),
                      FlatButton(
                        child: Text("title"),
                        onPressed: (){
                          setState(() {
                            _reverseSort = !_reverseSort;
                            print(_reverseSort);
                          });
                            _sortMemoList("title");
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
            icon: _searchIcon,
            onPressed: () {
              _showSearch();
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
            memoList = snapshot.data;
            tempList = memoList;            
            return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: memoList.length,
                itemBuilder: (BuildContext context, int idx) {
                  MemoVo item = memoList[idx];
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
