import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/antrian_cubit.dart';
import 'cubit/theme_cubit.dart';
import 'pages/antrian_page.dart';
import 'pages/beranda_page.dart';

void main() {
  runApp(
    // Dua Cubit disediakan di puncak pohon widget (MultiBlocProvider).
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => AntrianCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _bangunTema(Color seed, Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: brightness,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BlocBuilder membangun ulang MaterialApp setiap tema berubah
    // -> inilah dynamic theme.
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, tema) {
        return MaterialApp(
          title: 'Antrian Toko Hebat',
          debugShowCheckedModeBanner: false,
          theme: _bangunTema(tema.seed, Brightness.light),
          darkTheme: _bangunTema(tema.seed, Brightness.dark),
          themeMode: tema.mode,
          initialRoute: '/',
          routes: {
            '/': (_) => const BerandaPage(),
            '/antrian': (_) => const AntrianPage(),
          },
        );
      },
    );
  }
}
