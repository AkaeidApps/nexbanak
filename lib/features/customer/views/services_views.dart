import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/utils/formatters.dart';
import 'package:nexbanak/data/models/banking_models.dart';
import 'package:nexbanak/features/customer/controllers/services_controller.dart';
import 'package:nexbanak/shared/widgets/animated_card.dart';
import 'package:nexbanak/shared/widgets/brand_icons.dart';
import 'package:nexbanak/shared/widgets/buttons.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/input_fields.dart';
import 'package:nexbanak/shared/widgets/screen_scaffold.dart';

/// Loans application and servicing.
class LoansView extends StatelessWidget {
  const LoansView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    final TextEditingController amount = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Loans')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Your loans', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Apply for financing and manage repayments',
                  style: AppTextStyles.bodyMedium),
              const SizedBox(height: 18),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Apply for a loan', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        initialValue: c.loanType.value,
                        decoration: const InputDecoration(labelText: 'Loan type'),
                        items: const <DropdownMenuItem<String>>[
                          DropdownMenuItem(value: 'Personal loan', child: Text('Personal loan')),
                          DropdownMenuItem(value: 'Home loan', child: Text('Home loan')),
                          DropdownMenuItem(value: 'Auto loan', child: Text('Auto loan')),
                          DropdownMenuItem(value: 'Business loan', child: Text('Business loan')),
                        ],
                        onChanged: (String? value) {
                          if (value != null) c.loanType.value = value;
                        },
                      ),
                      const SizedBox(height: 14),
                      AmountInputField(
                        controller: amount,
                        onChanged: (v) => c.loanAmount.value = v,
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<int>(
                        initialValue: c.loanTerm.value,
                        decoration: const InputDecoration(labelText: 'Term (months)'),
                        items: const <DropdownMenuItem<int>>[
                          DropdownMenuItem(value: 6, child: Text('6 months')),
                          DropdownMenuItem(value: 12, child: Text('12 months')),
                          DropdownMenuItem(value: 24, child: Text('24 months')),
                          DropdownMenuItem(value: 36, child: Text('36 months')),
                          DropdownMenuItem(value: 60, child: Text('60 months')),
                        ],
                        onChanged: (int? value) {
                          if (value != null) c.loanTerm.value = value;
                        },
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => PrimaryButton(
                          label: 'Submit application',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.applyLoan();
                            amount.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              SectionHeader(title: 'Existing facilities'),
              const SizedBox(height: 10),
              if (c.loans.isEmpty)
                const EmptyStateWidget(title: 'No loans on your profile')
              else
                ...c.loans.map(
                  (loan) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _LoanCard(loan: loan, controller: c),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({required this.loan, required this.controller});

  final LoanModel loan;
  final ServicesController controller;

  @override
  Widget build(BuildContext context) => AnimatedCard(
        borderRadius: 16,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(child: Text(loan.type, style: AppTextStyles.titleMedium)),
                  StatusChip(status: loan.status),
                ],
              ),
              const SizedBox(height: 12),
              _detail('Principal', Formatters.money(loan.amount)),
              _detail('Outstanding', Formatters.money(loan.outstanding)),
              _detail('Interest rate', '${loan.interestRate}%'),
              _detail('Term', '${loan.termMonths} months'),
              if (loan.nextDueDate.isNotEmpty)
                _detail('Next payment', Formatters.date(loan.nextDueDate)),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: OutlinedButton.icon(
                  onPressed: loan.status.toLowerCase() == 'completed'
                      ? null
                      : () => _repay(controller, loan),
                  icon: const Icon(Icons.payments_rounded, size: 18),
                  label: const Text('Make repayment'),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _detail(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: <Widget>[
            SizedBox(width: 130, child: Text(label, style: AppTextStyles.bodySmall)),
            Expanded(child: Text(value, style: AppTextStyles.bodyMedium)),
          ],
        ),
      );

  Future<void> _repay(ServicesController c, LoanModel loan) async {
    final TextEditingController amount = TextEditingController(text: loan.outstanding);
    final bool? confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Repay loan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('Outstanding: ${Formatters.money(loan.outstanding)}', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            AmountInputField(controller: amount),
          ],
        ),
        actions: <Widget>[
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              c.repayAmount.value = amount.text;
              Get.back(result: true);
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    if (confirmed == true) await c.repayLoan(loan.id);
  }
}

/// Debit and credit card overview.
class CardsView extends StatelessWidget {
  const CardsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Cards')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Cards', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Control your debit and credit cards', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 18),
              if (c.cards.isEmpty)
                const EmptyStateWidget(title: 'No cards linked to your profile')
              else
                ...c.cards.map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _CardTile(card: card, controller: c),
                  ),
                ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  const _CardTile({required this.card, required this.controller});

  final CardModel card;
  final ServicesController controller;

  @override
  Widget build(BuildContext context) => AnimatedCard(
        borderRadius: 20,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  BrandIcons.visa(size: 26),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${card.type.toUpperCase()} •• ${card.last4}',
                      style: AppTextStyles.titleMedium,
                    ),
                  ),
                  StatusChip(status: card.status),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: <Color>[Color(0xFF0B1F3A), Color(0xFF1D4ED8)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('•••• •••• •••• ${card.last4}',
                        style: AppTextStyles.headlineSmall.copyWith(color: Colors.white)),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(card.holder.toUpperCase(),
                              style: AppTextStyles.labelSmall.copyWith(color: Colors.white70)),
                        ),
                        Text('EXPIRES ${card.expiry}',
                            style: AppTextStyles.labelSmall.copyWith(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: <Widget>[
                  Text('Limit: ${Formatters.money(card.limit)}', style: AppTextStyles.bodySmall),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => controller.setCardStatus(
                      card.id,
                      card.isBlocked ? 'active' : 'blocked',
                    ),
                    child: Text(card.isBlocked ? 'Unblock card' : 'Block card'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}

/// Savings goals and fixed deposits.
class SavingsView extends StatelessWidget {
  const SavingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    final TextEditingController goalName = TextEditingController();
    final TextEditingController goalTarget = TextEditingController();
    final TextEditingController goalDeadline = TextEditingController();
    final TextEditingController fdAmount = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Savings & deposits')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Savings goals', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 18),
              if (c.goals.isEmpty)
                const EmptyStateWidget(title: 'No savings goals yet')
              else
                ...c.goals.map(
                  (goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedCard(
                      borderRadius: 16,
                      child: Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(child: Text(goal.name, style: AppTextStyles.titleMedium)),
                                Text('${(goal.progress * 100).round()}%', style: AppTextStyles.labelLarge),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: goal.progress,
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            const SizedBox(height: 10),
                            Text('${Formatters.money(goal.saved)} of ${Formatters.money(goal.target)}',
                                style: AppTextStyles.bodySmall),
                            if (goal.deadline.isNotEmpty)
                              Text('Target date: ${Formatters.date(goal.deadline)}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Create a savings goal', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Goal name',
                        controller: goalName,
                        prefixIcon: Icons.flag_outlined,
                        onChanged: (v) => c.goalName.value = v,
                      ),
                      const SizedBox(height: 12),
                      AmountInputField(
                        label: 'Target amount',
                        controller: goalTarget,
                        onChanged: (v) => c.goalTarget.value = v,
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        label: 'Target date (YYYY-MM-DD)',
                        controller: goalDeadline,
                        prefixIcon: Icons.event_outlined,
                        onChanged: (v) => c.goalDeadline.value = v,
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => PrimaryButton(
                          label: 'Create goal',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.addGoal();
                            goalName.clear();
                            goalTarget.clear();
                            goalDeadline.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SectionHeader(title: 'Fixed deposits'),
              const SizedBox(height: 10),
              if (c.fixedDeposits.isEmpty)
                const EmptyStateWidget(title: 'No fixed deposits')
              else
                ...c.fixedDeposits.map(
                  (fd) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AnimatedCard(
                      borderRadius: 14,
                      child: ListTile(
                        leading: const Icon(Icons.savings_rounded),
                        title: Text(Formatters.money(fd.amount), style: AppTextStyles.titleMedium),
                        subtitle: Text('${fd.termMonths} months • ${fd.rate}% p.a.'),
                        trailing: StatusChip(status: fd.status),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 18),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Open a fixed deposit', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 14),
                      AmountInputField(
                        label: 'Deposit amount',
                        controller: fdAmount,
                        onChanged: (v) => c.fdAmount.value = v,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        initialValue: c.fdTerm.value,
                        decoration: const InputDecoration(labelText: 'Term'),
                        items: const <DropdownMenuItem<int>>[
                          DropdownMenuItem(value: 6, child: Text('6 months')),
                          DropdownMenuItem(value: 12, child: Text('12 months')),
                          DropdownMenuItem(value: 24, child: Text('24 months')),
                        ],
                        onChanged: (int? value) {
                          if (value != null) c.fdTerm.value = value;
                        },
                      ),
                      const SizedBox(height: 18),
                      Obx(
                        () => PrimaryButton(
                          label: 'Open deposit',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.openFixedDeposit();
                            fdAmount.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// Utility Bill Pay View with real biller logos.
class BillPayView extends StatelessWidget {
  const BillPayView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    final TextEditingController customerCode = TextEditingController();
    final TextEditingController amount = TextEditingController();
    final TextEditingController note = TextEditingController();

    final List<Map<String, String>> billers = <Map<String, String>>[
      <String, String>{'name': 'DESCO Electricity', 'type': 'electricity'},
      <String, String>{'name': 'DPDC Electricity', 'type': 'electricity'},
      <String, String>{'name': 'WASA Water', 'type': 'water'},
      <String, String>{'name': 'Titas Gas', 'type': 'gas'},
      <String, String>{'name': 'Carnival Broadband', 'type': 'internet'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Pay Utility Bills')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Utility Bill Payment', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Pay electricity, water, gas & internet bills instantly', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Select Provider', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: billers.map((b) {
                          final bool selected = c.billerName.value == b['name'];
                          return ChoiceChip(
                            avatar: BrandIcons.utilityLogo(b['type']!, size: 24),
                            label: Text(b['name']!),
                            selected: selected,
                            onSelected: (val) {
                              if (val) c.billerName.value = b['name']!;
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      CustomTextField(
                        label: 'Account / Customer Code',
                        hint: 'e.g. 10293847',
                        controller: customerCode,
                        keyboardType: TextInputType.number,
                        onChanged: (v) => c.customerCode.value = v,
                      ),
                      const SizedBox(height: 14),
                      AmountInputField(
                        controller: amount,
                        onChanged: (v) => c.billAmount.value = v,
                      ),
                      const SizedBox(height: 14),
                      CustomTextField(
                        label: 'Note (Optional)',
                        controller: note,
                        onChanged: (v) => c.billNote.value = v,
                      ),
                      const SizedBox(height: 22),
                      Obx(
                        () => PrimaryButton(
                          label: 'Pay Bill Now',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.payBill();
                            customerCode.clear();
                            amount.clear();
                            note.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mobile Top-up View with real operator logos.
class MobileTopupView extends StatelessWidget {
  const MobileTopupView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    final TextEditingController mobile = TextEditingController();
    final TextEditingController amount = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Top-up')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Mobile Recharge', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Instant airtime top-up for any mobile operator', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Select Operator', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _operatorOption('Grameenphone', BrandIcons.grameenphone(size: 34), c),
                          _operatorOption('Robi', BrandIcons.robi(size: 34), c),
                          _operatorOption('Banglalink', BrandIcons.banglalink(size: 34), c),
                          _operatorOption('Teletalk', BrandIcons.teletalk(size: 34), c),
                          _operatorOption('Airtel', BrandIcons.airtel(size: 34), c),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Mobile Number',
                        hint: '01700000000',
                        controller: mobile,
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => c.mobileNumber.value = v,
                      ),
                      const SizedBox(height: 14),
                      AmountInputField(
                        controller: amount,
                        onChanged: (v) => c.topupAmount.value = v,
                      ),
                      const SizedBox(height: 22),
                      Obx(
                        () => PrimaryButton(
                          label: 'Recharge Now',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.topupMobile();
                            mobile.clear();
                            amount.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _operatorOption(String name, Widget logo, ServicesController c) {
    final bool isSelected = c.operatorName.value == name;
    return GestureDetector(
      onTap: () => c.operatorName.value = name,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF1D4ED8) : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: logo,
          ),
          const SizedBox(height: 6),
          Text(name, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}

/// MFS Cash-Out / Transfer View (bKash, Nagad, Rocket, Upay).
class MfsTransferView extends StatelessWidget {
  const MfsTransferView({super.key});

  @override
  Widget build(BuildContext context) {
    final ServicesController c = Get.find<ServicesController>();
    final TextEditingController mobile = TextEditingController();
    final TextEditingController amount = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('MFS Transfer')),
      body: ScreenScaffold(
        controller: c,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Mobile Financial Services', style: AppTextStyles.headlineMedium),
              const SizedBox(height: 4),
              Text('Instant money transfer to bKash, Nagad, Rocket & Upay', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 20),
              AnimatedCard(
                borderRadius: 20,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text('Select Wallet', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          _mfsOption('bKash', BrandIcons.bkash(size: 38), c),
                          _mfsOption('Nagad', BrandIcons.nagad(size: 38), c),
                          _mfsOption('Rocket', BrandIcons.rocket(size: 38), c),
                          _mfsOption('Upay', BrandIcons.upay(size: 38), c),
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        label: 'Recipient Mobile Number',
                        hint: '01700000000',
                        controller: mobile,
                        keyboardType: TextInputType.phone,
                        onChanged: (v) => c.mfsMobile.value = v,
                      ),
                      const SizedBox(height: 14),
                      AmountInputField(
                        controller: amount,
                        onChanged: (v) => c.mfsAmount.value = v,
                      ),
                      const SizedBox(height: 22),
                      Obx(
                        () => PrimaryButton(
                          label: 'Send Money to Wallet',
                          isLoading: c.isLoading.value,
                          onPressed: () async {
                            await c.transferMfs();
                            mobile.clear();
                            amount.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _mfsOption(String name, Widget logo, ServicesController c) {
    final bool isSelected = c.mfsProvider.value == name;
    return GestureDetector(
      onTap: () => c.mfsProvider.value = name,
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF1D4ED8) : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: logo,
          ),
          const SizedBox(height: 6),
          Text(name, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
