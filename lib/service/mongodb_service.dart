import 'package:mongo_dart/mongo_dart.dart';
import '../utils/mongodb_details.dart';

class MongoDBService {

  final String dbUri = MongoDBDetails.mongoConnectionUrl;
  final String dbName = MongoDBDetails.database;
  final String collectionName = MongoDBDetails.collection;
  late Db _db;
  late DbCollection _collection;

  MongoDBService();

  Future<void> connect() async {
    _db = await Db.create(dbUri);
    await _db.open();
    _collection = _db.collection(collectionName);
  }

  Future<void> disconnect() async {
    await _db.close();
  }

  List<Map<String, dynamic>> convertMapListForMongo(List<Map<String, dynamic>> notes) {
    return notes.map((note) {
      return convertMapForMongo(note);
    }).toList();
  }

  Map<String, dynamic> convertMapForMongo(Map<String, dynamic> note) {
      final transformedNote = Map<String, dynamic>.from(note);

      if (transformedNote.containsKey('id')) {
        transformedNote['_id'] = transformedNote['id'];
        transformedNote.remove('id');
      }
      return transformedNote;
  }

  Future<List<Map<String, dynamic>>> findAllNotes() async {
    final notes = await _collection.find().toList();

    return notes;
  }

  Future<void> insertNote(Map<String, dynamic> note) async {
    await _collection.insertOne(note);
  }

  // tem q ajustar toda logica de conflitos ...
  Future<void> syncNotes(List<Map<String, dynamic>> notes) async {
    await _collection.insertMany(convertMapListForMongo(notes));
  }

}
