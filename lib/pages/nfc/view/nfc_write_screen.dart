import 'package:card/components/buildContactInfo.dart';
import 'package:card/components/helper_function.dart';
import 'package:card/components/ripple.dart';
import 'package:card/model/card_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../nfc_controller/nfc_controller.dart';

class NfcWriteScreen extends StatelessWidget {
  final NfcController nfcController = Get.put(NfcController());
  final TextEditingController _textController = TextEditingController();
  NfcWriteScreen({super.key, required this.user});
  final CardModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Write NFC Data'),backgroundColor: Colors.teal,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ripples(onPressed: () {}, child: Text('Writing',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
            Card(
              elevation: 5,
              shadowColor: Colors.blue,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 22),
                child: Column(
                  children: [
                    buildContactInfo(context, Icons.person, user.name, 'Name'),
                    buildContactInfo(context, Icons.email, user.email, 'Email'),
                    buildContactInfo(context, Icons.phone, user.phone, 'Mobile'),
                    buildContactInfo(context, Icons.web, user.websiteUrl, 'Website'),
                    buildContactInfo(context, Icons.location_on, user.address, 'Address'),
                    buildContactInfo(context, Icons.business_center, user.linkedInProfile, 'LinkedIn'),
                    buildContactInfo(context, Icons.alternate_email, user.twitterHandle, 'Twitter'),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                var data =CardModel(
                    name: user.name,
                    job: user.job,
                    email: user.email,
                    identifier: user.identifier,
                    phone: user.phone,
                    company: user.company,
                    websiteUrl: user.websiteUrl,
                    address: user.address,
                    linkedInProfile: user.linkedInProfile,
                    twitterHandle: user.twitterHandle,
                    profileImageUrl: user.profileImageUrl
                );
                if (nfcController.isNfcEnabled.value) {
                  nfcController.writeNfcContact(user.name, user.phone, user.email,user.address);
                } else {
                  showNfcSettingsDialog(context);
                }
                },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent.shade400
              ),
              child: Text('Tap to Write NFC'),
            ),
            SizedBox(height: 10,),
            Text(
                'NFC is ${nfcController.isNfcEnabled.value ? 'enabled' : 'disabled'}',style: TextStyle(
                fontSize: 16,
                letterSpacing: 1
            ),)
          ],
        ),
      ),
    );
  }
}
