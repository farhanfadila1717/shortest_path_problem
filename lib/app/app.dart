import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riset_operasional/ui/pages/home_page/home_page.dart';
import 'package:riset_operasional/ui/pages/results_page/results_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: MaterialApp.router(
          title: 'Djikstra Algoritm',
          routerConfig: _router,
        ),
      );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/results',
      builder: (context, state) => const ResultsPage(),
    ),
  ],
);
