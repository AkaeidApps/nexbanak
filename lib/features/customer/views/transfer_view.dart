import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/constants/app_strings.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/core/utils/validators.dart';
import 'package:nexbanak/features/customer/controllers/money_controller.dart';
import 'package:nexbanak/shared/widgets/animated_card.dart';
import 'package:nexbanak/shared/widgets/brand_icons.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/dialogs.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final MoneyController c = Get.find<MoneyController>();
    final TextEditingController amount = TextEditingController();
    final TextEditingController note = TextEditingController();
    final TextEditingController accountNumber = TextEditingController();
    final TextEditingController otp = TextEditingController();

    return ScreenScaffold(
      controller: c,
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Money movement', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('Deposits, withdrawals and internal transfers',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 20),
            SegmentedButton<String>(
              segments: const <ButtonSegment<String>>[
                ButtonSegment(value: 'transfer', label: Text('Transfer'), icon: Icon(Icons.swap_horiz_rounded)),
                ButtonSegment(value: 'deposit', label: Text('Deposit'), icon: Icon(Icons.south_west_rounded)),
                ButtonSegment(value: 'withdraw', label: Text('Withdraw'), icon: Icon(Icons.north_east_rounded)),
              ],
              selected: <String>{c.mode.value},
              onSelectionChanged: (Set<String> value) => c.mode.value = value.first,
            ),
            const SizedBox(height: 20),
            AnimatedCard(
              borderRadius: 20,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    DropdownButtonFormField<String>(
                      initialValue: c.selectedAccountId.value.isEmpty
                          ? null
                          : c.selectedAccountId.value,
                      decoration: const InputDecoration(labelText: 'From account'),
                      items: c.accounts
                          .map(
                            (a) => DropdownMenuItem<String>(
                              value: a.id,
                              child: Text(
                                '${a.name} • ${Formatters.maskAccount(a.accountNumber)}',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (String? value) {
                        if (value != null) c.selectedAccountId.value = value;
                      },
                    ),
                    if (c.selectedAccount != null) ...<Widget>[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.lightBlue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Available balance: ${c.balanceHidden.value ? '••••' : Formatters.money(c.selectedAccount!.balance)}',
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    if (c.mode.value == 'transfer') ...<Widget>[
                      DropdownButtonFormField<String>(
                        initialValue: c.destinationAccount.value.isEmpty
                            ? null
                            : c.destinationAccount.value,
                        decoration: const InputDecoration(labelText: 'Beneficiary'),
                        items: c.beneficiaries
                            .map(
                              (b) => DropdownMenuItem<String>(
                                value: b.accountNumber,
                                child: Text('${b.name} — ${Formatters.maskAccount(b.accountNumber)}'),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          if (value == null) return;
                          c.destinationAccount.value = value;
                          c.selectedBeneficiary.value = c.beneficiaries.firstWhere(
                            (b) => b.accountNumber == value,
                          );
                        },
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Or enter account number',
                        hint: 'Recipient account number',
                        controller: accountNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(20),
                        ],
                        onChanged: (v) => c.destinationAccount.value = v,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'OTP',
                        hint: AppConstants.useMock ? 'Demo: 123456' : '6-digit code',
                        controller: otp,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onChanged: (v) => c.otp.value = v,
                      ),
                      const SizedBox(height: 16),
                    ],
                    AmountInputField(
                      controller: amount,
                      onChanged: (v) => c.amount.value = v,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'Note (optional)',
                      controller: note,
                      onChanged: (v) => c.note.value = v,
                    ),
                    const SizedBox(height: 22),
                    Obx(
                      () => PrimaryButton(
                        label: c.mode.value == 'transfer'
                            ? 'Review & confirm transfer'
                            : c.mode.value == 'deposit'
                                ? 'Submit deposit request'
                                : 'Submit withdrawal request',
                        isLoading: c.isLoading.value,
                        onPressed: () => _submit(c, amount, note, accountNumber, otp),
                      ),
                    ),
                    if (AppConstants.useMock)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(AppStrings.demoHint,
                            style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SectionHeader(title: 'Beneficiaries', actionLabel: 'Add new', onAction: () => _addBeneficiary(c)),
            const SizedBox(height: 10),
            if (c.beneficiaries.isEmpty)
              const EmptyStateWidget(title: 'No beneficiaries yet')
            else
              ...c.beneficiaries.map(
                (b) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AnimatedCard(
                    borderRadius: 14,
                    child: ListTile(
                      leading: BrandIcons.bankLogo(b.bank, size: 38),
                      title: Text(b.name, style: AppTextStyles.bodyLarge),
                      subtitle: Text(
                        '${b.bank} • ${Formatters.maskAccount(b.accountNumber)}',
                        style: AppTextStyles.bodySmall,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error),
                        onPressed: () => _removeBeneficiary(c, b.id),
                      ),
                      onTap: () {
                        c.useBeneficiary(b);
                        accountNumber.text = b.accountNumber;
                      },
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Future<void> _submit(
    MoneyController c,
    TextEditingController amount,
    TextEditingController note,
    TextEditingController account,
    TextEditingController otp,
  ) async {
    final String? error = Validators.amount(amount.text);
    if (error != null) return c.showError(error);
    c.amount.value = amount.text;
    c.note.value = note.text;

    if (c.mode.value == 'transfer') {
      if (c.destinationAccount.value.isEmpty) {
        return c.showError('Select or enter a recipient account.');
      }
      if (Validators.otp(otp.text) != null) {
        return c.showError('Enter the 6-digit OTP.');
      }
      c.destinationAccount.value = account.text.isNotEmpty
          ? account.text
          : c.destinationAccount.value;
      c.otp.value = otp.text;
      final bool? confirmed = await Get.dialog<bool>(
        ConfirmationDialog(
          title: 'Confirm transfer',
          message: 'Send ${Formatters.money(c.amount.value)} to account ${c.destinationAccount.value}?',
          confirmLabel: 'Confirm transfer',
        ),
      );
      if (confirmed != true) return;
      await c.transfer();
    } else if (c.mode.value == 'deposit') {
      await c.deposit();
    } else {
      await c.withdrawal();
    }
    amount.clear();
    note.clear();
    otp.clear();
  }

  Future<void> _addBeneficiary(MoneyController c) async {
    final TextEditingController name = TextEditingController();
    final TextEditingController number = TextEditingController();
    final TextEditingController bank = TextEditingController(text: 'NEXBANK');
    final TextEditingController nickname = TextEditingController();
    final bool? ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Add beneficiary'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Full name'), onChanged: (v) => c.beneficiaryName.value = v),
            const SizedBox(height: 10),
            TextField(controller: number, decoration: const InputDecoration(labelText: 'Account number'), keyboardType: TextInputType.number, onChanged: (v) => c.beneficiaryNumber.value = v),
            const SizedBox(height: 10),
            TextField(controller: bank, decoration: const InputDecoration(labelText: 'Bank'), onChanged: (v) => c.beneficiaryBank.value = v),
            const SizedBox(height: 10),
            TextField(controller: nickname, decoration: const InputDecoration(labelText: 'Nickname'), onChanged: (v) => c.beneficiaryNickname.value = v),
          ],
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(onPressed: () => Get.back(result: true), child: const Text('Add')),
        ],
      ),
    );
    if (ok == true) {
      final String? numberError = Validators.accountNumber(c.beneficiaryNumber.value);
      if (numberError != null) return c.showError(numberError);
      final String? nameError = Validators.required(c.beneficiaryName.value, 'Name');
      if (nameError != null) return c.showError(nameError);
      await c.addBeneficiary();
    }
  }

  Future<void> _removeBeneficiary(MoneyController c, String id) async {
    final bool? ok = await Get.dialog<bool>(
      const ConfirmationDialog(
        title: 'Remove beneficiary?',
        message: 'You can add this beneficiary again later.',
        confirmLabel: 'Remove',
        danger: true,
      ),
    );
    if (ok == true) await c.removeBeneficiary(id);
  }
}
