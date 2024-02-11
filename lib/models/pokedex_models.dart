class Pokemon {
  final int id;
  final String name;
  final bool isDefault;
  final int height;
  final int weight;
  final List<Form> forms;
  final List<String> types;

  Pokemon({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.isDefault,
    required this.forms,
    required this.types,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    List<Form> formsList = [];

    if (json.containsKey('forms') && (json['forms'] as List<dynamic>).length > 1) {
      formsList.addAll((json['forms'] as List<dynamic>).map((form) => Form.fromJson(form)).toList());
    }

    if (json['sprites']['other']['home'] != null) {
      formsList.addAll((json['sprites']['other']['home'] as List<dynamic>)
          .map((form) => Form.fromJson(form))
          .toList());
    }

    return Pokemon(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      forms: formsList,
      types: (json['types'] as List<dynamic>)
          .map((type) => type['name'].toString())
          .toList(),
      isDefault: json['is_default'],
    );
  }
}

class Form {
  final String name;
  final String url;

  Form({required this.name, required this.url});

  factory Form.fromJson(Map<String, dynamic> json) {
    return Form(
      name: json['name'],
      url: json['url'],
    );
  }
}
