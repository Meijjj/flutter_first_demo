import 'dart:convert';
import 'dart:async';
import 'package:flutter_trip/model/home_model.dart';
import 'package:http/http.dart' as http;
const HOME_URL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

// 首页接口
class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));  //  解码，解决乱码问题
      return HomeModel.formJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}