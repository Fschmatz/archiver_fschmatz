import 'package:uuid/uuid.dart';
import 'package:jiffy/jiffy.dart';
import '../enum/device_type.dart';

class Note {
  String id;
  String? text;
  int archived;
  String creationDate;
  int synced;
  String? syncDate;
  int deleted;
  String lastModifiedDate;
  String lastModifiedDevice;
  int version;

  Note({
    required this.id,
    this.text,
    this.archived = 0,
    required this.creationDate,
    this.synced = 0,
    this.syncDate,
    this.deleted = 0,
    required this.lastModifiedDate,
    required this.lastModifiedDevice,
    required this.version,
  });

  factory Note.createNewForInsert({ String? text}) {
    return Note(
        id: const Uuid().v4(),
        text: text,
        creationDate: DateTime.now().toIso8601String(),
        lastModifiedDate: DateTime.now().toIso8601String(),
        lastModifiedDevice: DeviceType.PHONE.id,
        version: 1);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'archived': archived.toString(),
      'creationDate': creationDate,
      'synced': synced.toString(),
      'syncDate': syncDate,
      'deleted': deleted.toString(),
      'lastModifiedDate': lastModifiedDate,
      'lastModifiedDevice': lastModifiedDevice,
      'version': version.toString(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      text: map['text'] ,
      archived: map['archived'],
      creationDate: map['creationDate'],
      synced: map['synced'],
      syncDate: map['syncDate'] ,
      deleted: map['deleted'],
      lastModifiedDate: map['lastModifiedDate'],
      lastModifiedDevice: map['lastModifiedDevice'],
      version: map['version'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'archived': archived,
      'creationDate': creationDate,
      'synced': synced,
      'syncDate': syncDate,
      'deleted': deleted,
      'lastModifiedDate': lastModifiedDate,
      'lastModifiedDevice': lastModifiedDevice,
      'version': version,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      text: json['text'],
      archived: json['archived'],
      creationDate: json['creationDate'],
      synced: json['synced'],
      syncDate: json['syncDate'],
      deleted: json['deleted'],
      lastModifiedDate: json['lastModifiedDate'],
      lastModifiedDevice: json['lastModifiedDevice'],
      version: json['version'],
    );
  }

  String get formattedCreationDate => Jiffy.parse(creationDate).format(pattern: 'dd/MM/yyyy');
}
