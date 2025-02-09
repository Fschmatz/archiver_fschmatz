import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'app.dart';

class AppTheme extends StatelessWidget {
  const AppTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: lightDynamic,
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: darkDynamic,
                useMaterial3: true,
              ),
              themeMode: EasyDynamicTheme
                  .of(context)
                  .themeMode,
              home: const App());
        });
  }
}