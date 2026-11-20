class CustomerStats {
  const CustomerStats({
    required this.totalBalance,
    required this.savings,
    required this.income,
    required this.expenses,
    required this.monthlyIncome,
    required this.monthlyExpense,
    required this.transactionCount,
  });

  final String totalBalance;
  final String savings;
  final String income;
  final String expenses;
  final List<double> monthlyIncome;
  final List<double> monthlyExpense;
  final int transactionCount;

  factory CustomerStats.fromJson(Map<String, dynamic> json) => CustomerStats(
        totalBalance: (json['totalBalance'] ?? '0').toString(),
        savings: (json['savings'] ?? '0').toString(),
        income: (json['income'] ?? '0').toString(),
        expenses: (json['expenses'] ?? '0').toString(),
        monthlyIncome: _series(json['monthlyIncome']),
        monthlyExpense: _series(json['monthlyExpense']),
        transactionCount:
            int.tryParse(json['transactionCount']?.toString() ?? '') ?? 0,
      );

  static List<double> _series(Object? value) {
    if (value is List) {
      return value.map((e) => double.tryParse(e.toString()) ?? 0).toList();
    }
    return const <double>[];
  }
}

class AdminStats {
  const AdminStats({
    required this.totalCustomers,
    required this.totalAccounts,
    required this.totalDeposits,
    required this.totalWithdrawals,
    required this.totalTransactions,
    required this.totalLoans,
    required this.activeEmployees,
    required this.totalBranches,
    required this.pendingApprovals,
    required this.suspiciousTransactions,
    required this.depositSeries,
    required this.withdrawalSeries,
    required this.customerGrowth,
  });

  final int totalCustomers;
  final int totalAccounts;
  final String totalDeposits;
  final String totalWithdrawals;
  final int totalTransactions;
  final int totalLoans;
  final int activeEmployees;
  final int totalBranches;
  final int pendingApprovals;
  final int suspiciousTransactions;
  final List<double> depositSeries;
  final List<double> withdrawalSeries;
  final List<double> customerGrowth;

  static int _int(Object? v) =>
      int.tryParse(v?.toString() ?? '') ?? (v is num ? v.toInt() : 0);

  factory AdminStats.fromJson(Map<String, dynamic> json) => AdminStats(
        totalCustomers: _int(json['totalCustomers']),
        totalAccounts: _int(json['totalAccounts']),
        totalDeposits: (json['totalDeposits'] ?? '0').toString(),
        totalWithdrawals: (json['totalWithdrawals'] ?? '0').toString(),
        totalTransactions: _int(json['totalTransactions']),
        totalLoans: _int(json['totalLoans']),
        activeEmployees: _int(json['activeEmployees']),
        totalBranches: _int(json['totalBranches']),
        pendingApprovals: _int(json['pendingApprovals']),
        suspiciousTransactions: _int(json['suspiciousTransactions']),
        depositSeries: CustomerStats._series(json['depositSeries']),
        withdrawalSeries: CustomerStats._series(json['withdrawalSeries']),
        customerGrowth: CustomerStats._series(json['customerGrowth']),
      );
}
