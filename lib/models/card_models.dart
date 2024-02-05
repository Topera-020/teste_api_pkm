
class PokemonCard {
  final String id;
  final String name;
  final String supertype;
  final List<String> subtypes;
  final String hp;
  final List<String> types;
  final int? convertedRetreatCost;
  final String setId;
  final String number;
  final String artist;
  final String rarity;
  final List<int> nationalPokedexNumbers;
  final String small;
  final String large;
  

  PokemonCard({
    required this.id,
    required this.name,
    required this.small,
    required this.large,
    required this.supertype,
    required this.subtypes,
    required this.hp,
    required this.types,
    required this.convertedRetreatCost,
    required this.setId,
    required this.number,
    required this.artist,
    required this.rarity,
    required this.nationalPokedexNumbers,

    
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
  return PokemonCard(
    id: json['id'],
    name: json['name'] ?? '',  
    small:json["images"]["small"],
    large:json["images"]["large"],
    supertype: json['supertype'] ?? '',  
    subtypes: List<String>.from(json['subtypes'] ?? []),
    hp: json['hp'] ?? '',  
    types: List<String>.from(json['types'] ?? []),
    convertedRetreatCost: json['convertedRetreatCost'] ?? 0,  
    setId: json['set'],
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

