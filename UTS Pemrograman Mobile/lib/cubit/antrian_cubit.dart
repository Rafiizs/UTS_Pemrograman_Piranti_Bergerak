import 'package:flutter_bloc/flutter_bloc.dart';

/// Mengubah angka 5 menjadi "A-005".
String formatNomor(int n) => 'A-${n.toString().padLeft(3, '0')}';

class AntrianState {
  final int nomorTerakhir; // nomor terakhir yang diambil
  final int? sedangDilayani; // null = belum ada
  final List<int> menunggu;
  final List<int> sudahDilayani;

  const AntrianState({
    this.nomorTerakhir = 0,
    this.sedangDilayani,
    this.menunggu = const [],
    this.sudahDilayani = const [],
  });
}

class AntrianCubit extends Cubit<AntrianState> {
  AntrianCubit() : super(const AntrianState());

  /// Pembeli baru mengambil nomor antrian.
  void ambilNomor() {
    final baru = state.nomorTerakhir + 1;
    emit(AntrianState(
      nomorTerakhir: baru,
      sedangDilayani: state.sedangDilayani,
      menunggu: [...state.menunggu, baru],
      sudahDilayani: state.sudahDilayani,
    ));
  }

  /// Membatalkan nomor paling akhir yang diambil.
  void batalNomor() {
    if (state.menunggu.isEmpty) return;
    final sisa = [...state.menunggu]..removeLast();
    emit(AntrianState(
      nomorTerakhir: state.nomorTerakhir - 1,
      sedangDilayani: state.sedangDilayani,
      menunggu: sisa,
      sudahDilayani: state.sudahDilayani,
    ));
  }

  /// Memanggil pembeli berikutnya; yang tadi dilayani masuk ke riwayat.
  void panggilBerikutnya() {
    if (state.menunggu.isEmpty) return;
    final sisa = [...state.menunggu];
    final berikut = sisa.removeAt(0);
    final riwayat = [...state.sudahDilayani];
    if (state.sedangDilayani != null) riwayat.add(state.sedangDilayani!);
    emit(AntrianState(
      nomorTerakhir: state.nomorTerakhir,
      sedangDilayani: berikut,
      menunggu: sisa,
      sudahDilayani: riwayat,
    ));
  }

  /// Mengulang antrian dari awal.
  void reset() => emit(const AntrianState());
}
