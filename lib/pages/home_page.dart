import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../navigation.dart';
import '../seo_service.dart';
import '../widgets/yieldwise_footer.dart';
import '../widgets/yieldwise_page_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setSeoMeta(
      title: 'YieldWise - Free Finance Calculators India',
      description:
          'Free SIP, EMI, FD, PPF calculators for smarter financial planning. No login needed.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return YieldWisePageScaffold(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const _YieldWiseHero(),
          const SizedBox(height: 24),
          Text(
            'Calculators',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final mobile = constraints.maxWidth < 640;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: mobile
                    ? const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      )
                    : const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 430,
                        childAspectRatio: 1.18,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                itemCount: calculatorNavItems.length,
                itemBuilder: (context, index) {
                  return _CalculatorTile(
                    item: calculatorNavItems[index],
                    color: _tileColors[index % _tileColors.length],
                  );
                },
              );
            },
          ),
          const SizedBox(height: 22),
          const Wrap(
            spacing: 14,
            runSpacing: 14,
            children: [
              _FeatureTile(
                  icon: Icons.flash_on_outlined,
                  title: 'Instant Results',
                  text: 'No sign-up needed'),
              _FeatureTile(
                  icon: Icons.lock_outline,
                  title: '100% Free',
                  text: 'Always and forever'),
              _FeatureTile(
                  icon: Icons.devices_outlined,
                  title: 'Works Everywhere',
                  text: 'Mobile, tablet, desktop'),
            ],
          ),
          const SizedBox(height: 26),
          Text(
            'Financial Guides & Tips',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < articles.take(3).length; i++)
                  _ArticleTeaser(
                    article: articles[i],
                    color: _tileColors[(i + 2) % _tileColors.length],
                  ),
              ],
            ),
          ),
          const YieldWiseFooter(),
        ],
      ),
    );
  }
}

class _YieldWiseHero extends StatelessWidget {
  const _YieldWiseHero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [Color(0xFF032B22), Color(0xFF087A5D), Color(0xFFF6C85F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 1180;
          final copy = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: wide ? 680 : 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(999),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.28)),
                  ),
                  child: Text(
                    'India money toolkit',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Smart Financial Decisions Start Here',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.02,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Free calculators for SIP, EMI, FD, PPF, GST and more, built with crisp results for action.',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.90),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroChip(
                        icon: Icons.grid_view,
                        label: '${calculatorNavItems.length} tools'),
                    const _HeroChip(
                        icon: Icons.lock_outline, label: 'Local first'),
                    const _HeroChip(icon: Icons.public, label: 'Web ready'),
                  ],
                ),
              ],
            ),
          );

          if (wide) {
            return Row(
              children: [
                Expanded(child: copy),
                const SizedBox(width: 24),
                const _YieldWiseLogoPanel(),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              const SizedBox(height: 22),
              const _YieldWiseLogoPanel(),
            ],
          );
        },
      ),
    );
  }
}

class _YieldWiseLogoPanel extends StatelessWidget {
  const _YieldWiseLogoPanel();

  @override
  Widget build(BuildContext context) {
    final available = MediaQuery.sizeOf(context).width;
    final desktop = available >= 1100;
    final width = desktop ? 520.0 : (available - 96).clamp(260.0, 440.0);
    return Container(
      width: width,
      height: width * 0.32,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.45)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF032B22).withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Image.asset(
        'web/assets/yieldwise-wordmark.png',
        fit: BoxFit.contain,
        semanticLabel: 'YieldWise Financial Calculators logo',
      ),
    );
  }
}

const _tileColors = [
  Color(0xFF087A5D),
  Color(0xFF1E5EFF),
  Color(0xFF0B5CAD),
  Color(0xFFB75C12),
  Color(0xFF6D3FD1),
  Color(0xFF0F766E),
  Color(0xFFCA8A04),
  Color(0xFFD92755),
];

class _CalculatorTile extends StatelessWidget {
  const _CalculatorTile({required this.item, required this.color});

  final CalculatorNavItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => goNamed(context, item.route),
        child: Ink(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -24,
                child: Icon(item.icon,
                    size: 116, color: Colors.white.withValues(alpha: 0.13)),
              ),
              Positioned(
                right: 14,
                top: 14,
                child: Icon(Icons.arrow_forward_rounded,
                    color: Colors.white.withValues(alpha: 0.72)),
              ),
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24)),
                      ),
                      child: Icon(item.icon, color: Colors.white),
                    ),
                    const Spacer(),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.86),
                        fontWeight: FontWeight.w700,
                        height: 1.12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF064D3E)),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: const Color(0xFF042C24),
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(
      {required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 315,
      child: Card(
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          subtitle: Text(text),
        ),
      ),
    );
  }
}

class _ArticleTeaser extends StatelessWidget {
  const _ArticleTeaser({required this.article, required this.color});

  final ArticleModel article;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340,
      height: 262,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => goNamed(context, article.route),
          child: Container(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: color, width: 5)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Chip(label: Text(article.category)),
                const SizedBox(height: 10),
                Text(article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(article.excerpt,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const Spacer(),
                TextButton(
                    onPressed: () => goNamed(context, article.route),
                    child: const Text('Read Article')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
