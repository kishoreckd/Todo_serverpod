import 'package:injectable/injectable.dart';
import 'package:todo_client/todo_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

@module
abstract class RegisterModule {
  Client get client => Client('http://localhost:8080/')
    ..connectivityMonitor = FlutterConnectivityMonitor();
}
