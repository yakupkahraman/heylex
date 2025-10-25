import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';
import 'package:heylex/features/games/service/game_service.dart';

class TrueOrFalseGame extends StatefulWidget {
  const TrueOrFalseGame({super.key});

  @override
  State<TrueOrFalseGame> createState() => _TrueOrFalseState();
}

class _TrueOrFalseState extends State<TrueOrFalseGame> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  // Her adımda farklı kelimeler gösterilebilir
  List<String> words = ["gözlük", "kedi", "köpek", "lokum", "polsi"];
  String wrongWord = "polsi"; // Yanlış yazılmış kelime
  String correctWord = "polis"; // Doğru yazımı

  int? _selectedIndex;
  bool _hasChecked = false;

  final player = AudioPlayer();
  final _gameService = GameService();

  Future<void> goodAnswerPlaySound() async {
    await player.play(AssetSource('sounds/good_answer.wav'));
  }

  Future<void> badAnswerPlaySound() async {
    await player.play(AssetSource('sounds/bad_answer.wav'));
  }

  void _toggleSelection(int index) {
    if (_hasChecked) return; // Kontrol edildikten sonra seçim yapılamaz

    setState(() {
      _selectedIndex = index;
    });
  }

  void _checkAnswers() {
    if (_selectedIndex == null) return;

    setState(() {
      _hasChecked = true;
    });

    // Seçilen kelime yanlış kelime mi kontrol et
    bool isCorrect = words[_selectedIndex!] == wrongWord;

    if (isCorrect) {
      _correctAnswers++;
      goodAnswerPlaySound();
    } else {
      _wrongAnswers++;
      badAnswerPlaySound();
    }
  }

  bool _isAnswerCorrect(int index) {
    // Sadece yanlış yazılmış kelime doğru cevaptır
    return words[index] == wrongWord;
  }

  Color? _getBorderColor(int index) {
    final isSelected = _selectedIndex == index;

    if (!isSelected) return null;

    if (!_hasChecked) {
      return ThemeConstants.creamColor;
    }

    // Kontrol edildikten sonra
    return _isAnswerCorrect(index) ? Colors.green : Colors.red;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        _selectedIndex = null;
        _hasChecked = false;
        // Yeni kelimeler yüklenebilir
      });
    } else {
      // Son adıma gelindi, oyun bitti - sonuçları göster
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: ThemeConstants.darkGreyColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          title: Text(
            'Oyun Bitti!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "OpenDyslexic",
              color: ThemeConstants.creamColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 48),
                      SizedBox(height: 8),
                      Text(
                        '$_correctAnswers',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 32,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Doğru',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 48),
                      SizedBox(height: 8),
                      Text(
                        '$_wrongAnswers',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 32,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Yanlış',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: AuthButton(
                label: 'Tamam',
                onPressed: () async {
                  // Oyun sonucunu kaydet
                  await _gameService.saveGameResult(
                    gameId: 'true_or_false',
                    correctCount: _correctAnswers,
                    wrongCount: _wrongAnswers,
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    context.go('/');
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStepContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/sound_hunter_cat.png',
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: ThemeConstants.creamColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Yanlış olan \nhangisi',
                  style: TextStyle(
                    fontFamily: "OpenDyslexic",
                    fontSize: 16,
                    color: ThemeConstants.darkGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2,
              ),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final borderColor = _getBorderColor(index);

                return GestureDetector(
                  onTap: () => _toggleSelection(index),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: borderColor != null
                          ? Border.all(color: borderColor, width: 3)
                          : null,
                    ),
                    child: GlassEffectContainer(
                      child: Center(
                        child: Text(
                          words[index],
                          style: TextStyle(
                            fontFamily: "OpenDyslexic",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeConstants.darkGreyColor,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: Icon(Icons.close, color: ThemeConstants.creamColor),
        ),
        title: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _currentStep / _totalSteps,
                backgroundColor: ThemeConstants.creamColor.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeConstants.creamColor,
                ),
                minHeight: 12,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildStepContent()),
          Padding(
            padding: const EdgeInsets.all(50.0),
            child: Row(
              children: [
                Expanded(
                  child: AuthButton(
                    label: !_hasChecked
                        ? "Kontrol Et"
                        : (_currentStep == _totalSteps ? "Bitir" : "Devam Et"),
                    onPressed: !_hasChecked
                        ? (_selectedIndex != null ? _checkAnswers : null)
                        : _nextStep,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
