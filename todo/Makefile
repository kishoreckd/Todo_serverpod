migrate:
	@cd todo_server && dart run bin/main.dart --role maintenance --apply-migrations
server:
	@cd todo_server && dart bin/main.dart
generate:
	@cd todo_server && serverpod generate

app_build:
	@cd todo_flutter && flutter run build_runner build --delete-conflicting-outputs
app_run:
	@cd todo_flutter && flutter run --target lib/main_development.dart