import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/show_progress.dart';
import '../models/adventure_progress.dart';

class ProgressService {
  static const _prefix = 'progress_';
  static const _adventurePrefix = 'adventure_progress_';

  static Future<void> save(String showId, ShowProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefix + showId, jsonEncode(progress.toJson()));
  }

  static Future<ShowProgress?> load(String showId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefix + showId);
    if (raw == null) return null;
    try {
      return ShowProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdventureProgress(
      String storyId, AdventureProgress progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _adventurePrefix + storyId, jsonEncode(progress.toJson()));
  }

  static Future<AdventureProgress?> loadAdventureProgress(
      String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_adventurePrefix + storyId);
    if (raw == null) return null;
    try {
      return AdventureProgress.fromJson(
          jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  static Future<void> clearAdventureProgress(String storyId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adventurePrefix + storyId);
  }
}
