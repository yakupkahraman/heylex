import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      child: Material(
        color: ThemeConstants.creamColor,
        borderRadius: BorderRadius.circular(32),
        child: InkWell(
          onTap: () {
            context.go("/games/$gameId");
          },
          splashColor: ThemeConstants.darkGreyColor.withOpacity(0.3),
          highlightColor: ThemeConstants.darkGreyColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(32),
          child: Container(
            width: 380,
            height: 240,
            child: Center(child: Text(title)),
          ),
        ),
      ),
    );
  }
}
