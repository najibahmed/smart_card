import 'package:app_settings/app_settings.dart';
import 'package:card/components/helper_function.dart';
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
      appBar: AppBar(title: Text('Read NFC Data'),backgroundColor: Colors.teal,),
      body: Center(
        child: Obx(() => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                nfcController.nfcData.isEmpty
                    ? Ripples(
                        onPressed: () {},
                        child: Text(
                          'Scanning',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text("Successful"),
                Text('NFC Data: ${nfcController.nfcData.value}',
                    style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (nfcController.isNfcEnabled.value) {
                      nfcController.readNfcData;
                    } else {
                      showNfcSettingsDialog(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent.shade400
                  ),
                  child: Text('Tap to Read NFC'),
                ),
                SizedBox(height: 10,),
                Text(
                    'NFC is ${nfcController.isNfcEnabled.value ? 'enabled' : 'disabled'}',style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 1
                ),)
              ],
            )),
      ),
    );
  }


}
