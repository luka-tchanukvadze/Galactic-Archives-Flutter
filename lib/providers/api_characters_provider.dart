import 'package:flutter/foundation.dart';

import '../models/api_character.dart';
import '../repositories/character_repository.dart';
import '../services/star_wars_api.dart';

// Simple status so the ui knows which of the three screens to show.
enum ApiStatus { loading, error, done }

class ApiCharactersProvider extends ChangeNotifier {
  ApiCharactersProvider() : _repo = CharacterRepository(StarWarsApi());

  final CharacterRepository _repo;

  ApiStatus _status = ApiStatus.loading;
  List<ApiCharacter> _characters = [];
  String? _error;

  ApiStatus get status => _status;
  List<ApiCharacter> get characters => _characters;
  String? get error => _error;

  Future<void> load() async {
    _status = ApiStatus.loading;
    _error = null;
    notifyListeners();
    try {
      _characters = await _repo.getCharacters();
      _status = ApiStatus.done;
    } catch (e) {
      // if the api is down i keep the message so i can show a retry button.
      _error = e.toString();
      _status = ApiStatus.error;
    }
    notifyListeners();
  }
}
