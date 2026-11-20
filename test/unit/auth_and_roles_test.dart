import 'package:flutter_test/flutter_test.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/errors/app_exception.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/data/models/user_model.dart';
import 'package:nexbanak/data/providers/demo_data_source.dart';
import 'package:nexbanak/data/repositories/auth_repository.dart';

void main() {
  group('AppRole', () {
    test('maps wire values and defaults safely', () {
      expect(AppRole.fromString('ADMIN'), AppRole.admin);
      expect(AppRole.fromString('employee'), AppRole.employee);
      expect(AppRole.fromString('STAFF'), AppRole.employee);
      expect(AppRole.fromString('CUSTOMER'), AppRole.customer);
      expect(AppRole.fromString(null), AppRole.customer);
      expect(AppRole.fromString('unknown'), AppRole.customer);
    });

    test('exposes distinct home routes and UX permissions', () {
      expect(AppRole.customer.homeRoute, '/customer/home');
      expect(AppRole.employee.homeRoute, '/employee/home');
      expect(AppRole.admin.homeRoute, '/admin/home');

      expect(AppRole.customer.can('deposit.create'), isTrue);
      expect(AppRole.customer.can('audit.read'), isFalse);
      expect(AppRole.customer.can('approval.approve'), isFalse);

      expect(AppRole.employee.can('customer.read'), isTrue);
      expect(AppRole.employee.can('approval.approve'), isTrue);
      expect(AppRole.employee.can('settings.manage'), isFalse);

      expect(AppRole.admin.can('settings.manage'), isTrue);
      expect(AppRole.admin.can('audit.read'), isTrue);
      expect(AppRole.admin.isAdmin, isTrue);
      expect(AppRole.customer.isStaff, isFalse);
      expect(AppRole.admin.isStaff, isTrue);
    });
  });

  group('AuthService role checks', () {
    test('reflects the active user and guards role-restricted actions', () {
      final AuthService auth = AuthService();
      const UserModel customer = UserModel(
        id: 'usr_c_001',
        name: 'Alex Morgan',
        email: DemoDataSource.demoCustomerEmail,
        role: AppRole.customer,
      );
      const UserModel admin = UserModel(
        id: 'usr_a_001',
        name: 'Jordan Lee',
        email: DemoDataSource.demoAdminEmail,
        role: AppRole.admin,
      );

      auth.updateUser(customer);
      expect(auth.role, AppRole.customer);
      expect(auth.hasRole(AppRole.customer), isTrue);
      expect(auth.can('transfer.create'), isTrue);
      expect(auth.can('report.read'), isFalse);
      expect(() => auth.requireRole(AppRole.admin), throwsStateError);

      auth.updateUser(admin);
      expect(auth.hasRole(AppRole.admin), isTrue);
      expect(auth.can('report.read'), isTrue);
      expect(() => auth.requireRole(AppRole.admin), returnsNormally);
    });
  });

  group('DemoAuthRepository', () {
    test('signs in each demo role with its documented credentials', () async {
      final DemoAuthRepository repo = DemoAuthRepository(DemoDataSource());

      final customer = await repo.login(
        email: DemoDataSource.demoCustomerEmail,
        password: DemoDataSource.demoPassword,
      );
      final employee = await repo.login(
        email: DemoDataSource.demoEmployeeEmail,
        password: DemoDataSource.demoPassword,
      );
      final admin = await repo.login(
        email: DemoDataSource.demoAdminEmail,
        password: DemoDataSource.demoPassword,
      );

      expect(customer.user.role, AppRole.customer);
      expect(employee.user.role, AppRole.employee);
      expect(admin.user.role, AppRole.admin);
      expect(customer.accessToken, contains('customer'));
      expect(admin.refreshToken, contains('usr_a_001'));
    });

    test('rejects invalid credentials with a typed AppException', () async {
      final DemoAuthRepository repo = DemoAuthRepository(DemoDataSource());
      await expectLater(
        repo.login(
          email: DemoDataSource.demoCustomerEmail,
          password: 'wrong-password',
        ),
        throwsA(
          isA<AppException>().having(
            (AppException e) => e.code,
            'code',
            'INVALID_CREDENTIALS',
          ),
        ),
      );
    });

    test('OTP reset flow uses the labelled demo code', () async {
      final DemoAuthRepository repo = DemoAuthRepository(DemoDataSource());
      await repo.requestOtp(DemoDataSource.demoCustomerEmail);
      final String token = await repo.verifyOtp(
        email: DemoDataSource.demoCustomerEmail,
        code: '123456',
      );
      expect(token, isNotEmpty);
      await repo.resetPassword(token: token, newPassword: 'NewDemo@123');
      await expectLater(
        repo.changePassword(
          userId: 'usr_c_001',
          oldPassword: DemoDataSource.demoPassword,
          newPassword: 'Another@123',
        ),
        throwsA(isA<AppException>()),
      );
    });
  });
}
