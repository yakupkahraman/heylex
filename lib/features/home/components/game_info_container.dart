import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';

class GameInfoContainer extends StatelessWidget {
  const GameInfoContainer({
    super.key,
    required this.title,
    required this.gameId,
  });

  final String title;
  final String gameId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          SizedBox(
            width: 380,
            child: Image.asset('assets/images/$gameId.png', fit: BoxFit.cover),
          ),
          SizedBox(height: 8),
          Positioned(
            right: 6,
            bottom: 12,
            child: InkWell(
              onTap: () {
                context.go('/games/$gameId');
              },
              child: GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.green,
                        size: 28,
                      ),
                      Text(
                        "Başla",
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 24,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
