import '../models/api_character.dart';
import '../services/star_wars_api.dart';

// The repo hides where the data comes from. The ui asks for characters,
// it doesn't care that today it's dio hitting an api.
class CharacterRepository {
  CharacterRepository(this._api);

  final StarWarsApi _api;

  Future<List<ApiCharacter>> getCharacters() => _api.fetchAll();
}
