import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_card.dart';
import 'customer_cart_store.dart';

class DateSelectionScreen extends StatefulWidget {
  const DateSelectionScreen({super.key});

  @override
  State<DateSelectionScreen> createState() => _DateSelectionScreenState();
}

class _DateSelectionScreenState extends State<DateSelectionScreen> {
  DateTime? _selectedDate;
  String? _selectedSlot;

  static const List<String> _slots = [
    '8:00 AM - 10:00 AM',
    '10:00 AM - 12:00 PM',
    '12:00 PM - 2:00 PM',
    '2:00 PM - 4:00 PM',
    '4:00 PM - 6:00 PM',
  ];

  Future<void> _selectDate() async {
    final tomorrow = DateUtils.dateOnly(
      DateTime.now().add(const Duration(days: 1)),
    );

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? tomorrow,
      firstDate: tomorrow,
      lastDate: tomorrow.add(const Duration(days: 30)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _continue() {
    if (_selectedDate == null || _selectedSlot == null) {
      return;
    }

    CustomerCartStore.instance.setPickup(
      date: _selectedDate!,
      slot: _selectedSlot!,
    );

    Navigator.of(context).pushNamed(AppRoutes.orderConfirmation);
  }

  @override
  Widget build(BuildContext context) {
    final store = CustomerCartStore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Pickup')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Choose your pickup date and time',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your order will be prepared based on the demand for this date.',
                ),
                const SizedBox(height: 28),
                AppCard(
                  onTap: _selectDate,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primaryMaroon,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Select Date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                DropdownButtonFormField<String>(
                  initialValue: _selectedSlot,
                  decoration: const InputDecoration(
                    labelText: 'Pickup Time',
                    prefixIcon: Icon(Icons.access_time_outlined),
                  ),
                  items: _slots
                      .map(
                        (slot) =>
                            DropdownMenuItem(value: slot, child: Text(slot)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedSlot = value;
                    });
                  },
                ),
                const SizedBox(height: 28),
                AppCard(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${store.itemCount} item(s)'),
                      Text(
                        '₹${store.total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: AppColors.primaryMaroon,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                AppButton(
                  label: 'Continue',
                  onPressed: _selectedDate != null && _selectedSlot != null
                      ? _continue
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
