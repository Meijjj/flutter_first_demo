import 'package:flutter/material.dart';

// 加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading; // 是否加载
  final bool cover; // 是否展示在child前面

  const LoadingContainer(
      { Key key,
        @required this.isLoading,
        @required this.child,
        this.cover = false})
  :super(key: key);

  @override
  Widget build(BuildContext context) {
    // 没有 cover isLoading 就加载child 否则就展示loading
    return !cover ? !isLoading ? child : _loadingView
        :
        // cover为true并且isLoading的话就展示loading在child上
    Stack(
      children: <Widget>[child, isLoading ? _loadingView : null],
    );
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}