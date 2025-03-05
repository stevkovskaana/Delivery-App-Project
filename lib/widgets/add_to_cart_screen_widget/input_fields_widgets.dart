import 'package:flutter/material.dart';

class AddToCartInputFieldsWidget extends StatelessWidget {
  final int quantity;
  final ValueChanged<int> onQuantityChanged;
  final String specialRequest;
  final ValueChanged<String> onSpecialRequestChanged;

  const AddToCartInputFieldsWidget({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    required this.specialRequest,
    required this.onSpecialRequestChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Quantity:'),
            const SizedBox(width: 10),
            Expanded(
              child: Slider(
                value: quantity.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: '$quantity',
                activeColor: const Color(0xBA443015),
                inactiveColor: Colors.grey,
                onChanged: (value) {
                  onQuantityChanged(value.toInt());
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Special Request',
            border: OutlineInputBorder(),
          ),
          onChanged: onSpecialRequestChanged,
          controller: TextEditingController(text: specialRequest),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
