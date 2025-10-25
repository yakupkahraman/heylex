import 'package:supabase_flutter/supabase_flutter.dart';

class GameService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> saveGameResult({
    required String gameId,
    required int correctCount,
    required int wrongCount,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    await _supabase.from('game_results').insert({
      'user_id': userId,
      'game_id': gameId,
      'correct_count': correctCount,
      'wrong_count': wrongCount,
      'played_at': DateTime.now().toIso8601String(),
    });
  }

  /// Son 7 günün oyun verilerini getirir
  Future<Map<String, double>> getWeeklyGameData(String gameId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return {};

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 6));

    final response = await _supabase
        .from('game_results')
        .select('played_at, correct_count, wrong_count')
        .eq('user_id', userId)
        .eq('game_id', gameId)
        .gte('played_at', sevenDaysAgo.toIso8601String())
        .order('played_at', ascending: true);

    // Günlük verileri topla
    Map<String, double> dailyData = {};

    for (var result in response) {
      final playedAt = DateTime.parse(result['played_at']);
      final dateKey =
          '${playedAt.year}-${playedAt.month.toString().padLeft(2, '0')}-${playedAt.day.toString().padLeft(2, '0')}';

      final correct = (result['correct_count'] as num).toDouble();
      final wrong = (result['wrong_count'] as num).toDouble();
      final total = correct + wrong;

      // Başarı oranını hesapla (0-10 arası)
      final successRate = total > 0 ? (correct / total) * 10 : 0.0;

      // Aynı gün birden fazla oyun varsa ortalamasını al
      if (dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = (dailyData[dateKey]! + successRate) / 2;
      } else {
        dailyData[dateKey] = successRate;
      }
    }

    return dailyData;
  }
}
