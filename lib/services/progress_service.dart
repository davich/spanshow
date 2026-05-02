import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/show_progress.dart';

class ProgressService {
  static const _prefix = 'progress_';

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
}
