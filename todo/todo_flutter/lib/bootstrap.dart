import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/widgets.dart';
import 'package:todo_client/todo_client.dart';
import 'package:todo_flutter/dependency_injection.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = const AppBlocObserver();

  await GetIt.I<SessionManager>().initialize();
  // final client = Client('http://localhost:8080/')
  //   ..connectivityMonitor = FlutterConnectivityMonitor();
  // Add cross-flavor configuration here
  configureDependencies();

  runApp(await builder());
}
