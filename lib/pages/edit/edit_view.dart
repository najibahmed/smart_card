import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../model/card_model.dart';
import 'edit_controller.dart';

class EditCardView extends StatelessWidget {
  final AddOrEditController controller = Get.put(AddOrEditController());
  final CardModel user;
  final bool isEdit;

  EditCardView({super.key, required this.user, this.isEdit = false}) {
    controller.isEdit = isEdit;
    controller.initialize(user);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.isNew.value = false;
        Get.back();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEdit ? 'Edit Card' : 'Add Card'),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: (){
                    if (_validateFields()) {
                      controller.saveChanges();
                    }
                  },
                  icon: Row(
                    children: [
                      Icon(Icons.save),
                      Text("Save",style: TextStyle(color: Colors.white),)
                    ],
                  )),
            )
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0,vertical: 16),
          child: ListView(
            children: [
              Obx(()=> Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      child: SizedBox(
                        height: 110,
                        width: 110,
                        child: InkWell(
                          onTap: () {
                            controller.pickImage(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(.30),
                            ),
                            child: controller.profilePic.value != null
                                ?
                            Image.file(
                              controller.profilePic.value!,
                              fit: BoxFit.cover,
                            ): const Icon(
                              Icons.add_a_photo,
                              color: Colors.blue,
                              size: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(context, controller.nameController, 'Full Name'),
              _buildTextField(context, controller.jobController, 'Job Title'),
              _buildTextField(context, controller.companyController, 'Company'),
              _buildTextField(context, controller.emailController, 'Email'),
              _buildTextField(context, controller.phoneController, 'Phone Number'),
              _buildTextField(context, controller.websiteUrlController, 'Website'),
              _buildTextField(context, controller.addressController, 'Address'),
              _buildTextField(context, controller.linkedInProfileController, 'LinkedIn Profile'),
              _buildTextField(context, controller.twitterHandleController, 'Twitter Handle'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_validateFields()) {
                    controller.saveChanges();
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(BuildContext context, Rx<TextEditingController> controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller.value,
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }

  bool _validateFields() {
    final fields = [
      controller.nameController.value.text,
      controller.jobController.value.text,
      controller.companyController.value.text,
      controller.emailController.value.text,
      controller.phoneController.value.text,
      controller.websiteUrlController.value.text,
      controller.addressController.value.text,
      controller.linkedInProfileController.value.text,
      controller.twitterHandleController.value.text,
    ];

    if (fields.any((field) => field.isEmpty)) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    return true;
  }
}
