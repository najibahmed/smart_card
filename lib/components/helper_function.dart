import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';

String createVCard(String fullName, String phoneNumber, String email, String address) {
  return 'BEGIN:VCARD\n'
      'VERSION:3.0\n'
      'FN:$fullName\n'
      'TEL:$phoneNumber\n'
      'EMAIL:$email\n'
      // 'ADR;TYPE=home:;;$street;$city;$state;$postalCode;$country\n
      'END:VCARD';
}
void showNfcSettingsDialog(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('NFC Not Enabled'),
        content: Text(
            'NFC is not enabled on this device. Do you want to enable it now?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppSettings.openAppSettings(type: AppSettingsType.nfc);
            },
            child: Text('Open Settings'),
          ),
        ],
      );
    },
  );
}