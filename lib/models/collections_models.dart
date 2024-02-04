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

class Collection {
  String id;
  String name;
  String series;
  int printedTotal;
  int total;
  Legalities legalities;
  String ptcgoCode;
  String releaseDate;
  String updatedAt;
  Images images;

  Collection({
    required this.id,
    required this.name,
    required this.series,
    required this.printedTotal,
    required this.total,
    required this.legalities,
    required this.ptcgoCode,
    required this.releaseDate,
    required this.updatedAt,
    required this.images,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
        id: json["id"],
        name: json["name"],
        series: json["series"],
        printedTotal: json["printedTotal"],
        total: json["total"],
        legalities: Legalities.fromJson(json["legalities"]),
        ptcgoCode: json["ptcgoCode"].toString(),
        releaseDate: json["releaseDate"].toString(),
        updatedAt: json["updatedAt"].toString(),
        images: Images.fromJson(json["images"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "series": series,
        "printedTotal": printedTotal,
        "total": total,
        "legalities": legalities,
        "ptcgoCode": ptcgoCode,
        "releaseDate": releaseDate,
        "updatedAt": updatedAt,
        "images": images,
      }; 

}

class Images {
  String? symbol;
  String? logo;
  String? small;
  String? large;
  
  Images({
    this.symbol,
    this.logo,
    this.small,
    this.large,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      symbol: json["symbol"],
      logo: json["logo"],
      small: json["small"],
      large: json["large"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (symbol != null) {
      data["symbol"] = symbol;
    }

    if (logo != null) {
      data["logo"] = logo;
    }

    if (small != null) {
      data["small"] = small;
    }

    if (large != null) {
      data["large"] = large;
    }

    return data;
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

class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String hp;
  final List<String> types;
  final int? convertedRetreatCost;
  final Collection set;
  final String number;
  final String artist;
  final String rarity;
  final List<int> nationalPokedexNumbers;
  final Images images;
  

  PokemonCard({
    required this.id,
    required this.name,
    required this.images,
    required this.supertype,
    required this.subtypes,
    required this.hp,
    required this.types,
    required this.convertedRetreatCost,
    required this.set,
    required this.number,
    required this.artist,
    required this.rarity,
    required this.nationalPokedexNumbers,

    
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
  return PokemonCard(
    id: json['id'],
    name: json['name'] ?? '',  
    images: Images.fromJson(json['images']),
    supertype: json['supertype'] ?? '',  
    subtypes: List<String>.from(json['subtypes'] ?? []),
    hp: json['hp'] ?? '',  
    types: List<String>.from(json['types'] ?? []),
    convertedRetreatCost: json['convertedRetreatCost'] ?? 0,  
    set: Collection.fromJson(json['set']),
    number: json['number'] ?? '',  
    artist: json['artist'] ?? '',  
    rarity: json['rarity'] ?? '',  
    nationalPokedexNumbers: List<int>.from(json['nationalPokedexNumbers'] ?? []),
  );
}


  @override
  String toString() {
    return 'PokemonCard(id: $id, name: $name)';
  }
}

class Ability {
  final String name;
  final String text;
  final String type;

  Ability({
    required this.name,
    required this.text,
    required this.type,
  });

  factory Ability.fromJson(Map<String, dynamic> json) {
    return Ability(
      name: json['name'],
      text: json['text'],
      type: json['type'],
    );
  }
}

class Attack {
  final String name;
  final List<String> cost;
  final int convertedEnergyCost;
  final String damage;
  final String text;

  Attack({
    required this.name,
    required this.cost,
    required this.convertedEnergyCost,
    required this.damage,
    required this.text,
  });

  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'],
      cost: List<String>.from(json['cost']),
      convertedEnergyCost: json['convertedEnergyCost'],
      damage: json['damage'],
      text: json['text'],
    );
  }
}

class Weakness {
  final String type;
  final String value;

  Weakness({
    required this.type,
    required this.value,
  });

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'],
      value: json['value'],
    );
  }
}

class TcgPlayer {
  final String url;
  final String updatedAt;
  final Prices prices;

  TcgPlayer({
    required this.url,
    required this.updatedAt,
    required this.prices,
  });

  factory TcgPlayer.fromJson(Map<String, dynamic> json) {
    return TcgPlayer(
      url: json['url'],
      updatedAt: json['updatedAt'],
      prices: Prices.fromJson(json['prices']),
    );
  }
}

class Prices {
  final PriceInfo normal;
  final PriceInfo reverseHolofoil;

  Prices({
    required this.normal,
    required this.reverseHolofoil,
  });

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      normal: PriceInfo.fromJson(json['normal']),
      reverseHolofoil: PriceInfo.fromJson(json['reverseHolofoil']),
    );
  }
}

class PriceInfo {
  final double low;
  final double mid;
  final double high;
  final double market;
  final double directLow;

