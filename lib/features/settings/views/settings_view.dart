import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/settings/controllers/system_controller.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final SystemController c = Get.find<SystemController>();
    final TextEditingController timeout = TextEditingController(text: c.sessionTimeout.value);
    final TextEditingController limit = TextEditingController(text: c.dailyTransferLimit.value);

    return Scaffold(
      appBar: AppBar(title: const Text('System settings')),
      body: ScreenScaffold(
        controller: c,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Security & limits', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Text('Changes apply across the institution and are audit logged.',
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 18),
                CustomTextField(
                  label: 'Session timeout (minutes)',
                  controller: timeout,
                  keyboardType: TextInputType.number,
                  onChanged: (v) => c.sessionTimeout.value = v,
                ),
                const SizedBox(height: 14),
                AmountInputField(
                  label: 'Daily transfer limit',
                  controller: limit,
                  onChanged: (v) => c.dailyTransferLimit.value = v,
                ),
                const SizedBox(height: 22),
                Obx(
                  () => PrimaryButton(
                    label: 'Save settings',
                    isLoading: c.isLoading.value,
                    onPressed: c.saveSettings,
                  ),
                ),
                const SizedBox(height: 20),
                Text('Institution: ${c.settings['institution'] ?? 'NEXBANK'}',
                    style: AppTextStyles.bodySmall),
                Text('Base currency: ${c.settings['baseCurrency'] ?? 'USD'}',
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
