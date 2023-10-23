import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/config/config.dart';
import 'package:auth_app/config/environment/environment.dart';
import 'package:auth_app/config/router/app_router.dart';

void main() async{
  await Environment.initEnvironment();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appRouterProvider = ref.watch(goRouterProvider);

    return MaterialApp.router(
      routerConfig: appRouterProvider,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}
