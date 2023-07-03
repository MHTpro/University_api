class MainModel {
  final String country;
  final String name;
  final List<dynamic> webPages;

  MainModel({
    required this.country,
    required this.name,
    required this.webPages,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) {
    return MainModel(
      country: json["country"],
      name: json["name"],
      webPages: json["web_pages"],
    );
  }
}
