// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/cubit/antrian_cubit.dart';
import 'package:flutter_application_2/cubit/theme_cubit.dart';
import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('drawer menyediakan pengaturan tema', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => AntrianCubit()),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Ringkasan Hari Ini'), findsOneWidget);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    expect(find.text('Pengaturan Tema'), findsOneWidget);
    expect(find.text('Mode Gelap'), findsOneWidget);
    expect(find.text('Terang'), findsOneWidget);
    expect(find.text('Gelap'), findsOneWidget);
    expect(find.text('Sistem'), findsOneWidget);
    expect(find.text('Warna Tema'), findsOneWidget);
  });
}
