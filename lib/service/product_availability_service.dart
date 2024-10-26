import 'dart:convert';

import 'package:calender_assignment/constants/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/product_availability_model.dart';

class ProductAvailabilityService extends GetxService {
  Future<void> saveUnavailableDates(
      ProductAvailabilityModel availability) async {
    try {
      final url = Uri.parse(
          '${Constants.apiUrl}/availability/${availability.productId}/');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'product_id': availability.productId,
        'unavailable_dates': availability.unavailableDates
            .map((range) => {
                  'start_date': range.start.toIso8601String().substring(0, 10),
                  'end_date': range.end.toIso8601String().substring(0, 10),
                })
            .toList(),
      });

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('Unavailable dates updated successfully');
      } else {
        print('Error updating unavailable dates: ${response.statusCode}');
        print('Error updating unavailable dates: ${response.body}');
        print(response.body);

        throw Exception('Failed to update unavailable dates');
      }
    } catch (e) {
      print('Error: $e');

      rethrow;
    }
  }

  Future<ProductAvailabilityModel?> getProductData() async {
    try {
      final url = Uri.parse('${Constants.apiUrl}/availability/');
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = ProductAvailabilityModel.fromJsonList(response.body);
        if (data.isEmpty) {
          return null;
        } else {
          return data.last;
        }
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }
}
