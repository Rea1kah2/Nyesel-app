import 'package:flutter/material.dart';
import 'glass_card.dart';
import 'pengeluaran.dart';

class KartuPengeluaran extends StatelessWidget {
  final Pengeluaran item;
  final VoidCallback? onTap;

  const KartuPengeluaran({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    final warnaTag =
        item.menyesal ? const Color(0xFFFF6B8A) : const Color(0xFF3DDC97);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GlassCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nama,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.kategori} • ${item.waktu}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.65),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: warnaTag.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: warnaTag.withOpacity(0.55),
                        ),
                      ),
                      child: Text(
                        item.menyesal ? 'Menyesal' : 'Layak',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: warnaTag,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatRupiah(item.nominal),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
