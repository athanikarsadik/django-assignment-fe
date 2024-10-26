import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_availability_model.dart';
import '../service/product_availability_service.dart';

class ProductAvailabilityController extends GetxController {
  final RxBool isUploading = false.obs;
  final ProductAvailabilityService _availabilityService;

  ProductAvailabilityController(
      {required ProductAvailabilityService availabilityService})
      : _availabilityService = availabilityService;

  Future<void> submitAvailability(
      String productId, List<DateTimeRange> unavailableDates) async {
    try {
      isUploading.value = true;
      final availabilityModel = ProductAvailabilityModel(
        productId: productId,
        unavailableDates: unavailableDates,
      );

      await _availabilityService.saveUnavailableDates(availabilityModel);

      Get.snackbar(
        'Success',
        'Unavailable dates saved successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save unavailable dates. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading.value = false;
    }
  }

  Future<ProductAvailabilityModel?> getData() async {
    try {
      final res = await _availabilityService.getProductData();
      return res;
    } catch (e) {
      Get.snackbar(
        'Error!',
        'Failed to get data',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    }
  }
}
