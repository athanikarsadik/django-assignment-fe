import 'package:calender_assignment/controller/product_availability_controller.dart';
import 'package:calender_assignment/presentation/product_availability_screen.dart';
import 'package:calender_assignment/service/product_availability_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(ProductAvailabilityService());
  Get.put(ProductAvailabilityController(availabilityService: Get.find()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductAvailabilityScreen(),
    );
  }
}
