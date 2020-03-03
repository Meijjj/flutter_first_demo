import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/widget/webview.dart';

// 网格布局
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({ Key key, @required this.gridNavModel }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),   // 添加圆角
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }
  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  // 单个item 左中右组合
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
    List<Widget> items = [];
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = [];
    items.forEach((item){     // 垂直平均分撑满三个元素
      expandItems.add(Expanded(child: item, flex: 1,));
    });
    return Container(   // 如果是第一个container就需要顶部的margin
      height: 88,
      margin: first ? null : EdgeInsets.only(top: 3),
      child: Row(children: expandItems),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [startColor, endColor])),  // 背景色渐变
    );
  }
  // 左边的主要容器 点就可跳转h5页面
  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(context, Stack(
      alignment: AlignmentDirectional.topCenter,
      children: <Widget>[
        Image.network(
          model.icon,
          fit: BoxFit.contain,
          height: 88,
          width: 121,
          alignment: AlignmentDirectional.bottomEnd,
        ),
        Container(
          margin: EdgeInsets.only(top: 11),
          child: Text(model.title, style: TextStyle(fontSize: 14, color: Colors.white)),
        )
      ],
    ), model);
  }

  // 右边的文字容器【结合上下元素组成】
  _doubleItem(BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(child: _item(context, topItem, true)),
        Expanded(child: _item(context, bottomItem, false)),
      ],
    );
  }

  _item(BuildContext context, CommonModel item, bool first) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,   // 撑满父布局的宽度
      child: Container(
        child: _wrapGesture(
            context,
            Center(
              child: Text(item.title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.white)
            ),
        ), item),
        decoration: BoxDecoration(
          // 上边的元素需要底部的边距
          border: Border(left: borderSide, bottom: first ? borderSide : BorderSide.none)
        ),
      ),
    );
  }

  // 跳转页面的容器，接收widget,model
  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      child: widget,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            WebView(
                url: model.url,
                title: model.title,
                statusBarColor: model.statusBarColor,
                hideAppBar: model.hideAppBar
            )
        ));
      },
    );
  }
}