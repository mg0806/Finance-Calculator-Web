import 'package:flutter/material.dart';

import '../navigation.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            ListTile(
              leading: Icon(Icons.account_balance_wallet_outlined,
                  color: theme.colorScheme.primary),
              title: Text('YieldWise',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w900)),
            ),
            const Divider(),
            const _DrawerLink(
                icon: Icons.home_outlined, label: 'Home', route: '/home'),
            ExpansionTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Calculators'),
              children: [
                for (final item in calculatorNavItems)
                  ListTile(
                    dense: true,
                    leading: Icon(item.icon),
                    title: Text(item.title),
                    onTap: () {
                      Navigator.pop(context);
                      goNamed(context, item.route);
                    },
                  ),
              ],
            ),
            const _DrawerLink(
                icon: Icons.article_outlined,
                label: 'Blog & Articles',
                route: '/blog'),
            const _DrawerLink(
                icon: Icons.info_outline, label: 'About', route: '/about'),
            const _DrawerLink(
                icon: Icons.mail_outline, label: 'Contact', route: '/contact'),
            const Divider(),
            const _DrawerLink(
                icon: Icons.lock_outline,
                label: 'Privacy Policy',
                route: '/privacy-policy'),
            const _DrawerLink(
                icon: Icons.description_outlined,
                label: 'Terms & Conditions',
                route: '/terms'),
          ],
        ),
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  const _DrawerLink(
      {required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        goNamed(context, route);
      },
    );
  }
}
