class Collection {
  String id;
  String name;
  String series;
  int printedTotal;
  int total;
  String ptcgoCode;
  String releaseDate;
  String symbol;
  String logo;

  Collection({
    required this.id,
    required this.name,
    required this.series,
    required this.printedTotal,
    required this.total,
    required this.ptcgoCode,
    required this.releaseDate,
    required this.symbol,
    required this.logo,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        name: json["name"],
        series: json["series"],
        printedTotal: json["printedTotal"],
        total: json["total"],
        ptcgoCode: json["ptcgoCode"].toString(),
        releaseDate: json["releaseDate"].toString(),
        symbol: json["images."]["symbol"],
        logo: json["images"]["logo"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "series": series,
        "printedTotal": printedTotal,
        "total": total,
        "ptcgoCode": ptcgoCode,
        "releaseDate": releaseDate,
        "symbol": symbol,
        "logo": logo,
      }; 

  factory Collection.fromDB(Map<String, dynamic> data) {
    return Collection(
      id: data['id'],
      name: data['set_name'],
      series: data['series'],
      printedTotal: data['printedTotal'],
      total: data['total'],
      ptcgoCode: data['ptcgoCode'],
      releaseDate: data['releaseDate'],
      symbol: data['Symbol'],
      logo: data['Logo'], 
      
    );

}
}

class Legalities {
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

