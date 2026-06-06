import 'package:flutter/material.dart';

import '../navigation.dart';

class YieldWiseSideNav extends StatefulWidget {
  const YieldWiseSideNav({
    this.selectedCalculatorRoute,
    this.onCalculatorRouteSelected,
    super.key,
  });

  final String? selectedCalculatorRoute;
  final ValueChanged<String>? onCalculatorRouteSelected;

  @override
  State<YieldWiseSideNav> createState() => _YieldWiseSideNavState();
}

class _YieldWiseSideNavState extends State<YieldWiseSideNav> {
  var toolsExpanded = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final route = ModalRoute.of(context)?.settings.name ?? '';
    final selectedToolRoute = widget.selectedCalculatorRoute ??
        (route == '/calculators' || route.contains('calculator')
            ? route
            : null);

    return Container(
      width: 122,
      color: theme.navigationRailTheme.backgroundColor ??
          theme.navigationBarTheme.backgroundColor ??
          theme.cardColor,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: route == '/home' || route == '/',
              onTap: () => goNamed(context, '/home'),
            ),
            _NavItem(
              icon: Icons.article_outlined,
              label: 'Blog',
              selected: route.startsWith('/blog'),
              onTap: () => goNamed(context, '/blog'),
            ),
            _NavItem(
              icon: Icons.newspaper_outlined,
              label: 'News',
              selected: route == '/news',
              onTap: () => goNamed(context, '/news'),
            ),
            _NavItem(
              icon: Icons.info_outline,
              label: 'About',
              selected: route == '/about',
              onTap: () => goNamed(context, '/about'),
            ),
            _NavItem(
              icon: Icons.mail_outline,
              label: 'Contact',
              selected: route == '/contact',
              onTap: () => goNamed(context, '/contact'),
            ),
            const Divider(height: 18),
            _NavItem(
              icon: Icons.calculate_outlined,
              label: 'Tools',
              selected: route == '/calculators' || selectedToolRoute != null,
              trailing: Icon(
                toolsExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
              ),
              onTap: () => setState(() => toolsExpanded = !toolsExpanded),
            ),
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                children: [
                  _ToolItem(
                    icon: Icons.grid_view,
                    label: 'Overview',
                    selected: selectedToolRoute == '/calculators',
                    onTap: () => _openCalculator(context, '/calculators'),
                  ),
                  for (final item in calculatorNavItems)
                    _ToolItem(
                      icon: item.icon,
                      label: _shortToolLabel(item.title),
                      selected: selectedToolRoute == item.route,
                      onTap: () => _openCalculator(context, item.route),
                    ),
                ],
              ),
              crossFadeState: toolsExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 160),
              sizeCurve: Curves.easeOutCubic,
            ),
          ],
        ),
      ),
    );
  }

  void _openCalculator(BuildContext context, String route) {
    final handler = widget.onCalculatorRouteSelected;
    if (handler != null) {
      handler(route);
      return;
    }
    goNamed(context, route);
  }

  String _shortToolLabel(String title) {
    return title
        .replaceAll(' Calculator', '')
        .replaceAll('Loan Eligibility', 'Eligible')
        .replaceAll('Retirement', 'Retire')
        .replaceAll('Inflation', 'Infl.')
        .replaceAll('Step-up SIP', 'Step-up');
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              Icon(icon, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolItem extends StatelessWidget {
  const _ToolItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
          decoration: BoxDecoration(
            color: selected ? theme.colorScheme.primaryContainer : null,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
