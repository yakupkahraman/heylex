import 'package:go_router/go_router.dart';
import 'package:heylex/features/auth/pages/auth_page.dart';
import 'package:heylex/features/auth/pages/login_page.dart';
import 'package:heylex/features/auth/pages/questions_flow.dart';
import 'package:heylex/features/auth/pages/register_page.dart';
import 'package:heylex/features/games/pages/games_flow.dart';
import 'package:heylex/features/home/presentation/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RouterManager {
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  static Future<bool> hasCompletedQuestions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('questions_completed') ?? false;
  }

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) async {
      final loggedIn = await isUserLoggedIn();
      final questionsCompleted = await hasCompletedQuestions();

      final authRoutes = ['/auth'];
      final isAuthRoute = authRoutes.any(
        (route) => state.matchedLocation.startsWith(route),
      );

      // Giriş yapmamış ve auth sayfasında değilse -> auth'a yönlendir
      if (!loggedIn && !isAuthRoute) {
        return '/auth';
      }

      // Giriş yapmış ama sorular tamamlanmamışsa -> sorulara yönlendir
      if (loggedIn &&
          !questionsCompleted &&
          state.matchedLocation != '/auth/register/questions') {
        return '/auth/register/questions';
      }

      // Giriş yapmış ve sorular tamamlanmışsa ama auth sayfasındaysa -> home'a yönlendir
      if (loggedIn && questionsCompleted && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            path: 'games/:id',
            builder: (context, state) {
              final gameId = state.pathParameters['id']!;
              return GamesFlow(gameId: gameId);
            },
          ),
        ],
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthPage(),
        routes: [
          GoRoute(
            path: 'login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: 'register',
            builder: (context, state) => const RegisterPage(),
            routes: [
              GoRoute(
                path: 'questions',
                builder: (context, state) => const QuestionsFlow(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
