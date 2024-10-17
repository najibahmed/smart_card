import 'package:card/pages/edit/edit_controller.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../model/card_model.dart';
import '../login/login_view.dart';

class HomeController extends GetxController {
  Rx<CardModel?> cardInfo = Rx<CardModel?>(null);
  RxBool textAnimationFinished = false.obs;
  String defaultAvatar = 'https://avatarfiles.alphacoders.com/375/thumb-1920-375473.jpeg';
  RxBool isLoading = false.obs;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref().child('cards');

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
    listenToDataChanges();
  }

  Future<void> fetchUserData() async {
    final email = Hive.box('userBox').get('email') as String?;
    if (email == null) {
      isLoading.value = false;
      return;
    }

    try {
      final snapshot = await _dbRef.orderByChild('identifier').equalTo(email).once();
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map?;
        if (data != null && data.isNotEmpty) {
          final userData = data.values.first as Map?;
          if (userData != null) {
            cardInfo.value = CardModel.fromMap(Map<String, dynamic>.from(userData));
          } else {
            cardInfo.value = null;
          }
        } else {
          cardInfo.value = null;
        }
      } else {
        cardInfo.value = null;
      }
    } catch (e) {
      print("Failed to fetch user data: $e");
      cardInfo.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void listenToDataChanges() {
    final email = Hive.box('userBox').get('email') as String?;
    if (email == null) return;

    _dbRef.orderByChild('identifier').equalTo(email).onValue.listen((event) {
      if (event.snapshot.exists) {
        final data = event.snapshot.value as Map?;
        if (data != null && data.isNotEmpty) {
          final userData = data.values.first as Map?;
          if (userData != null) {
            cardInfo.value = CardModel.fromMap(Map<String, dynamic>.from(userData));
          } else {
            cardInfo.value = null;
          }
        } else {
          cardInfo.value = null;
        }
      } else {
        cardInfo.value = null;
      }
    }, onError: (error) {
      print("Failed to listen to data changes: $error");
      cardInfo.value = null;
    });
  }

  void logoutUser() {
    // Clear Hive box data
    final box = Hive.box('userBox');
    box.clear();
    Get.delete<HomeController>();
    Get.delete<AddOrEditController>();
    Get.offAll(() => LoginView());
  }
}
