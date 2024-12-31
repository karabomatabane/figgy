import 'package:figgy/pages/home_page.dart';
import 'package:figgy/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/gif_bloc.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figgy',
      theme: ThemeData(
        //set dark theme
        colorScheme: darkColorScheme,
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => GifBloc(),
        child: const HomePage(),
      ),
    );
  }
}
