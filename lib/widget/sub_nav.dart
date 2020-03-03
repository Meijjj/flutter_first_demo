import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({ Key key, @required this.subNavList }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(padding: EdgeInsets.all(7), child: _items(context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6)
      ),
    );
  }

  _items(BuildContext context) {      // 列表元素
    if (subNavList == null) return null;
    List<Widget> items = [];
    subNavList.forEach((model) {
      items.add(_item(context, model));
    });
    // 计算出第一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(    // 分成两行
      children: <Widget>[
        // 分割
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items.sublist(0, separate)),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items.sublist(separate, subNavList.length)),
        )
      ],
    );
//    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items);
  }

  _item(BuildContext context, CommonModel model) {  // 单个元素
    return Expanded(
      flex: 1,    // 填满一行
      child: GestureDetector(     // 触摸
        child: Column(
          children: <Widget>[
            Image.network(model.icon, width: 18, height: 18),
            Padding(
                padding: EdgeInsets.only(top: 3),
                child: Text(model.title, style: TextStyle(fontSize: 12))
            )
          ],
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              WebView(url: model.url, statusBarColor: model.statusBarColor, hideAppBar: model.hideAppBar)
          ));
        },
      ),
    );
  }
}