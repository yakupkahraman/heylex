import 'package:flutter/material.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';
import 'package:heylex/features/home/components/analys_chart.dart';

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Analizlerim',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Burada kullanıcı analizleri görüntülenecek.',
                        style: TextStyle(
                          fontFamily: "OpenDyslexic",
                          fontSize: 16,
                          color: ThemeConstants.creamColor,
                        ),
                      ),
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
                        "Fonolojik",
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
                        "Yüzey",
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
                        "Görsel",
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
                        "Akıcılık",
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
