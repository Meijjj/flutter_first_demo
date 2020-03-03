import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    // text 当前输入框的搜索内容
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));  //  解码，解决乱码问题
      // 只有当当前输入内容和服务端内容返回一致的时候渲染
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    } else {
      throw Exception('Failed to load search_page.json');
    }
  }
}