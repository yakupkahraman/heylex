import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';
import 'package:heylex/features/games/service/game_service.dart';

class JumbledWordsGame extends StatefulWidget {
  const JumbledWordsGame({super.key});

  @override
  State<JumbledWordsGame> createState() => _JumbledWordsGameState();
}

class _JumbledWordsGameState extends State<JumbledWordsGame> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  String correctWord = "furkan";
  List<String> letters = ["f", "u", "r", "a", "n", "k"];

  bool _hasChecked = false;
  int? _selectedIndex; // Seçili harfin indexi

  final player = AudioPlayer();
  final _gameService = GameService();

  @override
  void initState() {
    super.initState();
    // Harfleri karıştır (başlangıçta yanlış sırada)
    letters.shuffle();
  }

  Future<void> goodAnswerPlaySound() async {
    await player.play(AssetSource('sounds/good_answer.wav'));
  }

  Future<void> badAnswerPlaySound() async {
    await player.play(AssetSource('sounds/bad_answer.wav'));
  }

  void _checkAnswers() {
    setState(() {
      _hasChecked = true;
    });

    // Kullanıcının oluşturduğu kelime
    String userWord = letters.join('');

    // Tüm harfler doğru mu kontrol et
    bool isCorrect = userWord == correctWord;

    if (isCorrect) {
      _correctAnswers++;
      goodAnswerPlaySound();
    } else {
      _wrongAnswers++;
      badAnswerPlaySound();
    }
  }

  Color? _getBorderColor(int index) {
    if (!_hasChecked) return null;

    // Kontrol edildikten sonra, her harfin doğru pozisyonda olup olmadığını kontrol et
    bool isCorrectPosition = letters[index] == correctWord[index];
    return isCorrectPosition ? Colors.green : Colors.red;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        _hasChecked = false;
        _selectedIndex = null;
        // Yeni kelime için harfleri tekrar karıştır
        letters.shuffle();
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
                    gameId: 'jumbled_words',
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

  void _onLetterTap(int index) {
    if (_hasChecked) return;

    setState(() {
      if (_selectedIndex == null) {
        // İlk harf seçildi
        _selectedIndex = index;
      } else if (_selectedIndex == index) {
        // Aynı harfe tekrar tıklandı, seçimi kaldır
        _selectedIndex = null;
      } else {
        // İki harfi yer değiştir
        final temp = letters[_selectedIndex!];
        letters[_selectedIndex!] = letters[index];
        letters[index] = temp;
        _selectedIndex = null;
      }
    });
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
              SizedBox(width: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: ThemeConstants.creamColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Harfleri\nDüzenle',
                  textAlign: TextAlign.center,
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
          SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              children: List.generate(letters.length, (index) {
                final borderColor = _getBorderColor(index);
                final isSelected = _selectedIndex == index;

                return GestureDetector(
                  onTap: () => _onLetterTap(index),
                  child: _buildLetterContainer(
                    letters[index],
                    borderColor,
                    isSelected,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterContainer(
    String letter,
    Color? borderColor,
    bool isSelected,
  ) {
    return Container(
      width: 50,
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: isSelected
            ? Border.all(color: ThemeConstants.creamColor, width: 3)
            : (borderColor != null
                  ? Border.all(color: borderColor, width: 3)
                  : null),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: GlassEffectContainer(
          child: Center(
            child: Text(
              letter.toUpperCase(),
              style: TextStyle(
                fontFamily: "OpenDyslexic",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
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
                    onPressed: !_hasChecked ? _checkAnswers : _nextStep,
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
