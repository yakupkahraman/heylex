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
      'options': ['0-12', '13-17', '18-24', '25+'],
      'key': 'age_group',
    },
    {
      'question': 'Hangi seviyedesiniz?',
      'options': ['Başlangıç', 'Orta', 'İleri'],
      'key': 'level',
    },
    {
      'question': 'Günde ne kadar zaman ayırabilirsiniz?',
      'options': ['10-20 dakika', '20-40 dakika', '40+ dakika'],
      'key': 'daily_time',
    },
    // Buraya daha fazla soru ekleyebilirsiniz
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
