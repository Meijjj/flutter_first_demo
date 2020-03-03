import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widget/webview.dart';

// 底部卡片入口
class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;

  const SalesBox({ Key key, @required this.salesBox }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: _items(context),
      decoration: BoxDecoration(color: Colors.white),
    );
  }

  _items(BuildContext context) {      // 列表
    if (salesBox == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(context, salesBox.bigCard1, salesBox.bigCard2, true, false));
    items.add(_doubleItem(context, salesBox.smallCard1, salesBox.smallCard2, false, false));
    items.add(_doubleItem(context, salesBox.smallCard3, salesBox.smallCard4, false, true));

    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(salesBox.icon, height: 15, fit: BoxFit.fill),  // 左边的热门活动icon
              Container(    // 右边的获取更多福利
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight
                  )
                ),
                child: GestureDetector(
                  child: Text('获取更多福利 >', style: TextStyle(color: Colors.white, fontSize: 12)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      WebView(url: salesBox.moreUrl, title: '更多活动')
                    ));
                  },
                ),
              )
            ],
          ),
        ),
        // 下边的卡片展示
        Row(mainAxisAlignment: MainAxisAlignment.center, children: items.sublist(0, 1)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: items.sublist(1, 2)),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: items.sublist(2, 3)),
      ],
    );
  }

  // 左边卡片+右边卡片
  Widget _doubleItem(BuildContext context, CommonModel leftCard, CommonModel rightCard, bool big, bool last) {
    // last最后一个
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        _item(context, leftCard, big, true, last),
        _item(context, rightCard, big, false, last),
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool big, bool left, bool last) {  // 单个元素
    BorderSide borderSide = BorderSide(width: 0.8, color: Color(0xfff2f2f2));  // 边框一侧
    return GestureDetector(     // 触摸
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            right: left ? borderSide : BorderSide.none,
            bottom: last ? BorderSide.none : borderSide   // 最后一个元素底部无需装饰
          )
        ),
        child: Image.network(
          model.icon,
          fit: BoxFit.fill,
          height: big ? 129 : 80,   // 区别大小卡片的高度
          width: MediaQuery.of(context).size.width / 2- 10, // 获取屏幕宽度的一半，因为两个卡片宽度是一样的
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(url: model.url, statusBarColor: model.statusBarColor, hideAppBar: model.hideAppBar)
        ));
      },
    );
  }
}