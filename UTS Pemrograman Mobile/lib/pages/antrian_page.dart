import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/antrian_cubit.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';

class AntrianPage extends StatelessWidget {
  const AntrianPage({super.key});

  Future<void> _konfirmasiReset(BuildContext context) async {
    final ya = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset antrian?'),
        content: const Text('Semua nomor antrian akan dihapus dan mulai dari A-001.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Reset')),
        ],
      ),
    );
    if (ya == true && context.mounted) {
      context.read<AntrianCubit>().reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hitung Antrian'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            tooltip: 'Reset antrian',
            icon: const Icon(Icons.restart_alt),
            onPressed: () => _konfirmasiReset(context),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: BlocBuilder<AntrianCubit, AntrianState>(
                builder: (context, s) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // ===== Kartu besar: sedang dilayani =====
                      Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: cs.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SEDANG DILAYANI',
                                style: tt.titleMedium?.copyWith(
                                    color: cs.onPrimary, letterSpacing: 2)),
                            const SizedBox(height: 16),
                            Text(
                              s.sedangDilayani == null
                                  ? '—'
                                  : formatNomor(s.sedangDilayani!),
                              style: tt.displayMedium?.copyWith(
                                  color: cs.onPrimary,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ===== Info: menunggu & nomor terakhir =====
                      LayoutBuilder(builder: (context, box) {
                        final lebar = box.maxWidth > 500;
                        final menunggu = _KartuInfo(
                          ikon: Icons.hourglass_empty,
                          judul: 'Menunggu',
                          nilai: '${s.menunggu.length} orang',
                        );
                        final terakhir = _KartuInfo(
                          ikon: Icons.confirmation_number,
                          judul: 'Nomor Terakhir',
                          nilai: s.nomorTerakhir == 0
                              ? '-'
                              : formatNomor(s.nomorTerakhir),
                        );
                        return lebar
                            ? Row(children: [
                                Expanded(child: menunggu),
                                const SizedBox(width: 12),
                                Expanded(child: terakhir),
                              ])
                            : Column(children: [
                                menunggu,
                                const SizedBox(height: 12),
                                terakhir,
                              ]);
                      }),
                      const SizedBox(height: 16),

                      // ===== Tombol aksi =====
                      FilledButton.icon(
                        onPressed: s.menunggu.isEmpty
                            ? null
                            : () => context
                                .read<AntrianCubit>()
                                .panggilBerikutnya(),
                        icon: const Icon(Icons.campaign),
                        label: const Text('Panggil Berikutnya'),
                        style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(48)),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: OutlinedButton.icon(
                              onPressed: s.menunggu.isEmpty
                                  ? null
                                  : () =>
                                      context.read<AntrianCubit>().batalNomor(),
                              icon: const Icon(Icons.remove),
                              label: const Text('Batal'),
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(44)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: FilledButton.tonalIcon(
                              onPressed: () =>
                                  context.read<AntrianCubit>().ambilNomor(),
                              icon: const Icon(Icons.add),
                              label: const Text('Ambil Nomor'),
                              style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(44)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ===== Daftar menunggu =====
                      Text('Daftar Menunggu', style: tt.titleMedium),
                      const SizedBox(height: 8),
                      if (s.menunggu.isEmpty)
                        const Text('Belum ada.')
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final n in s.menunggu)
                              Chip(
                                avatar: Icon(Icons.person, color: cs.primary),
                                label: Text(formatNomor(n)),
                              ),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // ===== Riwayat sudah dilayani =====
                      Text('Sudah Dilayani (${s.sudahDilayani.length})',
                          style: tt.titleMedium),
                      const SizedBox(height: 8),
                      if (s.sudahDilayani.isEmpty)
                        const Text('Belum ada.')
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final n in s.sudahDilayani)
                              Chip(
                                avatar: Icon(Icons.check_circle,
                                    color: cs.primary),
                                label: Text(formatNomor(n)),
                              ),
                          ],
                        ),
                      const SizedBox(height: 24),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KartuInfo extends StatelessWidget {
  final IconData ikon;
  final String judul;
  final String nilai;

  const _KartuInfo(
      {required this.ikon, required this.judul, required this.nilai});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cs.secondaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(ikon, color: cs.onSecondaryContainer),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(judul,
                  style: tt.bodyMedium
                      ?.copyWith(color: cs.onSecondaryContainer)),
              Text(nilai,
                  style: tt.titleMedium?.copyWith(
                      color: cs.onSecondaryContainer,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
