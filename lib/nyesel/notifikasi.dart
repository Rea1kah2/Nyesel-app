import 'package:flutter/material.dart';

void tampilkanNotifikasi(
  BuildContext context, {
  required String pesan,
  required bool berhasil,
}) {
  final warna = berhasil ? const Color(0xFF3DDC97) : const Color(0xFFFF6B8A);

  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF15142A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: warna.withOpacity(0.6)),
        ),
        duration: const Duration(seconds: 2),
        content: Row(
          children: [
            Icon(
              berhasil ? Icons.check_circle : Icons.error,
              color: warna,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                pesan,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
}
