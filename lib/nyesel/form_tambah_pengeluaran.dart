import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_card.dart';
import 'pengeluaran.dart';
import 'notifikasi.dart';

class FormTambahPengeluaran extends StatefulWidget {
  final Pengeluaran? item;
  final void Function(Pengeluaran baru) onSimpan;
  final VoidCallback? onHapus;

  const FormTambahPengeluaran({
    super.key,
    this.item,
    required this.onSimpan,
    this.onHapus,
  });

  @override
  State<FormTambahPengeluaran> createState() => _FormTambahPengeluaranState();
}

class _FormTambahPengeluaranState extends State<FormTambahPengeluaran> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaController;
  late final TextEditingController _kategoriController;
  late final TextEditingController _nominalController;
  late bool _menyesal;

  static const List<String> _kategoriSaran = ['Hiburan', 'Jajan', 'Makan'];

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.item?.nama ?? '');
    _kategoriController =
        TextEditingController(text: widget.item?.kategori ?? '');
    _nominalController =
        TextEditingController(text: widget.item?.nominal.toString() ?? '');
    _menyesal = widget.item?.menyesal ?? false;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _kategoriController.dispose();
    _nominalController.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final hasil = Pengeluaran(
      id: widget.item?.id ?? buatId(),
      nama: _namaController.text,
      kategori: _kategoriController.text,
      nominal: int.parse(_nominalController.text),
      menyesal: _menyesal,
      waktu: widget.item?.waktu ?? waktuSekarang(),
      tanggal: widget.item?.tanggal ?? DateTime.now(),
    );

    tampilkanNotifikasi(
      context,
      pesan: widget.item == null
          ? 'Pengeluaran berhasil ditambahkan'
          : 'Pengeluaran berhasil diperbarui',
      berhasil: true,
    );
    widget.onSimpan(hasil);
  }

  void _konfirmasiHapus() async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF15142A),
        title: const Text('Hapus Pengeluaran ini?',
            style: TextStyle(color: Colors.white)),
        content: Text(
          '"${_namaController.text}" akan dihapus secara permanen.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Hapus', style: TextStyle(color: Color(0xFFFF6B8A))),
          ),
        ],
      ),
    );

    if (konfirmasi == true) {
      widget.onHapus?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: GlassCard(
        radius: 28,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.item == null ? 'Tambah Pengeluaran' : 'Edit Pengeluaran',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      if(widget.item != null)
                        IconButton(
                          onPressed: _konfirmasiHapus,
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFFF6B8A)),
                        ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildLabel('Nama'),
              TextFormField(
                controller: _namaController,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                decoration: _dekorasiInput('Contoh: Kopi Susu'),
              ),
              const SizedBox(height: 16),
              _buildLabel('Kategori'),
              TextFormField(
                controller: _kategoriController,
                style: const TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Kategori tidak boleh kosong';
                  }
                  return null;
                },
                decoration: _dekorasiInput('Contoh: Jajan'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _kategoriSaran.map((kategori) {
                  return ActionChip(
                    label: Text(kategori),
                    labelStyle:
                        const TextStyle(color: Colors.white, fontSize: 12),
                    backgroundColor: Colors.white.withOpacity(0.08),
                    side: BorderSide(color: Colors.white.withOpacity(0.2)),
                    onPressed: () => _kategoriController.text = kategori,
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              _buildLabel('Nominal'),
              TextFormField(
                controller: _nominalController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  final angka = int.tryParse(value ?? '');
                  if (angka == null || angka <= 0) {
                    return 'Masukkan nominal lebih dari 0';
                  }
                  return null;
                },
                decoration: _dekorasiInput('Contoh: 15000'),
              ),
              const SizedBox(height: 16),
              _buildLabel('Ini pengeluaran layak atau disesali?'),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _TombolPilihan(
                      label: 'Layak',
                      warna: const Color(0xFF3DDC97),
                      aktif: !_menyesal,
                      onTap: () => setState(() => _menyesal = false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TombolPilihan(
                      label: 'Menyesal',
                      warna: const Color(0xFFFF6B8A),
                      aktif: _menyesal,
                      onTap: () => setState(() => _menyesal = true),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpan,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B5CFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    widget.item == null ? 'Simpan' : 'Update',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String teks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        teks,
        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
      ),
    );
  }

  InputDecoration _dekorasiInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.06),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF7B5CFF)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFFF6B8A)),
      ),
    );
  }
}

class _TombolPilihan extends StatelessWidget {
  final String label;
  final Color warna;
  final bool aktif;
  final VoidCallback onTap;

  const _TombolPilihan({
    required this.label,
    required this.warna,
    required this.aktif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:
              aktif ? warna.withOpacity(0.18) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: aktif ? warna : Colors.white.withOpacity(0.2),
            width: aktif ? 1.4 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: aktif ? warna : Colors.white70,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
