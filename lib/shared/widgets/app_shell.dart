import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexbanak/app/constants/app_constants.dart';
import 'package:nexbanak/app/theme/app_colors.dart';
import 'package:nexbanak/app/theme/app_text_styles.dart';
import 'package:nexbanak/core/domain/app_role.dart';
import 'package:nexbanak/core/services/auth_service.dart';
import 'package:nexbanak/core/utils/responsive.dart';
import 'package:nexbanak/shared/widgets/feedback_widgets.dart';
import 'package:nexbanak/shared/widgets/nex_bank_logo.dart';

class NavItem {
  const NavItem({
    required this.label,
    required this.icon,
    required this.page,
    this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget page;
}

class ShellController extends GetxController {
  ShellController(this.items);
  final List<NavItem> items;
  final RxInt index = 0.obs;

  void changeTab(int value) => index.value = value;
  NavItem get current => items[index.value.clamp(0, items.length - 1)];
}

class NexBankAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NexBankAppBar({
    super.key,
    required this.title,
    this.showLogo = true,
    this.onNotificationTap,
    this.unreadCount = 0,
    this.actions,
  });

  final Widget title;
  final bool showLogo;
  final VoidCallback? onNotificationTap;
  final int unreadCount;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    return AppBar(
      title: Row(
        children: <Widget>[
          if (showLogo && context.isDesktop) ...<Widget>[
            const NexBankLogo(compact: true, size: 32),
            const SizedBox(width: 14),
          ],
          Expanded(child: title),
        ],
      ),
      actions: <Widget>[
        if (AppConstants.useMock) const Padding(
          padding: EdgeInsets.only(right: 8),
          child: DemoBanner(dense: true),
        ),
        if (onNotificationTap != null)
          IconButton(
            tooltip: 'Notifications',
            onPressed: onNotificationTap,
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: Icon(Icons.notifications_none_rounded,
                  color: AppColors.mutedText(dark)),
            ),
          ),
        IconButton(
          tooltip: 'Toggle theme',
          onPressed: () {
            final ThemeMode current = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
            Get.changeThemeMode(current == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
          },
          icon: Icon(Get.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        ),
        ...?actions,
      ],
    );
  }
}

class NexBankDrawer extends StatelessWidget {
  const NexBankDrawer({
    super.key,
    required this.controller,
    required this.role,
    required this.onSignOut,
    this.extraItems = const <NavItem>[],
  });

  final ShellController controller;
  final AppRole role;
  final VoidCallback onSignOut;
  final List<NavItem> extraItems;

  @override
  Widget build(BuildContext context) {
    final AuthService auth = Get.find<AuthService>();
    final List<NavItem> all = <NavItem>[...controller.items, ...extraItems];
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 14),
              child: NexBankLogo(showTagline: true, size: 38),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Text('${role.label} workspace', style: AppTextStyles.labelSmall),
            ),
            Expanded(
              child: Obx(() {
                // Read the Rx inside the tracked scope: ListView.builder invokes
                // itemBuilder later, outside GetX's reactive tracking window.
                final int selected = controller.index.value;
                return ListView.builder(
                  itemCount: all.length,
                  itemBuilder: (context, i) {
                    final NavItem item = all[i];
                    return ListTile(
                      selected: i == selected && i < controller.items.length,
                      selectedTileColor: AppColors.lightBlue,
                      leading: Icon(item.icon, size: 20),
                      title: Text(item.label, style: AppTextStyles.bodyMedium),
                      onTap: () {
                        if (i < controller.items.length) {
                          controller.changeTab(i);
                          Get.back<void>();
                        } else {
                          Get.back<void>();
                          Get.to<dynamic>(() => item.page);
                        }
                      },
                    );
                  },
                );
              }),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryNavy,
                child: Text(
                  (auth.user?.name.isNotEmpty ?? false) ? auth.user!.name[0] : 'N',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              ),
              title: Text(auth.user?.name ?? 'NEXBANK user',
                  style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis),
              subtitle: Text(auth.user?.email ?? ''),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: AppColors.error),
              title: const Text('Sign out'),
              onTap: onSignOut,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class NexBankBottomNavigation extends StatelessWidget {
  const NexBankBottomNavigation({super.key, required this.controller});

  final ShellController controller;

  @override
  Widget build(BuildContext context) => Obx(
        () => NavigationBar(
          selectedIndex: controller.index.value.clamp(0, controller.items.length - 1),
          onDestinationSelected: controller.changeTab,
          destinations: controller.items
              .map(
                (item) => NavigationDestination(
                  icon: Icon(item.icon),
                  selectedIcon: Icon(item.selectedIcon ?? item.icon),
                  label: item.label,
                ),
              )
              .toList(),
        ),
      );
}

/// The single responsive shell used by all three roles.
class NexShell extends StatelessWidget {
  const NexShell({
    super.key,
    required this.tag,
    required this.role,
    required this.items,
    required this.onSignOut,
    this.extraDrawerItems = const <NavItem>[],
    this.unreadCount = 0,
    this.onNotificationTap,
  });

  final String tag;
  final AppRole role;
  final List<NavItem> items;
  final VoidCallback onSignOut;
  final List<NavItem> extraDrawerItems;
  final int unreadCount;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final ShellController controller =
        Get.put<ShellController>(ShellController(items), tag: tag);

    return Scaffold(
      appBar: NexBankAppBar(
        title: Obx(() => Text(
              controller.current.label,
              style: AppTextStyles.headlineSmall,
              overflow: TextOverflow.ellipsis,
            )),
        onNotificationTap: onNotificationTap,
        unreadCount: unreadCount,
      ),
      drawer: context.isDesktop
          ? null
          : NexBankDrawer(
              controller: controller,
              role: role,
              onSignOut: onSignOut,
              extraItems: extraDrawerItems,
            ),
      bottomNavigationBar:
          context.isMobile ? NexBankBottomNavigation(controller: controller) : null,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
            child: Row(
              children: <Widget>[
                if (context.isDesktop)
                  SizedBox(
                    width: 248,
                    child: Material(
                      color: Theme.of(context).cardColor,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
                            child: NexBankLogo(showTagline: true, size: 36),
                          ),
                          const Divider(),
                          Expanded(
                            child: Obx(() {
                              final int selected = controller.index.value;
                              return ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  final NavItem item = items[i];
                                  return ListTile(
                                    selected: i == selected,
                                    selectedTileColor: AppColors.lightBlue,
                                    leading: Icon(item.icon, size: 20),
                                    title: Text(item.label, style: AppTextStyles.bodyMedium),
                                    onTap: () => controller.changeTab(i),
                                  );
                                },
                              );
                            }),
                          ),
                          if (extraDrawerItems.isNotEmpty)
                            ExpansionTile(
                              leading: const Icon(Icons.more_horiz_rounded),
                              title: Text('More', style: AppTextStyles.bodyMedium),
                              children: extraDrawerItems
                                  .map(
                                    (item) => ListTile(
                                      leading: Icon(item.icon, size: 18),
                                      title: Text(item.label, style: AppTextStyles.bodySmall),
                                      onTap: () => Get.to<dynamic>(() => item.page),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ListTile(
                            leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                            title: Text('Sign out', style: AppTextStyles.bodyMedium),
                            onTap: onSignOut,
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                if (context.isDesktop) const VerticalDivider(width: 1),
                Expanded(
                  child: Obx(
                    () => IndexedStack(
                      index: controller.index.value.clamp(0, items.length - 1),
                      children: items.map((item) => item.page).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
