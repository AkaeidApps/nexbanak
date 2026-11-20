import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/authentication/views/auth_scaffold.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.find<AuthController>();
    final TextEditingController email = TextEditingController(text: c.email.value);

    return AuthScaffold(
      title: 'Reset your password',
      subtitle: 'We will send a verification code to your email',
      child: Column(
        children: <Widget>[
          CustomTextField(
            label: 'Email address',
            prefixIcon: Icons.email_outlined,
            controller: email,
            keyboardType: TextInputType.emailAddress,
            validator: c.validateEmail,
            onChanged: (v) => c.email.value = v,
          ),
          const SizedBox(height: 20),
          Obx(
            () => PrimaryButton(
              label: 'Send verification code',
              isLoading: c.isLoading.value,
              onPressed: c.forgotPassword,
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Get.back<void>(),
            child: const Text('Back to sign in'),
          ),
        ],
      ),
    );
  }
}

class OtpView extends StatelessWidget {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.find<AuthController>();
    final TextEditingController code = TextEditingController();

    return AuthScaffold(
      title: 'Verify your identity',
      subtitle: 'Enter the 6-digit code sent to ${c.email.value}',
      child: Column(
        children: <Widget>[
          if (AppConstants.useMock)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text('Demo code: ${AppConstants.otpDemoCode}',
                  style: AppTextStyles.labelSmall),
            ),
          CustomTextField(
            label: 'Verification code',
            hint: '000000',
            prefixIcon: Icons.pin_outlined,
            controller: code,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            onChanged: (v) => c.otp.value = v,
          ),
          const SizedBox(height: 20),
          Obx(
            () => PrimaryButton(
              label: 'Verify code',
              isLoading: c.isLoading.value,
              onPressed: c.verifyOtp,
            ),
          ),
        ],
      ),
    );
  }
}

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.find<AuthController>();
    final TextEditingController password = TextEditingController();

    return AuthScaffold(
      title: 'Choose a new password',
      subtitle: 'Use at least 8 characters with an uppercase letter and a number',
      child: Column(
        children: <Widget>[
          CustomTextField(
            label: 'New password',
            prefixIcon: Icons.lock_outline_rounded,
            controller: password,
            obscureText: true,
            validator: c.validatePassword,
            onChanged: (v) => c.newPassword.value = v,
          ),
          const SizedBox(height: 20),
          Obx(
            () => PrimaryButton(
              label: 'Reset password',
              isLoading: c.isLoading.value,
              onPressed: c.resetPassword,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Get.offAllNamed(Routes.login),
            child: const Text('Back to sign in'),
          ),
        ],
      ),
    );
  }
}
