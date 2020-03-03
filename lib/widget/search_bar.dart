import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }  // 声明枚举类型
class SearchBar extends StatefulWidget {
  final bool enabled; // 是否禁止搜索
  final bool hideLeft;  // 搜索结果左边的是否显示
  final SearchBarType searchBarType;
  final String hint;  // 默认提示文案
  final String defaultText;
  final void Function() leftButtonClick;  // 左边按钮的回掉
  final void Function() rightButtonClick; // 右边按钮的回掉
  final void Function() speakClick;       // 按下语音的回掉
  final void Function() inputBoxClick;    // 输入框的回掉
  final ValueChanged<String> onChanged;   // 内容变化的回掉

  const SearchBar(
      {Key key,
        this.enabled = true,
        this.hideLeft,
        this.searchBarType = SearchBarType.normal,
        this.hint,
        this.defaultText,
        this.leftButtonClick,
        this.rightButtonClick,
        this.speakClick,
        this.inputBoxClick,
        this.onChanged}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false;   // 是否显示清除按钮
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {   // 语音说话的时候可以把文字带过去输入框显示
      setState(() {
        _controller.text = widget.defaultText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // normal显示默认正常的搜索样式
    return widget.searchBarType == SearchBarType.normal ? _genNormalSearch() : _genHomeSearch();
  }

  // 搜索页面
  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(Container(   // 左边的返回按钮，hideLeft
            padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
            // hideLeft 不存在就null否则就显示icon
            child: widget?.hideLeft ?? false ? null :
              Icon(Icons.arrow_back_ios, color: Colors.grey, size: 26),
          ), widget.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(Container(   // 右边的搜索按钮
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Text('搜索', style: TextStyle(color: Colors.blue, fontSize: 17)),
          ), widget.rightButtonClick),
        ],
      ),
    );
  }

  // 搜索框
  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(
          widget.searchBarType == SearchBarType.normal ? 5 : 15
        )
      ),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9) : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal ?
              new TextField(      // normal状态,搜索状态
                controller: _controller,
                onChanged: _onChanged,
                autofocus: true,
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300),
                decoration: InputDecoration(   // 输入文本框样式
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  border: InputBorder.none,
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(fontSize: 15)
                ),
              ) :
                _wrapTap(
                  Container(     // 首页不可以点击状态
                    child: Text(widget.defaultText, style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ), widget.inputBoxClick)),
          // showClear为true就显示清除按钮否则就显示语音按钮
          !showClear ? _wrapTap(
              Icon(
                Icons.mic,
                size: 22,
                color: widget.searchBarType == SearchBarType.normal ? Colors.blue : Colors.grey,
              ),
              widget.speakClick)
              : _wrapTap(Icon(Icons.clear, size: 22, color: Colors.grey), (){
                setState(() {
                  _controller.clear();
                });
                _onChanged('');
          })
        ],
      ),
    );
  }

  _onChanged(String text) {
    print(text);
    if (text.length > 0) {    // 如果搜索框有内容就显示清除按钮,否则显示语言按钮
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {  // 回掉函数
      widget.onChanged(text);
    }
  }

  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: (){
        if (callback != null) callback();
      },
      child: child,
    );
  }

  // 首页搜索
  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          // 左右显示区域
          _wrapTap(Container(
            padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
            child: Row(
              children: <Widget>[
                Text('上海', style: TextStyle(color: _homeFontColor(), fontSize: 14))
              ],
            ),
          ), widget.leftButtonClick),
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(Container(     // 消息按钮
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Icon(Icons.comment, color: _homeFontColor(), size: 26),
          ), widget.rightButtonClick),
        ],
      ),
    );
  }

  // 根据状态修改颜色
  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}