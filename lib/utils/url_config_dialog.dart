import 'package:flutter/material.dart';
import 'constants.dart';

void showServerUrlDialog(BuildContext context) {
  final controller = TextEditingController(text: ApiConstants.serverUrl);
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Server Address'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'API Base URL',
          hintText: 'http://10.0.2.2:8000',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            await ApiConstants.setServerUrl(controller.text.trim());
            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Server URL updated')),
              );
            }
          },
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
