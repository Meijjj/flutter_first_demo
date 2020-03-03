import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
const CATCH_URLS = ['m.ctrip.com', 'm.ctrip.com/html5/', 'm.ctrip.com/html5', 'm.ctrip.com/webapp/you/'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;  // 是否禁止返回

  const WebView({Key key, this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid=false}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = FlutterWebviewPlugin();  // 加载页面插件
  StreamSubscription<String> _onUrlChanged;   // StreamSubscription 监听url变化
  StreamSubscription<WebViewStateChanged> _onStateChanged;   // 加载变化状态监听
  StreamSubscription<WebViewHttpError> _onHttpError;   // 监听错误状态
  bool exiting = false;   // 避免重复返回

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {

    });
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch(state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !exiting) {  // 判断是否在白名单里面并且没有返回状态
            if (widget.backForbid) {  // 禁止返回的话就会加载当前页面
              webviewReference.launch(widget.url);
            } else {  // 否则返回上一页
              Navigator.pop(context);
              exiting = true;   // 返回状态
            }
          }
          break;
        default:
          break;
      }
    });
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  _isToMain(String url) {   // 判断url是否在白名单
    bool contain = false;
    for (final value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {    // ?.判断是否存在，不存在就不会执行是否包含url
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    super.dispose();
    webviewReference.dispose();  // 毁灭webview
    _onUrlChanged.cancel(); // 监听取消
    _onStateChanged.cancel();
    _onHttpError.cancel();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {    // 背景色是白色，返回按钮就是黑色的，反则亦之
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              withZoom: true, // 缩放
              withLocalStorage: true,
              hidden: true,
              initialChild: Container(color: Colors.white, child: Center(child: Text('waiting....'))),  // 初始化加载内容
            ),
          )
        ],
      )
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {    // 隐藏bar返回一个状态栏颜色
      return Container(color: backgroundColor, height: 30);
    }
    return Container(   // 不隐藏的状态下
      child: FractionallySizedBox(    // 填满屏幕
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            // 返回键
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close, color: backButtonColor, size: 26),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(widget.title ?? '', style: TextStyle(color: backButtonColor, fontSize: 20)),
              ),
            )
          ],
        ),
      ),
    );
  }
}