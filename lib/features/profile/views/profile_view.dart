import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/profile/controllers/profile_controller.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController c = Get.find<ProfileController>();
    final TextEditingController name = TextEditingController(text: c.name.value);
    final TextEditingController phone = TextEditingController(text: c.phone.value);

    return Scaffold(
      appBar: AppBar(title: const Text('Personal details')),
      body: ScreenScaffold(
        controller: c,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Update your details', style: AppTextStyles.titleMedium),
                const SizedBox(height: 18),
                CustomTextField(
                  label: 'Full name',
                  controller: name,
                  prefixIcon: Icons.person_outline_rounded,
                  onChanged: (v) => c.name.value = v,
                ),
                const SizedBox(height: 14),
                CustomTextField(
                  label: 'Phone number',
                  controller: phone,
                  prefixIcon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  onChanged: (v) => c.phone.value = v,
                ),
                const SizedBox(height: 22),
                Obx(
                  () => PrimaryButton(
                    label: 'Save changes',
                    isLoading: c.isLoading.value,
                    onPressed: c.saveProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
