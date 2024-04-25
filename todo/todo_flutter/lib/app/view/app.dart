import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/l10n/l10n.dart';
import 'package:todo_client/todo_client.dart';
import 'package:todo_flutter/counter/counter.dart';
import 'package:todo_flutter/login/login_page.dart';
class App extends StatefulWidget {

  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    final client = GetIt.I<Client>();
    client.example.hello('name').then(print);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LogInPage(),
    );
  }
}
