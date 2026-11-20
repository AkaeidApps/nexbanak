import 'package:flutter/material.dart';
import 'package:nexbanak/features/admin/views/records_list_view.dart';

class AdminCustomersView extends StatelessWidget {
  const AdminCustomersView({super.key});

  @override
  Widget build(BuildContext context) => const RecordsListView(
        tag: 'customers',
        title: 'Customer management',
        emptyHint: 'No customers match your filters',
      );
}
