import 'package:card/components/helper_function.dart';
import 'package:card/pages/nfc/view/nfc_readScreen.dart';
import 'package:card/pages/nfc/view/nfc_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../model/card_model.dart';
import '../edit/edit_view.dart';
import 'home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController userController = Get.put(HomeController());

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('InstaCard'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          Obx(() => !userController.isLoading.value && userController.cardInfo.value != null
              ? IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.to(
                EditCardView(
                  user: userController.cardInfo.value!,
                  isEdit: true,
                ),
                arguments: true,
              );
            },
          )
              : Container()),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (userController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final user = userController.cardInfo.value;

        if (user == null || user.name.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  "You don't have a card yet!",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.to(
                      EditCardView(
                        user: CardModel(
                          name: '',
                          job: '',
                          email: '',
                          identifier: '',
                          phone: '',
                          company: '',
                          websiteUrl: '',
                          address: '',
                          linkedInProfile: '',
                          twitterHandle: '',
                          profileImageUrl: userController.defaultAvatar,
                        ),
                        isEdit: false,
                      ),
                      arguments: false,
                    );
                  },
                  child: const Text('Create Your Card'),
                ),
              ],
            ),
          );
        } else {
          final userMap = user.toMap();
          String contactShare='${user.name}, ${user.phone}, ${user.email}, ${user.address}, ${user.linkedInProfile},';
          String vCardData = createVCard(user.name, user.phone, user.email,user.address);
          final userData = userMap.entries.map((e) => '${e.key}:${e.value}').join('|');
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: user.profileImageUrl.isNotEmpty
                      ? NetworkImage(user.profileImageUrl,scale: 1)
                      : NetworkImage(userController.defaultAvatar,scale: 1)
                ),
                const SizedBox(height: 15),
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 5),
                Text(
                  user.job,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 15),
                QrImageView(
                  data: vCardData,
                  version: QrVersions.auto,
                  size: 150.0,
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                    ElevatedButton(
                        onPressed: (){
                          Get.to(NfcReadScreen());
                        },
                        child: Row(
                         mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.nfc_outlined),
                            SizedBox(width: 8,),
                            Text("Read From NFC"),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: (){
                          Get.to(NfcWriteScreen(user: user,));
                        },
                        child: Row(
                          children: [
                            Text("Write To NFC"),
                            SizedBox(width: 8,),
                            Icon(Icons.nfc_outlined),
                          ],
                        )),
                  ],),
                ),
                Divider(
                  color: Colors.grey[300],
                  thickness: 1,
                ),

               Card(
                 elevation: 5,
                 shadowColor: Colors.blue,
                 color: Colors.blue[50],
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal: 22),
                   child: Column(
                     children: [
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           Text("Information's",style: TextStyle(fontSize: 22),),
                           SizedBox(width: 5,),
                           IconButton(
                               onPressed: (){
                                Share.share(contactShare,subject: 'Contact Information');
                               },
                               icon: Icon(Icons.share_rounded)),
                         ],
                       ),
                       _buildContactInfo(context, Icons.email, user.email, 'Email'),
                       _buildContactInfo(context, Icons.phone, user.phone, 'Mobile'),
                       _buildContactInfo(context, Icons.web, user.websiteUrl, 'Website'),
                       _buildContactInfo(context, Icons.location_on, user.address, 'Address'),
                       _buildContactInfo(context, Icons.business_center, user.linkedInProfile, 'LinkedIn'),
                       _buildContactInfo(context, Icons.alternate_email, user.twitterHandle, 'Twitter'),
                     ],
                   ),
                 ),
               ),
                SizedBox(height: 20,),
                Center(
                  child: ElevatedButton(
                      onPressed: (){
                        Get.to(
                          EditCardView(
                            user: userController.cardInfo.value!,
                            isEdit: true,
                          ),
                          arguments: true,
                        );
                      },
                      child: Text("Update User Data")),
                ),
                SizedBox(height: 20,),
              ],
            ),
          );
        }
      }),
    );
  }

  Widget _buildContactInfo(BuildContext context, IconData icon, String text, String label) {
    final displayText = text.isNotEmpty ? text : 'Not Provided';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayText, style: Theme.of(context).textTheme.bodyLarge),
                Text(label, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _performLogout();
                Get.back(); // Close the dialog
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    userController.logoutUser();
  }
}

