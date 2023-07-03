import 'dart:convert';

import 'package:http/http.dart' as httpmethod;
import 'package:my_api/models/my_model.dart';

Future<List<MainModel>> getAllRequest(String countryName) async {
  Map<String, String> qp = {"country": countryName};
  final respnose = await httpmethod.get(
    Uri.http(
      "universities.hipolabs.com",
      "/search",
      qp,
    ),
  );
  if (respnose.statusCode == 200) {
    return List<MainModel>.from(
      jsonDecode(respnose.body).map(
        (value) => MainModel.fromJson(value),
      ),
    );
  } else {
    throw Exception("Error: Can't load all data!!");
  }
}
