import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'routes/app_router.dart';
import 'features/task_manager/cubit/task_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = AppRouter();

    return BlocProvider(
      create: (_) => TaskCubit(),
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'BT Assessment',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.deepPurple,
            elevation: 4,
            surfaceTintColor: Colors.transparent, // removes M3 overlay
            iconTheme: IconThemeData(color: Colors.white), // ← all icons white
            titleTextStyle: TextStyle(
              color: Colors.white, // ← title text white
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
