import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'glass_card.dart';
import 'notifikasi.dart';
import 'pengaturan.dart';

class FormPengaturan extends StatefulWidget {
  const FormPengaturan({super.key});

  @override
  State<FormPengaturan> createState() => _FormPengaturanState();
}

class _FormPengaturanState extends State<FormPengaturan> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _batasController;
  late final TextEditingController _uangMakanController;

  @override
  void initState() {
    super.initState();
    _batasController =
        TextEditingController(text: preferensiBatasHarian.value.toString());
    _uangMakanController =
        TextEditingController(text: preferensiUangMakanHarian.value.toString());
  }

  @override
  void dispose() {
    _batasController.dispose();
    _uangMakanController.dispose();
    super.dispose();
  }

  void _simpanAngka() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    simpanBatasHarian(int.parse(_batasController.text));
    simpanUangMakanHarian(int.parse(_uangMakanController.text));

    tampilkanNotifikasi(context, pesan: 'Pengaturan disimpan', berhasil: true);
    Navigator.pop(context);
  }

  String? _validasiAngka(String? value) {
    final angka = int.tryParse(value ?? '');
    if (angka == null || angka <= 0) {
      return 'Isi angka lebih dari 0';
    }
    return null;
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
                  const Text(
                    'Pengaturan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white70),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Batas pengeluaran harian',
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _batasController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validasiAngka,
                decoration: InputDecoration(
                  hintText: 'Contoh: 50000',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.15)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Uang makan harian',
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _uangMakanController,
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: _validasiAngka,
                decoration: InputDecoration(
                  hintText: 'Contoh: 20000',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.35)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.06),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        BorderSide(color: Colors.white.withOpacity(0.15)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _simpanAngka,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B5CFF),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Simpan',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Ketebalan Liquid Glass',
                style: TextStyle(
                    fontSize: 12, color: Colors.white.withOpacity(0.7)),
              ),
              const SizedBox(height: 4),
              ValueListenableBuilder<double>(
                valueListenable: preferensiKetebalan,
                builder: (context, nilai, _) {
                  return Row(
                    children: [
                      const Text('Tipis',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 11)),
                      Expanded(
                        child: Slider(
                          value: nilai,
                          min: 0.0,
                          max: 1.0,
                          activeColor: const Color(0xFF7B5CFF),
                          inactiveColor: Colors.white.withOpacity(0.15),
                          onChanged: (nilaiBaru) {
                            preferensiKetebalan.value = nilaiBaru;
                          },
                          onChangeEnd: (nilaiAkhir) {
                            simpanKetebalan(nilaiAkhir);
                          },
                        ),
                      ),
                      const Text('Tebal',
                          style:
                              TextStyle(color: Colors.white54, fontSize: 11)),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(
                  child: Text(
                    'Ingatkan aku jam 20.00 tiap hari',
                    style: TextStyle(
                        fontSize: 12, color: Colors.white.withOpacity(0.7)),
                  ),
                ),
                ValueListenableBuilder<bool>(
                    valueListenable: preferensiReminder,
                    builder: (context, aktif, _) {
                      return Switch(
                        value: aktif,
                        activeColor: const Color(0xFF7B5CFF),
                        onChanged: (nilai) => simpanReminder(nilai),
                      );
                    },
                  ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
