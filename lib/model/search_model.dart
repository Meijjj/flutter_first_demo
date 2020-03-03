// 搜索模型
class SearchModel {
  final List<SearchItem> data;
  String keyword;

  SearchModel({ this.data });
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;    // 转换成List类型
    List<SearchItem> data = dataJson.map((i) => SearchItem.fromJson(i)).toList();
    return SearchModel(data: data);
  }
}

class SearchItem {
  final String word;          // XX酒店
  final String type;          // hotel
  final String price;         // 实时计价
  final String star;          // 豪华型
  final String zonename;      // 虹桥
  final String districtname;
  final String url;

  SearchItem({this.word, this.type, this.price, this.star, this.zonename,
    this.districtname, this.url});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      word: json['word'],
      type: json['type'],
      price: json['price'],
      star: json['star'],
      zonename: json['zonename'],
      districtname: json['districtname'],
      url: json['url'],
    );
  }

}