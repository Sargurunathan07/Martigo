import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/pre_order_cutoff.dart';
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
    final today = PreOrderCutoff.indiaToday();

    final earliest = PreOrderCutoff.earliestAvailableDate();

    final lastDate = today.add(const Duration(days: 30));

    final currentSelection = _selectedDate;

    final initialDate =
        currentSelection != null &&
            PreOrderCutoff.isDateAvailable(currentSelection)
        ? currentSelection
        : earliest;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: lastDate,
      currentDate: today,

      // Keeps the existing Martigo date picker.
      // Today is disabled.
      // Tomorrow is disabled after 6:30 PM IST.
      selectableDayPredicate: (date) {
        return PreOrderCutoff.isDateAvailable(date);
      },
    );

    if (picked == null || !mounted) {
      return;
    }

    // Re-check after the picker closes.
    //
    // This handles the edge case where the customer
    // opened the picker before 6:30 PM but left it
    // open until after the cutoff.
    if (!PreOrderCutoff.isDateAvailable(picked)) {
      final earliestNow = PreOrderCutoff.earliestAvailableDate();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'That date is no longer available. '
            'Please select '
            '${PreOrderCutoff.formatLongDate(earliestNow)} '
            'or a later date.',
          ),
        ),
      );

      return;
    }

    setState(() {
      _selectedDate = picked;
    });
  }

  Future<void> _continue() async {
    if (_selectedDate == null || _selectedSlot == null) {
      return;
    }

    // Validate again before opening confirmation.
    if (!PreOrderCutoff.isDateAvailable(_selectedDate!)) {
      final earliest = PreOrderCutoff.earliestAvailableDate();

      setState(() {
        _selectedDate = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pre-order cutoff has ended. '
            'Please select '
            '${PreOrderCutoff.formatLongDate(earliest)} '
            'or a later date.',
          ),
        ),
      );

      return;
    }

    CustomerCartStore.instance.setPickup(
      date: _selectedDate!,
      slot: _selectedSlot!,
    );

    final result = await Navigator.of(context)
        .pushNamed(AppRoutes.orderConfirmation);

    if (!mounted) {
      return;
    }

    // If confirmation became invalid because the
    // 6:30 PM cutoff passed, force a fresh date choice.
    if (result == 'cutoffExpired') {
      setState(() {
        _selectedDate = null;
      });
    }
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
                  'Your order will be prepared based on the demand for this date.\n'
                  'Tomorrow pre-orders close daily at 6:30 PM IST.',
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
                              : '${_selectedDate!.day}/'
                                    '${_selectedDate!.month}/'
                                    '${_selectedDate!.year}',
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
