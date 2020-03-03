import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widget/search_bar.dart';
import 'package:flutter_trip/widget/webview.dart';
const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const TYPES = [
  'chaneelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];

class SearchPage extends StatefulWidget {
  @override
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint}) : super(key: key);

  _SearchPageState createState() => _SearchPageState();
}

// 内部类
class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: <Widget>[
            _appBar(),
            MediaQuery.removePadding(
              removeTop: true,    // 去掉顶部的padding
              context: context,
              child: Expanded(     // 充满高度
                flex: 1,
                child: ListView.builder(
                  // 判断是否有searchModel，searchModel.data，searchModel.data.length 没有默认返回0
                  itemCount: searchModel?.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return _item(position);
                  },
                ),
              )
            )
          ],
        )
    );
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          // appBar渐变遮罩背景
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            )
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);   // 返回上一页
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _onTextChange(text) {
    keyword = text;
    if (text.length == 0) {     // 没有输入的话列表内容为空
     setState(() {
       searchModel = null;
     });
     return;
    }
    String url = widget.searchUrl + text;       // 输入搜索内容请求地址
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == keyword) {   // 当前输入的内容和服务端返回的一致就渲染
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 23,
                width: 23,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(width: 300, child: _title(item)),
                Container(width: 300, child: _subTitle(item))
              ],
            )
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          WebView(url: item.url, title: '详情')
        ));
      },
    );
  }

  //  动态icon显示
  _typeImage(String type) {
    if (type == null) return 'images/type_travlegroup.png';
    String path = 'travelgroup';    // 默认icon
    for (final val in TYPES) {
      if (type.contains(val)) {   // 如果传的icon值包含在type中
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItem item) {  // 上边显示的文字
    if (item == null) { return null; }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
      text: ' ' + (item.districtname ?? '') + '' + (item.zonename ?? ''),
      style: TextStyle(fontSize: 16, color: Colors.grey)
    ));
    return RichText(text: TextSpan(children: spans));   // 包裹不同样式的文字
  }

  // 关键字要高亮显示
  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    List<String> arr = word.split(keyword);   // 根据输入内容分割字符串分别给不同样式
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0;i < arr.length; i++) {
      if ((i+1) % 2 == 0) {   // 如果能分割成两个或以上就是有高亮的字符串
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _subTitle(SearchItem item) {  // 下边显示的文字
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(text: item.price ?? '', style: TextStyle(fontSize: 16, color: Colors.orange)),
          TextSpan(text: ' ' + (item.star ?? ''), style: TextStyle(fontSize: 12, color: Colors.grey))
        ]
      ),
    );
  }
}