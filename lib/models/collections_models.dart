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
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        name: json["name"],
        series: json["series"],
        printedTotal: json["printedTotal"],
        total: json["total"],
        ptcgoCode: json["ptcgoCode"].toString(),
        releaseDate: json["releaseDate"].toString(),
        symbolImg: json["images"]["symbol"],
        logoImg: json["images"]["logo"],
      );

  factory Collection.fromMap(Map<String, dynamic> data) => Collection(
    id: data['id'] ?? '',
    name: data['name'] ?? '',
    series: data['series'] ?? '',
    printedTotal: data['printedTotal'] ?? 0,
    total: data['total'] ?? 0,
    ptcgoCode: data['ptcgoCode'] ?? '',
    releaseDate: data['releaseDate'] ?? '',
    symbolImg: data['symbolImg'] ?? '',
    logoImg: data['logoImg'] ?? '',
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