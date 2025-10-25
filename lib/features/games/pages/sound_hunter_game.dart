import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:heylex/features/games/service/game_service.dart';

class SoundHunterGame extends StatefulWidget {
  const SoundHunterGame({super.key});

  @override
  State<SoundHunterGame> createState() => _SoundHunterState();
}

class _SoundHunterState extends State<SoundHunterGame> {
  int _currentStep = 1;
  final int _totalSteps = 5;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  String question = "Ku";
  List<String> options = ["Kutu", "Kapak", "Kutucuk", "Uçak"];

  List<int> _selectedIndices = [];
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
      if (_selectedIndices.contains(index)) {
        _selectedIndices.remove(index);
      } else {
        _selectedIndices.add(index);
      }
    });
  }

  void _checkAnswers() {
    if (_selectedIndices.isEmpty) return;

    setState(() {
      _hasChecked = true;
    });

    // Seçilen cevaplardan herhangi biri yanlış mı kontrol et
    bool hasWrongAnswer = _selectedIndices.any((index) {
      return !options[index].contains(question);
    });

    if (hasWrongAnswer) {
      _wrongAnswers++;
      badAnswerPlaySound();
    } else {
      _correctAnswers++;
      goodAnswerPlaySound();
    }
  }

  bool _isAnswerCorrect(int index) {
    return options[index].contains(question);
  }

  Color? _getBorderColor(int index) {
    final isSelected = _selectedIndices.contains(index);

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
        _selectedIndices = [];
        _hasChecked = false;
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
                    gameId: 'sound_hunter',
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
            children: [
              SizedBox(
                height: 200,
                child: Image.asset(
                  'assets/images/sound_hunter_cat.png',
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),

              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 30),
                    child: Container(
                      width: 100,
                      height: 60,
                      decoration: BoxDecoration(
                        color: ThemeConstants.creamColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          '$question',
                          style: TextStyle(
                            fontFamily: "OpenDyslexic",
                            fontSize: 24,
                            color: ThemeConstants.darkGreyColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  //ses tuşu
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        FlutterTts flutterTts = FlutterTts();
                        flutterTts.speak(question);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: ThemeConstants.darkGreyColor,
                        shape: CircleBorder(),
                      ),
                      icon: Icon(
                        Icons.volume_up,
                        color: ThemeConstants.creamColor,
                        size: 32,
                      ),
                    ),
                  ),
                ],
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
              itemCount: options.length,
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
                          options[index],
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
                        ? (_selectedIndices.isNotEmpty ? _checkAnswers : null)
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
