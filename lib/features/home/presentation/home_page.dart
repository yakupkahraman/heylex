import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/service/auth_service.dart';
import 'package:heylex/features/home/components/game_info_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final name = await AuthService().getCurrentUserName();

      setState(() {
        _userName = name ?? 'Kullanıcı';
      });
    } catch (e) {
      setState(() {
        _userName = 'Kullanıcı';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: Drawer(
        backgroundColor: ThemeConstants.darkGreyColor,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: ThemeConstants.darkGreyColor),
              child: Text(
                'HeyLex Menü',
                style: TextStyle(
                  fontFamily: "OpenDyslexic",
                  color: ThemeConstants.creamColor,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.groups, color: ThemeConstants.creamColor),
              title: Text(
                'Uzmanlar',
                style: TextStyle(
                  fontFamily: "OpenDyslexic",
                  color: ThemeConstants.creamColor,
                ),
              ),
              onTap: () {
                context.go('/professionals');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.military_tech,
                color: ThemeConstants.creamColor,
              ),
              title: Text(
                'Rozetler',
                style: TextStyle(
                  fontFamily: "OpenDyslexic",
                  color: ThemeConstants.creamColor,
                ),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("HeyLex", style: TextStyle(fontFamily: "OpenDyslexic")),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle_rounded,
              color: ThemeConstants.creamColor,
            ),
            iconSize: 32,
            onPressed: () {
              context.go('/profile');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "SELAM ${_userName.toUpperCase()},",
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        color: ThemeConstants.creamColor,
                      ),
                    ),
                    TextSpan(
                      text:
                          " cevapların doğrultusunda öncelik sıralamasına göre senin için hazırladığımız eğitimler aşağıdadır.",
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        fontSize: 12,
                        color: ThemeConstants.creamColor.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GameInfoContainer(title: "Ses Avcısı", gameId: "sound_hunter"),
            GameInfoContainer(
              title: "Doğru mu Yanlış mı?",
              gameId: "true_or_false",
            ),
            GameInfoContainer(
              title: "Karışık Kelimeler",
              gameId: "jumbled_words",
            ),
          ],
        ),
      ),
    );
  }
}
