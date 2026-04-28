import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/show.dart';
import '../models/episode.dart';

class ContentRepository {
  static Future<List<Show>> loadShows() async {
    final data = await rootBundle.loadString('assets/shows.json');
    final list = jsonDecode(data) as List;
    return list.map((e) => Show.fromJson(e as Map<String, dynamic>)).toList();
  }

  static Future<Episode> loadEpisode(String showId, int season, int episode) async {
    final s = season.toString().padLeft(2, '0');
    final e = episode.toString().padLeft(2, '0');
    final data = await rootBundle.loadString('assets/content/$showId/s${s}e$e.json');
    return Episode.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }
}
