import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news_app/api/spaceflight.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveSchema {
  List<Result> result;

  SaveSchema({
    required this.result,
  });

  factory SaveSchema.fromJson(Map<String, dynamic> json) => SaveSchema(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
      };
}

Future<void> saveData(SaveSchema value, Result keyy, bool isSave) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString("saved", json.encode(value.toJson()));
  if (isSave) {
    await prefs.setBool(keyy.id.toString(), true);
  } else {
    await prefs.remove(keyy.id.toString());
  }
}

Future<void> clearData() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}

Future<SaveSchema> readData() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey("saved")) {
    await prefs.setString(
        "saved", json.encode(SaveSchema(result: []).toJson()));
  }
  return SaveSchema.fromJson(jsonDecode(prefs.getString("saved")!));
}

Future<bool> isSaved(int id) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.containsKey(id.toString());
}

class MainStore extends ChangeNotifier {
  final SaveSchema _news = SaveSchema(result: []);

  SaveSchema get news => _news;

  Future<void> getLocalStorage() async {
    _news.result = (await readData()).result;
    notifyListeners();
  }

  void addNews(Result value) {
    _news.result.add(value);
    saveData(_news, value, true);
    notifyListeners();
  }

  void removeNews(Result value) {
    _news.result.remove(value);
    saveData(_news, value, false);
    notifyListeners();
  }

  void clearNews() {
    _news.result.clear();
    notifyListeners();
  }
}
