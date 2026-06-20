import 'package:dio/dio.dart';

import '../models/api_character.dart';

// This is the data source. Dio does the actual http call.
class StarWarsApi {
  // One dio instance, base url set once so the calls stay short.
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://swapi.info/api/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  Future<List<ApiCharacter>> fetchAll() async {
    // swapi.info returns the whole people list as one json array.
    final response = await _dio.get<List<dynamic>>('people');
    final list = response.data ?? [];
    return list
        .map((e) => ApiCharacter.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }
}
