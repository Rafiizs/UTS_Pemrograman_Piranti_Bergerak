import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/theme_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const _warnaTema = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.deepPurple,
    Colors.orange,
    Colors.teal,
  ];

  void _bukaHalaman(BuildContext context, String route) {
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final cs = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              color: cs.primaryContainer,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(Icons.storefront, size: 40, color: cs.onPrimaryContainer),
                    const SizedBox(height: 8),
                    Text(
                      'Antrian Toko Hebat',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: cs.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      'Hitung antrian pembeli',
                      style: TextStyle(color: cs.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Beranda'),
              selected: currentRoute == '/',
              onTap: () => _bukaHalaman(context, '/'),
            ),
            ListTile(
              leading: const Icon(Icons.people_outline),
              title: const Text('Hitung Antrian'),
              selected: currentRoute == '/antrian',
              onTap: () => _bukaHalaman(context, '/antrian'),
            ),
            const Divider(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
              child: Text(
                'Pengaturan Tema',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, state) {
                final cubit = context.read<ThemeCubit>();
                return Column(
                  children: [
                    SwitchListTile(
                      secondary: const Icon(Icons.wb_sunny_outlined),
                      title: const Text('Mode Gelap'),
                      value: state.mode == ThemeMode.dark,
                      onChanged: (aktif) {
                        cubit.setMode(
                          aktif ? ThemeMode.dark : ThemeMode.light,
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SegmentedButton<ThemeMode>(
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.check, size: 16),
                            label: Text('Terang'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode, size: 16),
                            label: Text('Gelap'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.system,
                            icon: Icon(Icons.phone_iphone, size: 16),
                            label: Text('Sistem'),
                          ),
                        ],
                        selected: {state.mode},
                        onSelectionChanged: (selection) {
                          cubit.setMode(selection.first);
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Warna Tema'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final warna in _warnaTema)
                            _PilihanWarna(
                              warna: warna,
                              terpilih: warna.toARGB32() == state.seed.toARGB32(),
                              onTap: () => cubit.setSeed(warna),
                            ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PilihanWarna extends StatelessWidget {
  const _PilihanWarna({
    required this.warna,
    required this.terpilih,
    required this.onTap,
  });

  final Color warna;
  final bool terpilih;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: terpilih,
      label: 'Pilih warna tema',
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: warna,
            shape: BoxShape.circle,
            border: terpilih
                ? Border.all(color: Theme.of(context).colorScheme.onSurface, width: 2)
                : null,
          ),
          child: terpilih
              ? const Icon(Icons.check, color: Colors.white, size: 24)
              : null,
        ),
      ),
    );
  }
}
