import 'package:femora/config/constants.dart';
import 'package:flutter/material.dart';
import 'package:femora/widgets/custom_back_button.dart';
import 'package:go_router/go_router.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  static const String routeName = '/help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: CustomBackButton(onPressed: () => context.pop())),
        title: const Text('Bantuan',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: AppTextStyles.fontFamily)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Color(0x0F000000),
                    blurRadius: 20,
                    offset: Offset(0, 4))
              ]),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Column(
              children: const [
                HelpExpansionItem(
                  question: 'Bagaimana cara mengganti foto profil?',
                  answer:
                      'Masuk ke halaman profil, ketuk kartu profil Anda di bagian atas, lalu ketuk ikon edit pada foto profil untuk memilih gambar baru dari galeri atau kamera.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara mengubah data personal?',
                  answer:
                      'Masuk ke halaman profil, ketuk kartu profil Anda untuk masuk ke halaman "Personal Data". Di sana Anda dapat mengubah nama, nomor telepon, tanggal lahir, dan berat badan.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara mengaktifkan Alarm Pengingat?',
                  answer:
                      'Masuk ke "Pengaturan" → Pilih "Alarm Pengingat" → Aktifkan Alarm Pengingat.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara mengubah kata sandi?',
                  answer:
                      'Buka "Pengaturan" Akun → Ubah Kata Sandi, lalu masukkan kata sandi baru.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara melihat riwayat siklus?',
                  answer:
                      'Masuk ke menu "Pengaturan" di halaman profil, lalu pilih "Riwayat" untuk melihat catatan siklus Anda sebelumnya.',
                ),
                HelpExpansionItem(
                  question: 'Kenapa siklus saya tidak akurat?',
                  answer:
                      'Pastikan kamu rutin isi Check-in Harian agar prediksi makin tepat.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara menambahkan gejala?',
                  answer:
                      'Pilih Tambah Gejala di halaman Siklusku untuk mencatat kondisi harian.',
                ),
                HelpExpansionItem(
                  question: 'Bagaimana cara menghapus akun?',
                  answer:
                      'Pergi ke "Pengaturan" → Hapus Akun, lalu konfirmasi penghapusan.',
                  isLast: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HelpExpansionItem extends StatelessWidget {
  const HelpExpansionItem({
    super.key,
    required this.question,
    required this.answer,
    this.isLast = false,
  });

  final String question;
  final String answer;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          question,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
