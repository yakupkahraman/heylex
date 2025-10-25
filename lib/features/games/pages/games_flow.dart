import 'package:flutter/material.dart';
import 'package:heylex/features/games/pages/sound_hunter.dart';
import 'package:heylex/features/games/pages/true_or_false.dart';

class GamesFlow extends StatelessWidget {
  const GamesFlow({super.key, required this.gameId});
  final String gameId;

  @override
  Widget build(BuildContext context) {
    // gameId'ye göre ilgili oyun sayfasına yönlendir
    switch (gameId) {
      case 'sound_hunter':
        return const SoundHunter();
      case 'true_or_false':
        return const TrueOrFalse();
      default:
        return Scaffold(body: Center(child: Text('Oyun bulunamadı: $gameId')));
    }
  }
}
