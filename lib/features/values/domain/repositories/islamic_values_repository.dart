import '../models/islamic_value.dart';
import '../models/manner.dart';
import '../models/value_connection.dart';

/// Abstract repository for querying Islamic values, manners, and educational links.
abstract class IIslamicValuesRepository {
  Future<List<IslamicValue>> getAllValues();
  Future<IslamicValue?> getValueById(String id);
  Future<List<Manner>> getAllManners();
  Future<Manner?> getMannerById(String id);
  Future<List<ValueConnection>> getValueConnectionsForWorld(String worldId);
  Future<ValueConnection?> getValueConnectionForLesson(String lessonId);
}
