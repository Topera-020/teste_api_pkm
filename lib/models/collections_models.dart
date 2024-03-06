class Collection {
  String id;
  String name;
  String series;
  int printedTotal;
  int total;
  String ptcgoCode;
  String releaseDate;
  String symbolImg;
  String logoImg;
  int totalHave;

  Collection({
    required this.id,
    required this.name,
    required this.series,
    required this.printedTotal,
    required this.total,
    required this.ptcgoCode,
    required this.releaseDate,
    required this.symbolImg,
    required this.logoImg,
    required this.totalHave
  });

  

  factory Collection.fromMap(Map<String, dynamic> data) => Collection(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    series: data['series'] ?? '',
    printedTotal: data['printedTotal'] ?? 0,
    total: data['total'] ?? 0,
    ptcgoCode: data['ptcgoCode'].toString(),
    releaseDate: data['releaseDate'].toString(),
    symbolImg: data['symbolImg'] ?? data["images"]["symbol"] ?? '',
    logoImg: data['logoImg'] ?? data["images"]["logo"]?? '',
    totalHave: data['totalHave'] ?? 0,
  );


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'set_name': name,
      'series': series,
      'printedTotal': printedTotal,
      'total': total,
      'ptcgoCode': ptcgoCode,
      'releaseDate': releaseDate,
      'symbolImg': symbolImg,
      'logoImg': logoImg,
    };
  }
}





/* class Legalities {
  bool unlimited;
  bool standard;
  bool expanded;

  Legalities({
    required this.unlimited,
    required this.standard,
    required this.expanded,
  });

  factory Legalities.fromJson(Map<String, dynamic> json) => Legalities(
        unlimited: json["legalities"]?["unlimited"] == "Legal",
        standard: json["legalities"]?["standard"] == "Legal",
        expanded: json["legalities"]?["expanded"] == "Legal",
      );

  Map<String, dynamic> toJson() => {
        "unlimited": unlimited ? "Legal" : "Not Legal",
        "standard": standard ? "Legal" : "Not Legal",
        "expanded": expanded ? "Legal" : "Not Legal",
      };
}

*/