  PriceInfo({
    required this.low,
    required this.mid,
    required this.high,
    required this.market,
    required this.directLow,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      low: json['low'].toDouble(),
      mid: json['mid'].toDouble(),
      high: json['high'].toDouble(),
      market: json['market'].toDouble(),
      directLow: json['directLow'].toDouble(),
    );
  }
}

class Cardmarket {
  final String url;
  final String updatedAt;
  final CardmarketPrices prices;

  Cardmarket({
    required this.url,
    required this.updatedAt,
    required this.prices,
  });

  factory Cardmarket.fromJson(Map<String, dynamic> json) {
    return Cardmarket(
      url: json['url'],
      updatedAt: json['updatedAt'],
      prices: CardmarketPrices.fromJson(json['prices']),
    );
  }
}

class CardmarketPrices {
  final double averageSellPrice;
  final double lowPrice;
  final double trendPrice;
  final double? germanProLow;
  final double? suggestedPrice;
  final double? reverseHoloSell;
  final double? reverseHoloLow;
  final double? reverseHoloTrend;
  final double lowPriceExPlus;
  final double avg1;
  final double avg7;
  final double avg30;
  final double? reverseHoloAvg1;
  final double? reverseHoloAvg7;
  final double? reverseHoloAvg30;

  CardmarketPrices({
    required this.averageSellPrice,
    required this.lowPrice,
    required this.trendPrice,
    required this.germanProLow,
    required this.suggestedPrice,
    required this.reverseHoloSell,
    required this.reverseHoloLow,
    required this.reverseHoloTrend,
    required this.lowPriceExPlus,
    required this.avg1,
    required this.avg7,
    required this.avg30,
    required this.reverseHoloAvg1,
    required this.reverseHoloAvg7,
    required this.reverseHoloAvg30,
  });

  factory CardmarketPrices.fromJson(Map<String, dynamic> json) {
    return CardmarketPrices(
      averageSellPrice: json['averageSellPrice'].toDouble(),
      lowPrice: json['lowPrice'].toDouble(),
      trendPrice: json['trendPrice'].toDouble(),
      germanProLow: json['germanProLow']?.toDouble(),
      suggestedPrice: json['suggestedPrice']?.toDouble(),
      reverseHoloSell: json['reverseHoloSell']?.toDouble(),
      reverseHoloLow: json['reverseHoloLow']?.toDouble(),
      reverseHoloTrend: json['reverseHoloTrend']?.toDouble(),
      lowPriceExPlus: json['lowPriceExPlus'].toDouble(),
      avg1: json['avg1'].toDouble(),
      avg7: json['avg7'].toDouble(),
      avg30: json['avg30'].toDouble(),
      reverseHoloAvg1: json['reverseHoloAvg1']?.toDouble(),
      reverseHoloAvg7: json['reverseHoloAvg7']?.toDouble(),
      reverseHoloAvg30: json['reverseHoloAvg30']?.toDouble(),
    );
  }
}

