import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/auth/components/auth_button.dart';

class SoundHunter extends StatefulWidget {
  const SoundHunter({super.key});

  @override
  State<SoundHunter> createState() => _SoundHunterState();
}

class _SoundHunterState extends State<SoundHunter> {
  int _currentStep = 1;
  final int _totalSteps = 10;

  String question = "Ku";
  List<String> options = ["Kutu", "Kapak", "Kutucuk", "Uçak"];

  final player = AudioPlayer();

  Future<void> goodAnswerPlaySound() async {
    await player.play(AssetSource('sounds/good_answer.wav'));
  }

  Future<void> badAnswerPlaySound() async {
    await player.play(AssetSource('sounds/bad_answer.wav'));
  }

  void _nextStep() {
    goodAnswerPlaySound();
    if (_currentStep < _totalSteps) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Son adıma gelindi, oyun bitti
      Navigator.pop(context);
    }
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
              Container(
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
            ],
          ),
          SizedBox(height: 40),
          SizedBox(
            width: 300,
            child: Column(
              children: options.map((option) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: AuthButton(
                    label: option,
                    onPressed: () {
                      // Cevap kontrolü burada yapılacak
                      if (option.startsWith(question)) {
                        _nextStep();
                      } else {
                        badAnswerPlaySound();
                      }
                    },
                  ),
                );
              }).toList(),
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
                    label: _currentStep == _totalSteps ? "Bitir" : "Devam Et",
                    onPressed: _nextStep,
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
