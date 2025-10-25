import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';

class SentenceDetectiveGame extends StatefulWidget {
  const SentenceDetectiveGame({super.key});

  @override
  State<SentenceDetectiveGame> createState() => _SentenceDetectiveGameState();
}

class _SentenceDetectiveGameState extends State<SentenceDetectiveGame> {
  int _currentStep = 1;
  final int _totalSteps = 10;

  // Doğru sıra: 0, 1, 2
  List<String> correctOrder = [
    "Ali sabah erkenden kalktı.",
    "Markete gitti.",
    "Gece uyudu.",
  ];

  List<String> sentences = [];

  bool _hasChecked = false;
  int? _selectedIndex; // Seçili cümlenin indexi

  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // Cümleleri kopyala ve karıştır
    sentences = List.from(correctOrder);
    sentences.shuffle();
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

    // Kullanıcının oluşturduğu sıra doğru mu kontrol et
    bool isCorrect = true;
    for (int i = 0; i < sentences.length; i++) {
      if (sentences[i] != correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }

    if (isCorrect) {
      goodAnswerPlaySound();
    } else {
      badAnswerPlaySound();
    }
  }

  Color? _getBorderColor(int index) {
    if (!_hasChecked) return null;

    // Kontrol edildikten sonra, her cümlenin doğru pozisyonda olup olmadığını kontrol et
    bool isCorrectPosition = sentences[index] == correctOrder[index];
    return isCorrectPosition ? Colors.green : Colors.red;
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
        _hasChecked = false;
        _selectedIndex = null;
        // Yeni paragraf için cümleleri tekrar karıştır
        sentences = List.from(correctOrder);
        sentences.shuffle();
      });
    } else {
      // Son adıma gelindi, oyun bitti
      Navigator.pop(context);
    }
  }

  void _onSentenceTap(int index) {
    if (_hasChecked) return;

    setState(() {
      if (_selectedIndex == null) {
        // İlk cümle seçildi
        _selectedIndex = index;
      } else if (_selectedIndex == index) {
        // Aynı cümleye tekrar tıklandı, seçimi kaldır
        _selectedIndex = null;
      } else {
        // İki cümleyi yer değiştir
        final temp = sentences[_selectedIndex!];
        sentences[_selectedIndex!] = sentences[index];
        sentences[index] = temp;
        _selectedIndex = null;
      }
    });
  }

  Widget _buildStepContent() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: ThemeConstants.creamColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Cümleleri Doğru Sıraya Koy',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "OpenDyslexic",
                    fontSize: 16,
                    color: ThemeConstants.darkGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ...List.generate(sentences.length, (index) {
                final borderColor = _getBorderColor(index);
                final isSelected = _selectedIndex == index;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GestureDetector(
                    onTap: () => _onSentenceTap(index),
                    child: _buildSentenceContainer(
                      sentences[index],
                      borderColor,
                      isSelected,
                      index + 1,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSentenceContainer(
    String sentence,
    Color? borderColor,
    bool isSelected,
    int number,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: isSelected
            ? Border.all(color: ThemeConstants.creamColor, width: 3)
            : (borderColor != null
                  ? Border.all(color: borderColor, width: 3)
                  : null),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: GlassEffectContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: ThemeConstants.creamColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ThemeConstants.creamColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    sentence,
                    style: TextStyle(
                      fontFamily: "OpenDyslexic",
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
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
          onPressed: () => Navigator.pop(context),
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
