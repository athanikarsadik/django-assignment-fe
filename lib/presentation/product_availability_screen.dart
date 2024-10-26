import 'package:calender_assignment/controller/product_availability_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductAvailabilityScreen extends StatefulWidget {
  const ProductAvailabilityScreen({super.key});

  @override
  State<ProductAvailabilityScreen> createState() =>
      _ProductAvailabilityScreenState();
}

class _ProductAvailabilityScreenState extends State<ProductAvailabilityScreen> {
  DateTime _currentMonth = DateTime(2024, 5);
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    try {
      final res = await Get.find<ProductAvailabilityController>().getData();
      if (res != null) {
        setState(() {
          unavailableDates = res.unavailableDates;
          _currentMonth = res.unavailableDates[0].start;
        });
      }
    } catch (e) {}
  }

  List<DateTimeRange> unavailableDates = [
    DateTimeRange(
      start: DateTime(2024, 5, 10),
      end: DateTime(2024, 5, 14),
    ),
    DateTimeRange(
      start: DateTime(2024, 5, 21),
      end: DateTime(2024, 5, 26),
    ),
  ];

  void _onDateSelected(DateTime date) {
    setState(() {
      if (_rangeStart == null || (_rangeStart != null && _rangeEnd != null)) {
        _rangeStart = date;
        _rangeEnd = null;
      } else {
        if (date.isBefore(_rangeStart!)) {
          _rangeEnd = _rangeStart;
          _rangeStart = date;
        } else {
          _rangeEnd = date;
        }
      }
    });
  }

  void _addCurrentRange() {
    if (_rangeStart != null && _rangeEnd != null) {
      setState(() {
        unavailableDates
            .add(DateTimeRange(start: _rangeStart!, end: _rangeEnd!));
        _rangeStart = null;
        _rangeEnd = null;
      });
    }
  }

  void _removeRange(DateTimeRange range) {
    setState(() {
      unavailableDates.removeWhere(
        (r) => r.start == range.start && r.end == range.end,
      );
    });
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month - 1,
      );
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Product Availability',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Progress Indicator
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: 0.8,
                      backgroundColor: Color(0xFFE0E0E0),
                      color: Color(0xFF6366F1),
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),

            // Calendar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Month Navigation
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: _previousMonth,
                        ),
                        Text(
                          DateFormat('MMMM yyyy').format(_currentMonth),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ),

                  // Weekday headers
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        'MON',
                        'TUE',
                        'WED',
                        'THU',
                        'FRI',
                        'SAT',
                        'SUN'
                      ]
                          .map((day) => SizedBox(
                                width: 40,
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Calendar Grid
                  _buildCalendarGrid(),

                  const SizedBox(height: 16),
                ],
              ),
            ),

            // Unavailability Info
            Container(
              height: 170,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'The product will be unavailable for ${_calculateTotalDays()} days',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...unavailableDates.map((range) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _buildDateRange(range),
                        )),
                  ],
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _rangeStart != null && _rangeEnd != null
                          ? _addCurrentRange
                          : null,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Add date log'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: unavailableDates.isNotEmpty
                          ? () {
                              Get.find<ProductAvailabilityController>()
                                  .submitAvailability('1', unavailableDates);
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Obx(
                        () => Get.find<ProductAvailabilityController>()
                                .isUploading
                                .value
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Next'),
                                  SizedBox(width: 8),
                                  Icon(Icons.chevron_right, size: 20),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Saved'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: 'Post',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOffset =
        DateTime(_currentMonth.year, _currentMonth.month, 1).weekday - 1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 42,
      itemBuilder: (context, index) {
        if (index < firstDayOffset || index >= firstDayOffset + daysInMonth) {
          return const SizedBox();
        }

        final day = index - firstDayOffset + 1;
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final isSelected = _isDateInRange(date);
        final isUnavailable = _isDateUnavailable(date);
        final isInSelectionRange = _isDateInCurrentSelection(date);

        return GestureDetector(
          onTap: () {
            setState(() {
              _onDateSelected(date);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isUnavailable
                  ? Colors.red
                  : _rangeStart != null && _rangeStart == date ||
                          _rangeEnd != null && _rangeEnd == date
                      ? Colors.red.withOpacity(0.5)
                      : isSelected || isInSelectionRange
                          ? Colors.red.withOpacity(0.3)
                          : Colors.transparent,
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isUnavailable || isSelected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDateRange(DateTimeRange range) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${DateFormat('MMM d').format(range.start)} - ${DateFormat('MMM d, yyyy').format(range.end)}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.close,
            size: 20,
            color: Colors.grey,
          ),
          onPressed: () => _removeRange(range),
        ),
      ],
    );
  }

  bool _isDateUnavailable(DateTime date) {
    return unavailableDates.any((range) =>
        date.isAtSameMomentAs(range.start) ||
        date.isAtSameMomentAs(range.end) ||
        (date.isAfter(range.start) && date.isBefore(range.end)));
  }

  bool _isDateInRange(DateTime date) {
    return unavailableDates.any((range) =>
        date.isAtSameMomentAs(range.start) || date.isAtSameMomentAs(range.end));
  }

  bool _isDateInCurrentSelection(DateTime date) {
    if (_rangeStart == null || _rangeEnd == null) {
      return false;
    }
    return (date.isAtSameMomentAs(_rangeStart!) ||
        date.isAtSameMomentAs(_rangeEnd!) ||
        (date.isAfter(_rangeStart!) && date.isBefore(_rangeEnd!)));
  }

  int _calculateTotalDays() {
    return unavailableDates.fold(
        0, (sum, range) => sum + range.end.difference(range.start).inDays + 1);
  }
}
