import 'package:flutter_test/flutter_test.dart';
import 'package:nyesel/nyesel/pengeluaran.dart';

void main() {
  group('formatRupiah', () {
    test('angka dibawah 1000 tidak pakai titik', () {
      expect(formatRupiah(500), 'Rp 500');
    });

    test('ribuan dipisah titik', () {
      expect(formatRupiah(1000), 'Rp 1.000');
      expect(formatRupiah(10000), 'Rp 10.000');
    });

    test('jutaan dipisah titik di tiap 3 digit', () {
      expect(formatRupiah(1234567), 'Rp 1.234.567');
    });

    test('nol tetap valid', () {
      expect(formatRupiah(0), 'Rp 0');
    });
  });

  group('Pengeluaran JSON', () {
    test('toJSON lalu fromJSON menghasilkan data yang sama', () {
      final asli = Pengeluaran(
        id: 'id-1',
        nama: 'Kopi susu',
        kategori: 'Jajan',
        nominal: 18000,
        menyesal: true,
        waktu: 'Hari ini, 10.30',
        tanggal: DateTime(2024, 6, 1, 10, 30),
      );

      final json = asli.toJson();
      final hasil = Pengeluaran.fromJson(json);

      expect(hasil.id, asli.id);
      expect(hasil.nama, asli.nama);
      expect(hasil.kategori, asli.kategori);
      expect(hasil.nominal, asli.nominal);
      expect(hasil.menyesal, asli.menyesal);
      expect(hasil.waktu, asli.waktu);
      expect(hasil.tanggal, asli.tanggal);
    });

    test('fromJSON tetap jalan walaupun data lama tidak punya id', () {
      final jsonLama = {
        'nama': 'Nasi Padang',
        'kategori': 'Makan',
        'nominal': 25000,
        'menyesal': false,
        'waktu': 'Kemarin, 12.00',
        'tanggal': DateTime(2024, 5, 31, 12, 0).toIso8601String(),
      };

      final hasil = Pengeluaran.fromJson(jsonLama);

      expect(hasil.id, isNotEmpty);
      expect(hasil.nama, 'Nasi Padang');
    });
  });
}
