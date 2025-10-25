import 'package:flutter/material.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/home/components/analys_chart.dart';
import 'package:shimmer/shimmer.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Text(
          'Analizlerim',
          style: TextStyle(color: ThemeConstants.creamColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Shimmer.fromColors(
                    baseColor: ThemeConstants.creamColor,
                    highlightColor: ThemeConstants.creamColor.withOpacity(0.5),
                    child: Text(
                      'LexAI özetinizi hazırlıyor...',
                      style: TextStyle(
                        fontFamily: "OpenDyslexic",
                        fontSize: 16,
                        color: ThemeConstants.creamColor,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ses/Hece İşleme Becerisi",
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      AnalysChart(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Yazım ve Görsel Hafıza",
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      AnalysChart(chartColor: Colors.orange),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Görsel Odak Gücü",
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      AnalysChart(chartColor: Colors.pink),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              GlassEffectContainer(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Okuma Akıcılığı",
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                      SizedBox(height: 16),
                      AnalysChart(chartColor: Colors.blue),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
