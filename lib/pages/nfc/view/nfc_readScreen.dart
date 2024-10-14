import 'package:card/components/ripple.dart';
import 'package:card/pages/nfc/nfc_controller/nfc_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NfcReadScreen extends StatelessWidget {
  final NfcController nfcController = Get.put(NfcController());
  NfcReadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Read NFC Data')),
      body: Center(
        child: Obx(() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ripples(onPressed: () {}, child: Text('Scanning',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
            Text('NFC Data: ${nfcController.nfcData.value}',
                style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: nfcController.readNfcData,
              child: Text('Tap to Read NFC'),
            ),
          ],
        )),
      ),
    );
  }
}
