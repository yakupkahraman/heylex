import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_circle_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';

class GameInfoContainer extends StatelessWidget {
  const GameInfoContainer({
    super.key,
    required this.title,
    required this.gameId,
    required this.typeIcon,
    required this.typeContent,
  });

  final String title;
  final String gameId;
  final IconData typeIcon;
  final String typeContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Stack(
        children: [
          Container(
            width: 350,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
            clipBehavior: Clip.hardEdge,
            child: Image.asset('assets/images/$gameId.png', fit: BoxFit.fill),
          ),
          SizedBox(height: 8),
          Positioned(
            right: 6,
            top: 12,
            child: GlassEffectCircleContainer(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      typeContent,
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        color: ThemeConstants.creamColor,
                      ),
                    ),
                    content: Text(
                      'Bu oyun, belirtilen alanda egzersiz ve pratik yaparak düzenli pratik yapıldığında gelişmenizi sağlar.',
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        color: ThemeConstants.creamColor,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Kapat',
                          style: TextStyle(
                            fontFamily: "OpenDyslexic",
                            color: ThemeConstants.creamColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: Icon(typeIcon, color: Colors.white, size: 28),
              ),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 12,
            child: InkWell(
              onTap: () {
                context.go('/games/$gameId');
              },
              child: GlassEffectCircleContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                    vertical: 4.0,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.green,
                        size: 46,
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
