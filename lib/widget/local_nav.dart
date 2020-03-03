import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({ Key key, @required this.localNavList }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      child: Padding(padding: EdgeInsets.all(7), child: _items(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6))
      ),
    );
  }

  _items(BuildContext context) {      // 列表元素
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items);
  }

  _item(BuildContext context, CommonModel model) {  // 单个元素
    return GestureDetector(     // 触摸
      child: Column(
        children: <Widget>[
          Image.network(model.icon, width: 32, height: 32),
          Text(model.title, style: TextStyle(fontSize: 12))
        ],
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
          WebView(url: model.url, statusBarColor: model.statusBarColor, hideAppBar: model.hideAppBar)
        ));
      },
    );
  }
}