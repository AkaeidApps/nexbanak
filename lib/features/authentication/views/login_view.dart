import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/authentication/views/auth_scaffold.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.find<AuthController>();
    final TextEditingController emailController =
        TextEditingController(text: c.email.value);
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return AuthScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to your NEXBANK account',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('New to NEXBANK? ', style: AppTextStyles.bodyMedium),
          TextButton(
            onPressed: () => Get.toNamed(Routes.register),
            child: const Text('Create an account'),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CustomTextField(
              label: 'Email address',
              hint: 'you@example.com',
              prefixIcon: Icons.email_outlined,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              validator: c.validateEmail,
              onChanged: (String value) => c.email.value = value,
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                label: 'Password',
                hint: 'Enter your password',
                prefixIcon: Icons.lock_outline_rounded,
                controller: passwordController,
                obscureText: c.obscurePassword.value,
                validator: c.validatePassword,
                onChanged: (String value) => c.password.value = value,
                suffixIcon: IconButton(
                  icon: Icon(c.obscurePassword.value
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded),
                  onPressed: () =>
                      c.obscurePassword.value = !c.obscurePassword.value,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Obx(
                  () => Checkbox(
                    value: c.rememberMe.value,
                    onChanged: (bool? value) =>
                        c.rememberMe.value = value ?? false,
                  ),
                ),
                Text('Remember me', style: AppTextStyles.bodySmall),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(Routes.forgotPassword),
                  child: const Text('Forgot password?'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Obx(
              () => PrimaryButton(
                label: 'Sign in',
                isLoading: c.isLoading.value,
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;
                  c.login();
                },
              ),
            ),
            Obx(
              () => c.biometricAvailable.value
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SecondaryButton(
                        label: 'Sign in with biometrics',
                        icon: Icons.fingerprint_rounded,
                        expand: true,
                        onPressed: c.biometricLogin,
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),
            Row(
              children: <Widget>[
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('OR', style: AppTextStyles.labelSmall),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            Text('Demo sign-in', style: AppTextStyles.labelSmall,
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: AppRole.values
                  .map(
                    (role) => ActionChip(
                      avatar: const Icon(Icons.login_rounded, size: 15),
                      label: Text(role.label),
                      onPressed: () => c.demoLogin(role),
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
