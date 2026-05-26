import 'heritage_model.dart';

/// Repository interface defining core queries for cultural heritage data.
abstract class HeritageRepository {
  /// Fetches a specific heritage item by its unique ID.
  Future<Heritage?> getHeritageById(String id);

  /// Retrieves a list of all currently supported heritage items.
  Future<List<Heritage>> getAllHeritages();
}
