import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/routes/app_routes.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/features/authentication/controllers/auth_controller.dart';
import 'package:nexbanak/features/authentication/views/auth_scaffold.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.find<AuthController>();
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    final TextEditingController name = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController phone = TextEditingController();
    final TextEditingController password = TextEditingController();

    return AuthScaffold(
      title: 'Create your account',
      subtitle: 'Join the next generation of banking',
      footer: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Already have an account? '),
          TextButton(
            onPressed: () => Get.offAllNamed(Routes.login),
            child: const Text('Sign in'),
          ),
        ],
      ),
      child: Form(
        key: key,
        child: Column(
          children: <Widget>[
            CustomTextField(
              label: 'Full name',
              prefixIcon: Icons.person_outline_rounded,
              controller: name,
              validator: (v) => Validators.required(v, 'Full name'),
              onChanged: (v) => c.name.value = v,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Email address',
              prefixIcon: Icons.email_outlined,
              controller: email,
              keyboardType: TextInputType.emailAddress,
              validator: c.validateEmail,
              onChanged: (v) => c.email.value = v,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Phone number',
              prefixIcon: Icons.phone_outlined,
              controller: phone,
              keyboardType: TextInputType.phone,
              onChanged: (v) => c.phone.value = v,
            ),
            const SizedBox(height: 14),
            CustomTextField(
              label: 'Password',
              prefixIcon: Icons.lock_outline_rounded,
              controller: password,
              obscureText: true,
              validator: c.validatePassword,
              onChanged: (v) => c.password.value = v,
            ),
            const SizedBox(height: 20),
            Obx(
              () => PrimaryButton(
                label: 'Create account',
                isLoading: c.isLoading.value,
                onPressed: () {
                  if (!key.currentState!.validate()) return;
                  c.register();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
