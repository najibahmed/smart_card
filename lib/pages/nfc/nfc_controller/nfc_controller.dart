import 'dart:convert';
import 'dart:typed_data';

import 'package:card/components/helper_function.dart';

import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcController extends GetxController {
  var nfcData = ''.obs;
  late RxBool isNfcEnabled=false.obs;
  @override
  void onInit() {
    _checkNfcStatus();
    super.onInit();
  }

  // Method to write NFC data (vCard format)
  Future<void> writeNfcContact(String fullName, String phoneNumber, String email,String address) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      String vCardData = createVCard(fullName, phoneNumber, email,address);
      Uint8List contactBytes= utf8.encode(vCardData);
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null && ndef.isWritable) {
          NdefMessage message = NdefMessage([
            NdefRecord.createMime('text/vcard',contactBytes),
          ]);
          await ndef.write(message);
          NfcManager.instance.stopSession();
          Get.snackbar('Success', 'Contact information written successfully');
        } else {
          NfcManager.instance.stopSession();
          Get.snackbar('Error', 'NFC tag is not writable');
        }
      });
    } else {
      Get.snackbar('Error', 'NFC is not available');
    }
  }
  //check nfc status
  Future<void> _checkNfcStatus() async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (isAvailable) {
        isNfcEnabled.value = true;
      } else {
        isNfcEnabled.value = false;
      }
    } catch (e) {
      print('Error checking NFC status: $e');
      isNfcEnabled.value = false;
    }
  }

  // Method to read NFC data
  Future<void> readNfcData() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (isAvailable) {
      NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
        Ndef? ndef = Ndef.from(tag);
        if (ndef != null) {
          var message = ndef.cachedMessage;
          if (message != null) {
            String result = message.records.map((r) => String.fromCharCodes(r.payload)).join();
            nfcData.value = result;
          }
        }
        NfcManager.instance.stopSession();
      });
    } else {
      Get.snackbar('Error', 'NFC is not available');
    }
  }
}
