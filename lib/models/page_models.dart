// ignore_for_file: public_member_api_docs, sort_constructors_first
class Page {
  List<Map<String, dynamic>> data;
  int page;
  int pageSize;
  int count;
  int totalCount;

  Page({
    required this.data,
    required this.page,
    required this.pageSize,
    required this.count,
    required this.totalCount,
  });

  factory Page.fromJson(Map<String, dynamic> json) => Page(
    data: (json['data'] as List).map((item) => item as Map<String, dynamic>).toList(),
    page: json['page'],
    pageSize: json['pageSize'],
    count: json['count'],
    totalCount: json['totalCount'],
  );
}