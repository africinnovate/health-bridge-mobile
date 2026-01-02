import 'package:HealthBridge/core/utils/snackbar_utils.dart';
import 'package:HealthBridge/presentation/widgets/input_text_field_wg.dart';
import 'package:flutter/material.dart';

import '../../../widgets/cancel_button.dart';
import '../../../widgets/custom_button.dart';

class EditPersonalInformationScreen extends StatelessWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Edit Personal Information',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Full Name",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            InputTextFieldWG(hintText: "Sarah Okonkwo"),
            SizedBox(height: 10),
            Text("Address",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            InputTextFieldWG(hintText: "123 Hospital Road, Victoria Island"),
            Text("Supports any global address format."),
            SizedBox(height: 10),
            _dropdown('Country', 'Nigeria'),
            Row(
              children: [
                Expanded(child: _dropdown('State / Region', 'Lagos')),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text("City",
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      InputTextFieldWG(hintText: "Lagos"),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
            Text("Official Email Address",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            InputTextFieldWG(hintText: "info@citygeneral.com"),
            SizedBox(height: 10),
            Text("Emergency Hotline (Optional)",
                style: const TextStyle(fontWeight: FontWeight.w500)),
            InputTextFieldWG(hintText: "+234 800 555 1234"),
            SizedBox(height: 10),
            const Text(
              'Max file size: 5MB (PDF, JPG, PNG)',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 24),
            CustomButton(
              onPressed: () {
                SnackBarUtils.showInfo(context, "in progress");
              },
              text: "Save Changes",
            ),
            const SizedBox(height: 12),
            CancelButton(),
          ],
        ),
      ),
    );
  }
}

Widget _dropdown(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              items: [value]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (_) {},
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),
            ),
          ),
        ),
      ],
    ),
  );
}
