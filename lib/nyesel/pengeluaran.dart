class Pengeluaran {
  final String id;
  final String nama;
  final String kategori;
  final int nominal;
  final bool menyesal;
  final String waktu;
  final DateTime tanggal;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'kategori': kategori,
      'nominal': nominal,
      'menyesal': menyesal,
      'waktu': waktu,
      'tanggal': tanggal.toIso8601String(),
    };
  }

  factory Pengeluaran.fromJson(Map<String, dynamic> json) {
    return Pengeluaran(
      id: json['id'] as String? ?? buatId(),
      nama: json['nama'] as String,
      kategori: json['kategori'] as String,
      nominal: json['nominal'] as int,
      menyesal: json['menyesal'] as bool,
      waktu: json['waktu'] as String,
      tanggal: json['tanggal'] != null ? DateTime.parse(json['tanggal'] as String) : DateTime.now(),
    );
  }

  const Pengeluaran({
    required this.id,
    required this.nama,
    required this.kategori,
    required this.nominal,
    required this.menyesal,
    required this.waktu,
    required this.tanggal,
  });
}

/// Id unik berbasis waktu, cukup untuk membedakan antar item di penyimpanan lokal.
String buatId() => DateTime.now().microsecondsSinceEpoch.toString();

String formatRupiah(int nominal) {
  final teks = nominal.toString();
  final hasil = StringBuffer();
  for (int i = 0; i < teks.length; i++) {
    if (i > 0 && (teks.length - 1) % 3 == 0) {
      hasil.write('.');
    }
    hasil.write(teks[i]);
  }
  return 'Rp ${hasil.toString()}';
}

String waktuSekarang() {
  final sekarang = DateTime.now();
  final jam = sekarang.hour.toString().padLeft(2, '0');
  final menit = sekarang.minute.toString().padLeft(2, '0');
  return 'Hari ini, $jam.$menit';
}
