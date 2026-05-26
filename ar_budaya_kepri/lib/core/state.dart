import '../features/heritage/data/mock_heritage_repository.dart';
import '../features/heritage/domain/heritage_repository.dart';
import '../features/gamification/data/stamp_manager.dart';

/// Globally shared service locator/dependency registry.
/// Promotes decoupling and makes mock injection easy for testing.
final HeritageRepository heritageRepository = MockHeritageRepository();

/// A single persistent StampManager instance managing local gamification stamp logbooks.
final StampManager stampManager = StampManager();
