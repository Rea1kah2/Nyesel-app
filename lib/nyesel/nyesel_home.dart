import 'package:flutter/material.dart';
import 'app_background.dart';
import 'glass_card.dart';
import 'kartu_pengeluaran.dart';
import 'pengeluaran.dart';
import 'form_tambah_pengeluaran.dart';
import 'pengaturan.dart';
import 'form_pengaturan.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'notifikasi.dart';

class NyeselHome extends StatefulWidget {
  const NyeselHome({super.key});

  @override
  State<NyeselHome> createState() => _NyeselHomeState();
}

class _NyeselHomeState extends State<NyeselHome> {
  List<Pengeluaran> _daftar = [];

  String? _filterKategori;

  @override
  void initState() {
    super.initState();
    _muatData();
    muatPengaturan();
    preferensiBatasHarian.addListener(_onPengaturanBerubah);
    preferensiUangMakanHarian.addListener(_onPengaturanBerubah);
  }

  void _onPengaturanBerubah() {
    setState(() {});
  }

  @override
  void dispose() {
    preferensiBatasHarian.removeListener(_onPengaturanBerubah);
    preferensiUangMakanHarian.removeListener(_onPengaturanBerubah);
    super.dispose();
  }

  Future<void> _muatData() async {
    final prefs = await SharedPreferences.getInstance();
    final dataTersimpan = prefs.getString('daftar_pengeluaran');

    if (dataTersimpan == null) {
      return;
    }

    final List<dynamic> daftarJson = jsonDecode(dataTersimpan);
    setState(() {
      _daftar = daftarJson
          .map((item) => Pengeluaran.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  Future<void> _simpanKeStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final daftarJson = _daftar.map((item) => item.toJson()).toList();
    await prefs.setString('daftar_pengeluaran', jsonEncode(daftarJson));
  }

  void _bukaForm({Pengeluaran? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: FormTambahPengeluaran(
            item: item,
            onSimpan: (hasil) {
              Navigator.pop(context);
              if (item == null) {
                _tambahPengeluaran(hasil);
              } else {
                _updatePengeluaran(item, hasil);
              }
            },
            onHapus: item == null
                ? null
                : () {
                    Navigator.pop(context);
                    _hapusPengeluaran(item);
                  },
          ),
        );
      },
    );
  }

  void _bukaPengaturan() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: const FormPengaturan(),
        );
      },
    );
  }

  void _tambahPengeluaran(Pengeluaran baru) {
    setState(() {
      _daftar.insert(0, baru);
    });
    _simpanKeStorage();
  }

  void _updatePengeluaran(Pengeluaran lama, Pengeluaran baru) {
    setState(() {
      final index = _daftar.indexWhere((item) => item.id == lama.id);
      if (index != -1) {
        _daftar[index] = baru;
      }
    });
    _simpanKeStorage();
  }

  void _hapusPengeluaran(Pengeluaran item) {
    setState(() {
      _daftar.removeWhere((element) => element.id == item.id);
    });
    _simpanKeStorage();
    tampilkanNotifikasi(context, pesan: 'Pengeluaran dihapus', berhasil: true);
  }

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();

    final daftarBulanIni = _daftar
        .where((item) =>
            item.tanggal.year == sekarang.year &&
            item.tanggal.month == sekarang.month)
        .toList();

    final totalSemua = daftarBulanIni.fold<int>(
      0,
      (jumlah, item) => jumlah + item.nominal,
    );

    final totalMenyesal = daftarBulanIni
        .where((item) => item.menyesal)
        .fold<int>(0, (jumlah, item) => jumlah + item.nominal);

    final persenMenyesal =
        totalSemua == 0 ? 0 : (totalMenyesal * 100 / totalSemua).round();

    final setaraHari = (totalSemua / preferensiUangMakanHarian.value).floor();

    final totalHariIni = _daftar
        .where((item) =>
            item.tanggal.year == sekarang.year &&
            item.tanggal.month == sekarang.month &&
            item.tanggal.day == sekarang.day)
        .fold<int>(0, (jumlah, item) => jumlah + item.nominal);

    final sisaHariIni = preferensiBatasHarian.value - totalHariIni;

    final kategoriTersedia =
        <String>{'Semua', ..._daftar.map((item) => item.kategori)}.toList();
    final daftarTampil = _filterKategori == null
        ? _daftar
        : _daftar.where((item) => item.kategori == _filterKategori).toList();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF7B5CFF),
        onPressed: _bukaForm,
        child: const Icon(Icons.add),
      ),
      body: AppBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nyesel',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Pelacak uang yang disesali',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: _bukaPengaturan,
                      icon: Icon(Icons.settings,
                          color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                SizedBox(
                  width: double.infinity,
                  child: GlassCard(
                    ketebalanMinimal: 0.5,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Uang yang disesali bulan ini',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          formatRupiah(totalMenyesal),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Setara $setaraHari hari uang makan',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFFFF6B8A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _KotakRingkas(
                        label: 'Total Keluar',
                        nilai: formatRupiah(totalSemua),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _KotakRingkas(
                        label: 'Yang disesali',
                        nilai: '$persenMenyesal%',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                GlassCard(
                  radius: 22,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        sisaHariIni >= 0
                            ? 'Sisa jatah hari ini'
                            : 'Sudah lewat jatah hari ini',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.75),
                        ),
                      ),
                      Text(
                        formatRupiah(sisaHariIni.abs()),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: sisaHariIni >= 0
                              ? Colors.white
                              : const Color(0xFFFF6B8A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Pengeluaran terakhir',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: kategoriTersedia.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final kategori = kategoriTersedia[index];
                      final aktif = kategori == 'Semua'
                          ? _filterKategori == null
                          : _filterKategori == kategori;

                      return ChoiceChip(
                        label: Text(kategori),
                        selected: aktif,
                        showCheckmark: false,
                        onSelected: (_) {
                          setState(() {
                            _filterKategori =
                                kategori == 'Semua' ? null : kategori;
                          });
                        },
                        labelStyle: TextStyle(
                          color: aktif ? Colors.white : Colors.white70,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.white.withOpacity(0.06),
                        selectedColor: const Color(0xFF7B5CFF),
                        side: BorderSide(
                          color: aktif
                              ? const Color(0xFF7B5CFF)
                              : Colors.white.withOpacity(0.2),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                if (daftarTampil.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Belum ada pengeluaran di kategori ini',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.5), fontSize: 13),
                    ),
                  )
                else
                  ...daftarTampil.map(
                    (item) => KartuPengeluaran(
                      item: item,
                      onTap: () => _bukaForm(item: item),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KotakRingkas extends StatelessWidget {
  final String label;
  final String nilai;

  const _KotakRingkas({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 22,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            nilai,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
