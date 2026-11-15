import 'package:flutter/material.dart';

import '../../core/theme.dart';
import '../common/coming_soon_screen.dart';

class _HomeTile {
  const _HomeTile(this.title, this.icon, this.phaseNote);
  final String title;
  final IconData icon;
  final String phaseNote;
}

const List<_HomeTile> _tiles = [
  _HomeTile('সরকারি সেবা', Icons.account_balance, 'Phase 4–5-এ আসছে'),
  _HomeTile('ভাতা ও সুবিধা', Icons.volunteer_activism, 'Phase 5-এ আসছে'),
  _HomeTile('ক্যারিয়ার রোডম্যাপ', Icons.route, 'Phase 6-এ আসছে'),
  _HomeTile('কাছের অফিস', Icons.location_on, 'Phase 5-এ আসছে'),
  _HomeTile('আমার চেকলিস্ট', Icons.checklist, 'Phase 6-এ আসছে'),
  _HomeTile('সংরক্ষিত গাইড', Icons.bookmark, 'Phase 6-এ আসছে'),
];

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, String title, String note) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComingSoonScreen(title: title, phaseNote: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                onSearchTap: () => _open(
                  context,
                  'স্মার্ট সার্ভিস অ্যাসিস্ট্যান্ট',
                  'Phase 4-এ আসছে',
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.25,
                  children: [
                    for (final t in _tiles)
                      _TileCard(
                        tile: t,
                        onTap: () => _open(context, t.title, t.phaseNote),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onSearchTap});
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.navy,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.teal,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.alt_route, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Text(
                'পথসাথী BD',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'সহায়তা খুঁজুন • দক্ষতা গড়ুন • ভবিষ্যৎ সাজান',
            style: TextStyle(color: Color(0xFFB8C7DA), fontSize: 13),
          ),
          const SizedBox(height: 18),
          TextField(
            readOnly: true,
            onTap: onSearchTap,
            decoration: InputDecoration(
              hintText: 'যেমন: জন্মনিবন্ধন সংশোধন করতে কোথায় যাব?',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TileCard extends StatelessWidget {
  const _TileCard({required this.tile, required this.onTap});
  final _HomeTile tile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(tile.icon, size: 36, color: AppColors.teal),
              const SizedBox(height: 10),
              Text(
                tile.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
