import 'package:flutter/material.dart';

import '../navigation.dart';
import 'app_drawer.dart';
import 'yieldwise_side_nav.dart';

class YieldWisePageScaffold extends StatelessWidget {
  const YieldWisePageScaffold({
    required this.child,
    this.title = 'YieldWise',
    this.showBack = false,
    super.key,
  });

  final Widget child;
  final String title;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 820;
    final body = SafeArea(child: child);
    if (wide) {
      return Scaffold(
        body: Row(
          children: [
            const YieldWiseSideNav(),
            Expanded(child: body),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: showBack
            ? BackButton(onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  goNamed(context, '/home');
                }
              })
            : wide
                ? null
                : Builder(
                    builder: (context) => IconButton(
                      tooltip: 'Menu',
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
        title: Text(title),
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}

class YieldWiseTopNav extends StatelessWidget {
  const YieldWiseTopNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TextButton(
            onPressed: () => goNamed(context, '/home'),
            child: const Text('Home')),
        PopupMenuButton<String>(
          tooltip: 'Calculators',
          onSelected: (route) => goNamed(context, route),
          itemBuilder: (context) => [
            for (final item in calculatorNavItems)
              PopupMenuItem(value: item.route, child: Text(item.title)),
          ],
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Text('Calculators'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        TextButton(
            onPressed: () => goNamed(context, '/blog'),
            child: const Text('Blog')),
        TextButton(
            onPressed: () => goNamed(context, '/about'),
            child: const Text('About')),
        TextButton(
            onPressed: () => goNamed(context, '/contact'),
            child: const Text('Contact')),
        const SizedBox(width: 8),
      ],
    );
  }
}
