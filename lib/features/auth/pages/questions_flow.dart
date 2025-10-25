import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/features/auth/pages/questions_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QuestionsFlow extends StatefulWidget {
  const QuestionsFlow({super.key});

  @override
  State<QuestionsFlow> createState() => _QuestionsFlowState();
}

class _QuestionsFlowState extends State<QuestionsFlow> {
  int _currentQuestionIndex = 0;
  final Map<String, String> _answers = {};

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Hangi yaş grubundasınız?',
      'options': ['8-12', '13-17', '18+'],
      'key': 'age_group',
    },
    {
      'question': 'En çok zorlandığınız alan hangisidir?',
      'options': [
        'Harfleri ayırt etmek',
        'Heceleme ve yazım',
        'Okuma hızım düşük',
      ],
      'key': 'hard_area',
    },
    {
      'question': 'Okuma konusunda hangi hedef sana uyuyor?',
      'options': [
        'Daha hızlı okumak',
        'Daha rahat okumak',
        'Oyunlarla pratik yapmak',
        'Anlama becerisi geliştirmek',
      ],
      'key': 'reading_goal',
    },
    {
      'question': 'Disleksi tanınız ne zaman kondu?',
      'options': [
        'Yeni tanı aldım (son 1 yıl)',
        'Uzun süre (1-5 yıl)',
        'Çocuklukta tanı aldım ',
        'Hiç tanı almadım',
      ],
      'key': 'diagnosis_time',
    },
    {
      'question': 'Hangi tür oyunlar seni daha çok motive eder?',
      'options': [
        'Bulmaca ve eşleştirme',
        'Hikaye ve görev',
        'Süreli mini oyunlar',
        'Kelime bulma',
        'Yazım ve tamamlama görevi',
      ],
      'key': 'motivating_games',
    },
    {
      'question':
          'Şu anda bir uzman, terapist veya öğretmenile çalışıyor musun?',
      'options': [
        'Evet, bir uzmanla düzenli olarak çalışıyorum',
        'Hayır, bireysel olarak ilerliyorum',
      ],
      'key': 'working_with_professional',
    },
  ];

  void _handleAnswer(String answer) {
    final currentQuestion = _questions[_currentQuestionIndex];
    _answers[currentQuestion['key']] = answer;

    log('Cevap kaydedildi: ${currentQuestion['key']} = $answer');

    if (_currentQuestionIndex < _questions.length - 1) {
      // Bir sonraki soruya geç
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // Tüm sorular tamamlandı, cevapları kaydet ve HomePage'e geç
      _completeQuestionnaire();
    }
  }

  Future<void> _completeQuestionnaire() async {
    try {
      // SharedPreferences'a questions_completed bayrağını set et
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('questions_completed', true);

      // Tüm cevapları Supabase user metadata'ya kaydet
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'questions_completed': true, ..._answers}),
      );

      log('Tüm cevaplar kaydedildi: $_answers');

      // HomePage'e geç
      if (mounted) {
        context.go('/');
      }
    } catch (e) {
      log('Hata: $e');
      // Hata durumunda yine de HomePage'e geç
      if (mounted) {
        // Hata olsa bile bayrağı set et
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);

        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];

    return QuestionsPage(
      question: currentQuestion['question'],
      options: List<String>.from(currentQuestion['options']),
      onOptionSelected: _handleAnswer,
    );
  }
}
