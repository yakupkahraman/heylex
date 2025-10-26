import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';
import 'package:heylex/features/games/service/game_service.dart';
import 'package:heylex/features/games/service/ai__game_service.dart';
import 'package:heylex/features/auth/providers/user_provider.dart';
import 'package:provider/provider.dart';

class TrueOrFalseGame extends StatefulWidget {
  const TrueOrFalseGame({super.key});

  @override
  State<TrueOrFalseGame> createState() => _TrueOrFalseState();
}

class _TrueOrFalseState extends State<TrueOrFalseGame> {
  int _currentStep = 0;
  int _totalSteps = 5;

  int _correctAnswers = 0;
  int _wrongAnswers = 0;

  List<TrueOrFalseQuestion> _questions = [];
  bool _isLoading = true;

  int? _selectedIndex;
  bool _hasChecked = false;

  final player = AudioPlayer();
  final _gameService = GameService();
  final _aiGameService = AiGameService();

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final response = await _aiGameService.getTrueOrFalseQuestions(
        ageGroup: userProvider.ageGroup ?? '',
        hardArea: userProvider.hardArea ?? '',
        readingGoal: userProvider.readingGoal ?? '',
        diagnosisTime: userProvider.diagnosisTime ?? '',
        motivatingGames: userProvider.motivatingGames ?? '',
        workingWithProfessional: userProvider.workingWithProfessional ?? '',
      );

      if (!mounted) return;

      setState(() {
        _questions = response.questions;
        _totalSteps = _questions.length;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sorular yüklenemedi: $e')));
    }
  }

  List<String> get words {
    if (_questions.isEmpty || _currentStep >= _questions.length) return [];
    return _questions[_currentStep].words;
  }

  int get wrongIndex {
    if (_questions.isEmpty || _currentStep >= _questions.length) return -1;
    return _questions[_currentStep].wrongIndex;
  }

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

    bool isCorrect = _selectedIndex! == wrongIndex;

    if (isCorrect) {
      _correctAnswers++;
      goodAnswerPlaySound();
    } else {
      _wrongAnswers++;
      badAnswerPlaySound();
    }
  }

  bool _isAnswerCorrect(int index) {
    return index == wrongIndex;
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
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
        _selectedIndex = null;
        _hasChecked = false;
      });
    } else {
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
                value: _totalSteps > 0 ? _currentStep / _totalSteps : 0,
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
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: ThemeConstants.creamColor),
                  SizedBox(height: 16),
                  Text(
                    'Sorular hazırlanıyor...',
                    style: TextStyle(
                      fontFamily: "OpenDyslexic",
                      fontSize: 18,
                      color: ThemeConstants.creamColor,
                    ),
                  ),
                ],
              ),
            )
          : _questions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: ThemeConstants.creamColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Sorular yüklenemedi',
                    style: TextStyle(
                      fontFamily: "OpenDyslexic",
                      fontSize: 18,
                      color: ThemeConstants.creamColor,
                    ),
                  ),
                  SizedBox(height: 16),
                  AuthButton(
                    label: 'Ana Sayfaya Dön',
                    onPressed: () => context.go('/'),
                  ),
                ],
              ),
            )
          : Column(
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
                              : (_currentStep == _totalSteps - 1
                                    ? "Bitir"
                                    : "Devam Et"),
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
