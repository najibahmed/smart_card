import 'dart:io';

import 'package:card/components/helper_function.dart';
import 'package:card/pages/home/ocr_view.dart';
import 'package:card/pages/nfc/view/nfc_readScreen.dart';
import 'package:card/pages/nfc/view/nfc_write_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/background.jpg',
              ),
              fit: BoxFit.cover)),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.white,
              Colors.white70,
              Colors.black54,
            ])),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              'InstaCard',
              style: TextStyle(color: Colors.teal, fontSize: 24),
            ),
            // centerTitle: true,
            automaticallyImplyLeading: false,
            actions: [
              Obx(() => !userController.isLoading.value &&
                      userController.cardInfo.value != null
                  ? IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.teal,
                      ),
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
                icon: const Icon(
                  Icons.logout,
                  color: Colors.teal,
                ),
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
              String contactShare =
                  '${user.name}, ${user.phone}, ${user.email}, ${user.address}, ${user.linkedInProfile},';
              String vCardData =
                  createVCard(user.name, user.phone, user.email, user.address);
              final userData =
                  userMap.entries.map((e) => '${e.key}:${e.value}').join('|');
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22.0, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        radius: 45,
                        backgroundImage: user.profileImageUrl.isNotEmpty
                            ? NetworkImage(user.profileImageUrl, scale: 1)
                            : NetworkImage(userController.defaultAvatar,
                                scale: 1)),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.job,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                          fontSize: 18,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    QrImageView(
                      data: vCardData,
                      version: QrVersions.auto,
                      size: 150.0,
                    ),
                    const SizedBox(height: 5),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.055,
                            width: screenWidth * 0.45,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.to(NfcReadScreen());
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              icon: Icon(
                                Icons.nfc_outlined,
                                size: 16,
                              ),
                              label: Text("Read From NFC"),
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.055,
                            width: screenWidth * 0.4,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Get.to(NfcWriteScreen(
                                  user: user,
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal),
                              icon: Icon(
                                Icons.nfc_outlined,
                                size: 16,
                              ),
                              label: Text("Write To NFC"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[300],
                      thickness: 1,
                    ),
                    Card(
                      color: Colors.blue[50],
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: InkWell(
                        onTap: () {
                          Get.to(OcrPage());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    bottomLeft: Radius.circular(15)),
                                child: SizedBox(
                                    height: 80,
                                    width: 100,
                                    child: Image.asset(
                                      'assets/business-cards.png',
                                      color: Colors.teal,
                                      fit: BoxFit.contain,
                                    )),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Scan Visiting Card",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      // SizedBox(height: 10),
                                      Wrap(
                                        children: [
                                          Text(
                                            "Here you can Scan others visiting card and copy the text extracted from it.",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      shadowColor: Colors.blue,
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 22),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Information's",
                                  style: TextStyle(fontSize: 22),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                IconButton(
                                    onPressed: () async {
                                      // Share.share(contactShare,subject: 'Contact Information');
                                      // Save vCard to a file
                                      File vCardFile = await saveVCardToFile(
                                          vCardData, user);

                                      // Share the vCard file
                                      await shareVCard(vCardFile);
                                    },
                                    icon: Icon(Icons.share_rounded)),
                              ],
                            ),
                            _buildContactInfo(
                                context, Icons.email, user.email, 'Email'),
                            _buildContactInfo(
                                context, Icons.phone, user.phone, 'Mobile'),
                            _buildContactInfo(
                                context, Icons.web, user.websiteUrl, 'Website'),
                            _buildContactInfo(context, Icons.location_on,
                                user.address, 'Address'),
                            _buildContactInfo(context, Icons.business_center,
                                user.linkedInProfile, 'LinkedIn'),
                            _buildContactInfo(context, Icons.alternate_email,
                                user.twitterHandle, 'Twitter'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(
                              EditCardView(
                                user: userController.cardInfo.value!,
                                isEdit: true,
                              ),
                              arguments: true,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orangeAccent.shade400),
                          child: Text("Update User Data")),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildContactInfo(
      BuildContext context, IconData icon, String text, String label) {
    final displayText = text.isNotEmpty ? text : 'Not Provided';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal),
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.teal),
              ),
            ),
            TextButton(
              onPressed: () {
                _performLogout();
                Get.back(); // Close the dialog
              },
              child: const Text('Logout', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

// Save vCard as a file
  Future<File> saveVCardToFile(String vCardData, CardModel user) async {
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/${user.name}.vcf';
    final file = File(filePath);
    return file.writeAsString(vCardData);
  }

  // Share the vCard file
  Future<void> shareVCard(File vCardFile) async {
    await Share.shareXFiles([XFile(vCardFile.path)],
        text: 'Contact information.');
  }

  void _performLogout() {
    userController.logoutUser();
  }
}
