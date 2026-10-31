import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/antrian_cubit.dart';
import '../widgets/app_background.dart';
import '../widgets/app_drawer.dart';

class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        backgroundColor: Colors.transparent,
      ),
      drawer: const AppDrawer(),
      extendBodyBehindAppBar: true,
      body: AppBackground(
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  const SizedBox(height: 48),
                  // ===== Kartu sambutan =====
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: cs.primary,
                          child: Icon(Icons.storefront,
                              size: 34, color: cs.onPrimary),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Selamat Datang!',
                                  style: tt.titleLarge?.copyWith(
                                      color: cs.onPrimaryContainer,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(
                                'Kelola antrian Toko Hebat dengan mudah.',
                                style: tt.bodyMedium
                                    ?.copyWith(color: cs.onPrimaryContainer),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Ringkasan Hari Ini', style: tt.titleMedium),
                  const SizedBox(height: 12),

                  // ===== Statistik: dibangun ulang oleh BlocBuilder =====
                  BlocBuilder<AntrianCubit, AntrianState>(
                    builder: (context, s) {
                      return Row(
                        children: [
                          Expanded(
                            child: _KartuStat(
                              ikon: Icons.confirmation_number,
                              nilai: '${s.nomorTerakhir}',
                              label: 'Nomor Diambil',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _KartuStat(
                              ikon: Icons.record_voice_over,
                              nilai: s.sedangDilayani == null
                                  ? '-'
                                  : formatNomor(s.sedangDilayani!),
                              label: 'Sedang Dilayani',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<AntrianCubit, AntrianState>(
                    builder: (context, s) => Row(
                      children: [
                        Expanded(
                          child: _KartuStat(
                            ikon: Icons.hourglass_bottom,
                            nilai: '${s.menunggu.length}',
                            label: 'Menunggu',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _KartuStat(
                            ikon: Icons.check_circle_outline,
                            nilai: '${s.sudahDilayani.length}',
                            label: 'Sudah Dilayani',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => Navigator.pushReplacementNamed(
                        context, '/antrian'),
                    icon: const Icon(Icons.people),
                    label: const Text('Mulai Hitung Antrian'),
                    style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _KartuStat extends StatelessWidget {
  final IconData ikon;
  final String nilai;
  final String label;

  const _KartuStat(
      {required this.ikon, required this.nilai, required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHighest.withOpacity(0.7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 12),
        child: Column(
          children: [
            Icon(ikon, color: cs.primary),
            const SizedBox(height: 6),
            Text(nilai,
                style: tt.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
            Text(label, style: tt.bodyMedium),
          ],
        ),
      ),
    );
  }
}
