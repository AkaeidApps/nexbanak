import 'package:nexbanak/app/constants/api_endpoints.dart';
import 'package:nexbanak/core/network/api_client.dart';
import 'package:nexbanak/data/models/admin_models.dart';
import 'package:nexbanak/data/models/dashboard_models.dart';
import 'package:nexbanak/data/models/notification_model.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/repository_helpers.dart';

abstract class AdminRepository {
  Future<AdminStats> adminStats();
  Future<List<PersonRecord>> customers({String? search, String? status});
  Future<List<PersonRecord>> employees({String? search, String? status});
  Future<List<BranchRecord>> branches({String? search});
  Future<List<ApprovalItem>> approvals({String? type, String? status});
  Future<void> approve(String id, String checkerId);
  Future<void> reject(String id, String checkerId, String reason);
  Future<List<KycRecord>> kycRecords({String? status});
  Future<void> reviewKyc(String id, String status, String reviewerId);
  Future<List<AuditEvent>> auditLogs({String? search});
  Future<List<Map<String, dynamic>>> report(String type);
  Future<Map<String, dynamic>> settings();
  Future<void> saveSettings(Map<String, dynamic> values);
  Future<List<NotificationModel>> notifications();
}

class RemoteAdminRepository implements AdminRepository {
  RemoteAdminRepository(this._api);

  final ApiClient _api;

  @override
  Future<AdminStats> adminStats() async => AdminStats.fromJson(
        extractMap(await _api.get('${ApiEndpoints.reports}/overview'), 'stats'),
      );

  @override
  Future<List<PersonRecord>> customers({String? search, String? status}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.customers,
      query: <String, dynamic>{
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
      },
    );
    return extractList(body, 'customers').map(PersonRecord.fromJson).toList();
  }

  @override
  Future<List<PersonRecord>> employees({String? search, String? status}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.employees,
      query: <String, dynamic>{
        if (search != null && search.isNotEmpty) 'search': search,
        if (status != null && status != 'all') 'status': status,
      },
    );
    return extractList(body, 'employees').map(PersonRecord.fromJson).toList();
  }

  @override
  Future<List<BranchRecord>> branches({String? search}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.branches,
      query: <String, dynamic>{'search': ?search},
    );
    return extractList(body, 'branches').map(BranchRecord.fromJson).toList();
  }

  @override
  Future<List<ApprovalItem>> approvals({String? type, String? status}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.approvals,
      query: <String, dynamic>{
        if (type != null && type != 'all') 'type': type,
        if (status != null && status != 'all') 'status': status,
      },
    );
    return extractList(body, 'approvals').map(ApprovalItem.fromJson).toList();
  }

  @override
  Future<void> approve(String id, String checkerId) =>
      _api.post('${ApiEndpoints.approvals}/$id/approve');

  @override
  Future<void> reject(String id, String checkerId, String reason) => _api.post(
        '${ApiEndpoints.approvals}/$id/reject',
        data: <String, dynamic>{'reason': reason},
      );

  @override
  Future<List<KycRecord>> kycRecords({String? status}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.kyc,
      query: <String, dynamic>{if (status != null && status != 'all') 'status': status},
    );
    return extractList(body, 'records').map(KycRecord.fromJson).toList();
  }

  @override
  Future<void> reviewKyc(String id, String status, String reviewerId) =>
      _api.patch('${ApiEndpoints.kyc}/$id', data: <String, dynamic>{'status': status});

  @override
  Future<List<AuditEvent>> auditLogs({String? search}) async {
    final Map<String, dynamic> body = await _api.get(
      ApiEndpoints.auditLogs,
      query: <String, dynamic>{'search': ?search},
    );
    return extractList(body, 'events').map(AuditEvent.fromJson).toList();
  }

  @override
  Future<List<Map<String, dynamic>>> report(String type) async {
    final Map<String, dynamic> body =
        await _api.get('${ApiEndpoints.reports}/$type');
    return extractList(body, 'rows');
  }

  @override
  Future<Map<String, dynamic>> settings() async =>
      extractMap(await _api.get(ApiEndpoints.settings), 'settings');

  @override
  Future<void> saveSettings(Map<String, dynamic> values) =>
      _api.patch(ApiEndpoints.settings, data: values);

  @override
  Future<List<NotificationModel>> notifications() async {
    final Map<String, dynamic> body = await _api.get(ApiEndpoints.notifications);
    return extractList(body, 'notifications').map(NotificationModel.fromJson).toList();
  }
}

class DemoAdminRepository implements AdminRepository {
  DemoAdminRepository(this._demo);

  final DemoDataSource _demo;

  @override
  Future<AdminStats> adminStats() => _demo.adminStats();
  @override
  Future<List<PersonRecord>> customers({String? search, String? status}) =>
      _demo.customers(search: search, status: status);
  @override
  Future<List<PersonRecord>> employees({String? search, String? status}) =>
      _demo.employees(search: search, status: status);
  @override
  Future<List<BranchRecord>> branches({String? search}) =>
      _demo.branches(search: search);
  @override
  Future<List<ApprovalItem>> approvals({String? type, String? status}) =>
      _demo.approvals(type: type, status: status);
  @override
  Future<void> approve(String id, String checkerId) =>
      _demo.approve(id, checkerId);
  @override
  Future<void> reject(String id, String checkerId, String reason) =>
      _demo.reject(id, checkerId, reason);
  @override
  Future<List<KycRecord>> kycRecords({String? status}) =>
      _demo.kycRecords(status: status);
  @override
  Future<void> reviewKyc(String id, String status, String reviewerId) =>
      _demo.reviewKyc(id, status, reviewerId);
  @override
  Future<List<AuditEvent>> auditLogs({String? search}) =>
      _demo.auditLogs(search: search);
  @override
  Future<List<Map<String, dynamic>>> report(String type) => _demo.report(type);
  @override
  Future<Map<String, dynamic>> settings() async => _demo.settings();
  @override
  Future<void> saveSettings(Map<String, dynamic> values) =>
      _demo.saveSettings(values);
  @override
  Future<List<NotificationModel>> notifications() => _demo.notifications();
}
