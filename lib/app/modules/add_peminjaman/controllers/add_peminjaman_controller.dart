import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peminjaman_perpustakaan_kelas_b/app/data/constant/endpoint.dart';
import 'package:peminjaman_perpustakaan_kelas_b/app/data/provider/api_provider.dart';
import 'package:peminjaman_perpustakaan_kelas_b/app/data/provider/storage_provider.dart';
import 'package:peminjaman_perpustakaan_kelas_b/app/routes/app_pages.dart';

class AddPeminjamanController extends GetxController {
  final loading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController tanggalPinjamController = TextEditingController();
  final TextEditingController tanggalKembaliController = TextEditingController();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  post()async {
    loading(true);
    try {
      FocusScope.of(Get.context!).unfocus();
      formKey.currentState?.save();
      if (formKey.currentState!.validate()) {
        final response = await ApiProvider.instance().post(Endpoint.pinjam,
            data:
            {
              "user_id": StorageProvider.read(StorageKey.idUser),
              "book_id": Get.parameters['id'],
              "tanggal_pinjam": tanggalPinjamController.text.toString(),
              "tanggal_kembali": tanggalKembaliController.text.toString(),

            }
        );
        if (response.statusCode == 201) {
          Get.back();
        } else {
          Get.snackbar("Sorry", "Add Peminjaman Gagal", backgroundColor: Colors.orange);
        }
      }
      loading(false);
    } on DioException catch (e) {
      loading(false);
      if (e.response != null) {
        Get.snackbar("Sorry", "${e.response?.data['message']}",
            backgroundColor: Colors.orange);
      } else {
        Get.snackbar("Sorry", e.message ?? "", backgroundColor: Colors.red);
      }
    } catch (e) {
      loading(false);
      Get.snackbar("Eror", e.toString(), backgroundColor: Colors.red);
    }
  }

  void increment() => count.value++;
}
