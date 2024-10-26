import 'dart:convert';

import 'package:flutter/material.dart';

class ProductAvailabilityModel {
  final String productId;
  final List<DateTimeRange> unavailableDates;

  ProductAvailabilityModel({
    required this.productId,
    required this.unavailableDates,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'unavailable_dates': unavailableDates
          .map((dateRange) => {
                'start': dateRange.start.toIso8601String(),
                'end': dateRange.end.toIso8601String(),
              })
          .toList(),
    };
  }

  factory ProductAvailabilityModel.fromMap(Map<String, dynamic> map) {
    print("map: $map");
    return ProductAvailabilityModel(
      productId: map['product_id'] as String,
      unavailableDates: List<DateTimeRange>.from(
        (map['unavailable_dates'] as List<dynamic>).map<DateTimeRange>(
          (dateRangeMap) => DateTimeRange(
            start: DateTime.parse(dateRangeMap['start_date'] as String),
            end: DateTime.parse(dateRangeMap['end_date'] as String),
          ),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  static List<ProductAvailabilityModel> fromJsonList(String source) {
    final List<dynamic> jsonList = json.decode(source) as List<dynamic>;
    return jsonList
        .map((map) =>
            ProductAvailabilityModel.fromMap(map as Map<String, dynamic>))
        .toList();
  }
}
