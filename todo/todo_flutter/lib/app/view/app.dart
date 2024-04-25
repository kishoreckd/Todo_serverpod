import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:todo_flutter/l10n/l10n.dart';
import 'package:todo_client/todo_client.dart';
import 'package:todo_flutter/counter/counter.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    print(GetIt.I<Client>());
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CounterPage(),
    );
  }
}
