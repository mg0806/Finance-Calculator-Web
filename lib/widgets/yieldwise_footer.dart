import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../navigation.dart';

class YieldWiseFooter extends StatelessWidget {
  const YieldWiseFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryText = Colors.white;
    const mutedText = Color(0xFFE7F4EF);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 30),
      padding: const EdgeInsets.fromLTRB(28, 0, 28, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF032B22), Color(0xFF087A5D), Color(0xFFF6C85F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(color: Colors.white.withValues(alpha: 0.22), height: 1),
          const SizedBox(height: 36),
          Wrap(
            spacing: 54,
            runSpacing: 34,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              SizedBox(
                width: 330,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 280,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.38)),
                      ),
                      child: Image.asset(
                        'web/assets/yieldwise-wordmark.png',
                        fit: BoxFit.contain,
                        semanticLabel: 'YieldWise Financial Calculators logo',
                      ),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Free, fast calculators for SIP, EMI, FD, PPF, GST, CAGR, and retirement planning: no login needed.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: primaryText,
                        fontWeight: FontWeight.w700,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 330,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.22)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.info_outline,
                              size: 16, color: mutedText),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Not SEBI-registered. Results are estimates for planning only. Consult a qualified advisor before investing.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: mutedText,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const _FooterColumn(
                title: 'CALCULATORS',
                links: [
                  _FooterLinkData('SIP Calculator', '/sip-calculator'),
                  _FooterLinkData('EMI Calculator', '/emi-calculator'),
                  _FooterLinkData('FD Calculator', '/fd-calculator'),
                  _FooterLinkData('PPF Calculator', '/ppf-calculator'),
                  _FooterLinkData(
                      'Mortgage Calculator', '/mortgage-calculator'),
                  _FooterLinkData('CAGR Calculator', '/cagr-calculator'),
                  _FooterLinkData(
                      'Retirement Calculator', '/retirement-calculator'),
                  _FooterLinkData('GST Calculator', '/gst-calculator'),
                ],
                color: primaryText,
                muted: mutedText,
              ),
              _FooterColumn(
                title: 'ARTICLES',
                links: [
                  for (final article in articles.take(8))
                    _FooterLinkData(
                        _articleFooterTitle(article.title), article.route),
                ],
                color: primaryText,
                muted: mutedText,
              ),
              const _FooterColumn(
                title: 'COMPANY',
                links: [
                  _FooterLinkData('Home', '/home'),
                  _FooterLinkData('About Us', '/about'),
                  _FooterLinkData('Contact', '/contact'),
                  _FooterLinkData('Privacy Policy', '/privacy-policy'),
                  _FooterLinkData('Terms & Conditions', '/terms'),
                ],
                color: primaryText,
                muted: mutedText,
              ),
            ],
          ),
          const SizedBox(height: 34),
          Divider(color: Colors.white.withValues(alpha: 0.22), height: 1),
          const SizedBox(height: 18),
          Wrap(
            spacing: 28,
            runSpacing: 12,
            alignment: WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Wrap(
                spacing: 18,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '© 2025 YieldWise. All rights reserved.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const _InlineFooterLink(
                      label: 'Privacy', route: '/privacy-policy'),
                  const _InlineFooterLink(label: 'Terms', route: '/terms'),
                  const _InlineFooterLink(label: 'Contact', route: '/contact'),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.link, size: 16, color: mutedText),
                  const SizedBox(width: 8),
                  Text(
                    'May contain affiliate links: we earn a small commission at no extra cost to you.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: mutedText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({
    required this.title,
    required this.links,
    required this.color,
    required this.muted,
  });

  final String title;
  final List<_FooterLinkData> links;
  final Color color;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 185,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: muted,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          for (final link in links)
            _FooterLink(label: link.label, route: link.route, color: color),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.route,
    required this.color,
  });

  final String label;
  final String route;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () => goNamed(context, route),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
    );
  }
}

class _InlineFooterLink extends StatelessWidget {
  const _InlineFooterLink({required this.label, required this.route});

  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => goNamed(context, route),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _FooterLinkData {
  const _FooterLinkData(this.label, this.route);

  final String label;
  final String route;
}

String _articleFooterTitle(String title) {
  return title
      .replaceAll(': Which Investment Strategy Wins?', '')
      .replaceAll(': Where Should You Invest in 2025?', '')
      .replaceAll('7 Ways to ', '')
      .replaceAll('Home Loan Complete Guide for First-Time Buyers in India',
          'Home Loan Guide')
      .replaceAll(
          'How to Retire at 40: The Numbers You Need to Know', 'Retire at 40')
      .replaceAll('PPF Complete Guide: Rules, Limits, and Tax Benefits',
          'PPF Complete Guide')
      .replaceAll('What is CAGR and Why It Matters for Your Investments',
          'What is CAGR?')
      .replaceAll('Best Tax-Saving Investments Under Section 80C in 2025',
          'Tax Saving 80C');
}
