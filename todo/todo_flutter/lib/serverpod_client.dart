import 'package:injectable/injectable.dart';
import 'package:todo_client/todo_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';


@module
abstract class RegisterModule {
  @lazySingleton
  Client get client => Client(
        'http://localhost:8080/',
        authenticationKeyManager: FlutterAuthenticationKeyManager(),
      )..connectivityMonitor = FlutterConnectivityMonitor();

  @lazySingleton
  SessionManager get sessionManager  {
    final sessionManager = SessionManager(
      caller: client.modules.auth,
    );
    return sessionManager;
  }

  
}
