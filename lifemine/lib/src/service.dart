import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lifemine/src/data.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DataService extends ChangeNotifier {
  static const _modelCollection = 'models';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// Persist a Model schema definition
  Future<File> createModel(Map<String, Object?> json) async {
    final rootPath = await _localPath;
    // ensure the Model storage directory is created
    await Directory(p.join(rootPath, _modelCollection)).create(recursive: true);
    // generate an id for the new Model
    String uuid = const Uuid().v4();
    // add id to json object
    json['id'] = uuid;
    final file = File(p.join(rootPath, _modelCollection, '$uuid.json'));
    Future<File> fileFuture = file.writeAsString(jsonEncode(json));
    notifyListeners();
    return fileFuture;
  }

  /// Update an existing Model schema definition
  Future<File> updateModel(Map<String, Object?> json, String modelId) async {
    // delete the model and all it's records
    deleteModel(modelId);
    // create the model anew
    return createModel(json);
  }

  /// Get all the Model schema defintions from storage
  Future<List<Model>> getModels() async {
    final rootPath = await _localPath;
    final directory = await Directory(p.join(rootPath, _modelCollection))
        .create(recursive: true);
    final files = directory.listSync();
    List<Model> models = [];
    for (var file in files) {
      if (file is File) {
        String contents = await file.readAsString();
        var json = jsonDecode(contents);
        models.add(Model.fromJson(json, json['id']));
      }
    }
    return models;
  }

  /// Get a single Model schema definition from storage by id
  Future<Model> getModelById(String modelId) async {
    final rootPath = await _localPath;
    final file = File(p.join(rootPath, _modelCollection, '$modelId.json'));
    return Model.fromJson(jsonDecode(await file.readAsString()), modelId);
  }

  /// Delete a single Model schema and all Model Records from storage
  void deleteModel(String modelId) async {
    // delete model schema definition file
    final rootPath = await _localPath;
    final file = File(p.join(rootPath, _modelCollection, '$modelId.json'));
    file.delete();
    // delete model records directory
    final directory = Directory(p.join(rootPath, modelId));
    directory.delete(recursive: true);
    notifyListeners();
  }

  /// Create a Record (whose schema is defined by a Model with id=modelId)
  Future<File> createRecord(String modelId, Map<String, Object?> json) async {
    final rootPath = await _localPath;
    // ensure the Record storage directory exists
    await Directory(p.join(rootPath, modelId)).create(recursive: true);
    // generate an id for this record
    String uuid = const Uuid().v4();
    // add id to json object
    json['id'] = uuid;
    final file = File(p.join(rootPath, modelId, '$uuid.json'));
    notifyListeners();
    Future<File> fileFuture = file
        .writeAsString(jsonEncode(json, toEncodable: (obj) => obj.toString()));
    notifyListeners();
    return fileFuture;
  }

  /// Get all Records for a given Model (with id=modelId)
  Future<List<Map<String, Object?>>> getRecords(String modelId) async {
    final rootPath = await _localPath;
    // ensure the Record storage directory exists
    await Directory(p.join(rootPath, modelId)).create(recursive: true);
    final directory = Directory(p.join(rootPath, modelId));
    final files = directory.listSync();
    List<Map<String, Object?>> records = [];
    for (var file in files) {
      if (file is File) {
        String contents = await file.readAsString();
        var json = jsonDecode(contents);
        records.add(json);
      }
    }
    return records;
  }

  /// Get a single Record by Model and id
  Future<Map<String, Object?>> getRecord(
    String modelId,
    String recordId,
  ) async {
    final rootPath = await _localPath;
    // ensure the Record storage directory exists
    await Directory(p.join(rootPath, modelId)).create(recursive: true);
    final file = File(p.join(rootPath, modelId, '$recordId.json'));
    return jsonDecode(await file.readAsString());
  }

  /// Delete a single Record by Model and id
  void deleteRecord(String modelId, String recordId) async {
    final rootPath = await _localPath;
    // ensure the Record storage directory exists
    await Directory(p.join(rootPath, modelId)).create(recursive: true);
    final file = File(p.join(rootPath, modelId, '$recordId.json'));
    file.delete();
    notifyListeners();
  }

  /// Delete multiple Records by Model and a list of ids
  void deleteRecords(String modelId, List<String> recordIds) async {
    for (String recordId in recordIds) {
      deleteRecord(modelId, recordId);
    }
    notifyListeners();
  }

  /// Overwrite an existing Record by Model and id
  void updateRecord(
    String modelId,
    String recordId,
    Map<String, Object?> json,
  ) async {
    final rootPath = await _localPath;
    // ensure the Record storage directory exists
    await Directory(p.join(rootPath, modelId)).create(recursive: true);
    final file = File(p.join(rootPath, modelId, '$recordId.json'));
    // add id to json object
    json['id'] = recordId;
    file.writeAsString(jsonEncode(json, toEncodable: (obj) => obj.toString()));
    notifyListeners();
  }
}
