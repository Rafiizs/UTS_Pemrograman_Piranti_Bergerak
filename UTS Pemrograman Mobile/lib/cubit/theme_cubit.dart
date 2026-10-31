import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeState {
  final Color seed;
  final ThemeMode mode;

  const ThemeState({
    this.seed = Colors.green,
    this.mode = ThemeMode.system,
  });
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  void setMode(ThemeMode mode) {
    emit(ThemeState(seed: state.seed, mode: mode));
  }

  void setSeed(Color seed) {
    emit(ThemeState(seed: seed, mode: state.mode));
  }
}
