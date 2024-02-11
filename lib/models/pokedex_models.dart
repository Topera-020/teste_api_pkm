class PokedexEntry {
  final int id;
  final int pokedexNumber;
  final String? evolvesFromSpecies;
  final String name; // Variedade
  final bool isDefault;
  final int height;
  final int weight;
  final List<String> types;
  final bool isBaby;
  final bool isLegendary;
  final bool isMythical;
  final List<String>? varieties; 
  final String officialArtwork; 
  final String? shiny;
  final String? female; 
  final String? shinyFemale;

  

  PokedexEntry({
    required this.id,
    required this.pokedexNumber,
    required this.evolvesFromSpecies,
    required this.name,
    required this.isDefault,
    required this.height,
    required this.weight,
    required this.types,
    required this.isBaby,
    required this.isLegendary,
    required this.isMythical,
    required this.officialArtwork, 
     this.varieties,
     this.shiny, 
     this.female, 
     this.shinyFemale,
  });

}



