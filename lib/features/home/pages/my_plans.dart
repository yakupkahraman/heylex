import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heylex/core/components/glass_effect_container.dart';
import 'package:heylex/core/theme/theme_constants.dart';

class MyPlans extends StatelessWidget {
  const MyPlans({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Planım',
          style: TextStyle(fontFamily: "OpenDyslexic"),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: ThemeConstants.creamColor),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GlassEffectContainer(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Free Plan',
                  style: TextStyle(
                    fontFamily: "OpenDyslexic",
                    fontSize: 18,
                    color: ThemeConstants.orangeColor,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Mevcut planınız ücretsiz plandır. Ücretli planlara yükselterek daha fazla özelliğe erişebilirsiniz.',
                  style: TextStyle(fontFamily: "OpenDyslexic", fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                /*
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      ThemeConstants.orangeColor,
                    ),
                  ),
                  child: Text(
                    "Üyelik Planları",
                    style: TextStyle(
                      fontFamily: "OpenDyslexic",
                      fontSize: 12,
                      color: ThemeConstants.creamColor,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
