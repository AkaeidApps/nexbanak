import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/features/customer/controllers/money_controller.dart';
import 'package:nexbanak/features/customer/views/transfer_view.dart';

/// Opens [TransferView] pre-selected on the requested money-movement mode.
class MoneyModeView extends StatelessWidget {
  const MoneyModeView(this.mode, {super.key});

  final String mode;

  @override
  Widget build(BuildContext context) {
    final MoneyController controller = Get.find<MoneyController>();
    if (controller.mode.value != mode) controller.mode.value = mode;
    return const TransferView();
  }
}

class DepositView extends StatelessWidget {
  const DepositView({super.key});

  @override
  Widget build(BuildContext context) => const MoneyModeView('deposit');
}

class WithdrawalView extends StatelessWidget {
  const WithdrawalView({super.key});

  @override
  Widget build(BuildContext context) => const MoneyModeView('withdraw');
}

class BeneficiariesView extends StatelessWidget {
  const BeneficiariesView({super.key});

  @override
  Widget build(BuildContext context) => const TransferView();
}
