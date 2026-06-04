import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'adsense_stub.dart' if (dart.library.html) 'adsense_web.dart' as adsense;
import 'calculators.dart' as calc;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FinanceCalculatorApp());
}

class AffiliateLinks {
  const AffiliateLinks._();

  // Replace these with your real approved affiliate URLs when available.
  static const String? loanLead = null;
  static const String? startSip = null;
  static const String? fixedDeposit = null;
}

class AffiliateSettings {
  const AffiliateSettings._();

  static const enabled = false;
}

class AdSenseSettings {
  const AdSenseSettings._();

  static const publisherId = 'ca-pub-8210570961045499';

  static const displaySlotId = '6356348339';
}

class AffiliateOffer {
  const AffiliateOffer({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.icon,
    required this.color,
    required this.url,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final IconData icon;
  final Color color;
  final String? url;
}

class AffiliateOffers {
  const AffiliateOffers._();

  static const loan = AffiliateOffer(
    title: 'Loan partner lead',
    subtitle:
        'Send high-intent borrowers to a bank/NBFC partner after EMI, compare, or eligibility checks.',
    buttonLabel: 'Apply with partner',
    icon: Icons.account_balance,
    color: Color(0xFF0B5CAD),
    url: AffiliateLinks.loanLead,
  );

  static const sip = AffiliateOffer(
    title: 'Start this SIP',
    subtitle:
        'Convert SIP projections into brokerage or mutual-fund account signups.',
    buttonLabel: 'Start investing',
    icon: Icons.trending_up,
    color: Color(0xFF169B62),
    url: AffiliateLinks.startSip,
  );

  static const deposit = AffiliateOffer(
    title: 'Compare FD rates',
    subtitle:
        'Route conservative savers to a deposit, bank, or wealth partner.',
    buttonLabel: 'View partner rates',
    icon: Icons.savings,
    color: Color(0xFFB75C12),
    url: AffiliateLinks.fixedDeposit,
  );
}

class FinanceCalculatorApp extends StatelessWidget {
  const FinanceCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00A676),
      brightness: Brightness.light,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Calculator',
      theme: ThemeData(
        colorScheme: scheme,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFEAF7FF),
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFCFF5E8),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: scheme.outlineVariant),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: const Color(0xFFFBFFFC),
        ),
      ),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  var selectedIndex = 0;

  void _openModule(int index) {
    if (index == selectedIndex) return;
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final item = modules[selectedIndex];
    final page = selectedIndex == 0
        ? HomeDashboard(onOpen: _openModule)
        : CalculatorScreen(module: item);

    return Scaffold(
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              selectedIndex: selectedIndex,
              onDestinationSelected: _openModule,
              labelType: NavigationRailLabelType.all,
              minWidth: 96,
              groupAlignment: -0.92,
              scrollable: true,
              destinations: [
                for (final module in modules)
                  NavigationRailDestination(
                    icon: Icon(module.icon),
                    label: SizedBox(
                      width: 76,
                      child: Text(
                        module.shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          Expanded(
            child: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: page,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: min(selectedIndex, 4),
              onDestinationSelected: (index) {
                if (index == 4) {
                  _showModulePicker(context);
                } else {
                  _openModule(index);
                }
              },
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_outlined), label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.trending_up), label: 'SIP'),
                NavigationDestination(
                    icon: Icon(Icons.credit_card), label: 'EMI'),
                NavigationDestination(
                    icon: Icon(Icons.receipt_long), label: 'GST'),
                NavigationDestination(
                    icon: Icon(Icons.grid_view), label: 'More'),
              ],
            ),
    );
  }

  void _showModulePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          children: [
            for (var i = 1; i < modules.length; i++)
              ListTile(
                leading: Icon(modules[i].icon),
                title: Text(modules[i].title),
                subtitle: Text(modules[i].subtitle),
                onTap: () {
                  Navigator.pop(context);
                  _openModule(i);
                },
              ),
          ],
        );
      },
    );
  }
}

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({required this.onOpen, super.key});

  final ValueChanged<int> onOpen;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const DashboardHero(),
        const SizedBox(height: 20),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = constraints.maxWidth > 1000
                ? 4
                : constraints.maxWidth > 680
                    ? 3
                    : 2;
            final aspectRatio = constraints.maxWidth > 1000
                ? 1.18
                : constraints.maxWidth > 680
                    ? 1.08
                    : 0.82;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,
              ),
              itemCount: modules.length - 1,
              itemBuilder: (context, index) {
                final moduleIndex = index + 1;
                final module = modules[moduleIndex];
                return ModuleTile(
                    module: module, onTap: () => onOpen(moduleIndex));
              },
            );
          },
        ),
        const SizedBox(height: 16),
        const AdBanner(),
      ],
    );
  }
}

class DashboardHero extends StatelessWidget {
  const DashboardHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF032B22), Color(0xFF087A5D), Color(0xFFF6C85F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF087A5D).withValues(alpha: 0.25),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.30)),
            ),
            child: const Text(
              'India money toolkit',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Calculate smarter.\nMove faster.',
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  height: 1.02,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'SIP, EMI, GST, retirement, eligibility, and loan comparison with crisp results built for action.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.90),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 18),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              HeroMetric(label: '13 tools', icon: Icons.grid_view),
              HeroMetric(label: 'Local first', icon: Icons.lock_outline),
              HeroMetric(label: 'Web ready', icon: Icons.public),
            ],
          ),
        ],
      ),
    );
  }
}

class HeroMetric extends StatelessWidget {
  const HeroMetric({required this.label, required this.icon, super.key});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
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
            style: const TextStyle(
              color: Color(0xFF042C24),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class ModuleTile extends StatelessWidget {
  const ModuleTile({required this.module, required this.onTap, super.key});

  final FinanceModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = module.onAccent;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: module.accent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: module.accent.withValues(alpha: 0.22),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -18,
                bottom: -20,
                child: Icon(
                  module.icon,
                  size: 112,
                  color: foreground.withValues(alpha: 0.12),
                ),
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 20,
                  color: foreground.withValues(alpha: 0.70),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.20),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.24)),
                      ),
                      child: Icon(module.icon, color: foreground, size: 25),
                    ),
                    const Spacer(),
                    CalculatorGlyphStrip(
                      icons: moduleGlyphs(module.id),
                      color: foreground,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      module.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: foreground,
                            fontWeight: FontWeight.w900,
                            height: 1.12,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      module.subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: foreground.withValues(alpha: 0.84),
                            fontWeight: FontWeight.w600,
                            height: 1.18,
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

class CalculatorGlyphStrip extends StatelessWidget {
  const CalculatorGlyphStrip({
    required this.icons,
    required this.color,
    super.key,
  });

  final List<IconData> icons;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < icons.length; i++) ...[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Icon(icons[i], size: 16, color: color),
          ),
          if (i != icons.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}

List<IconData> moduleGlyphs(String id) {
  return switch (id) {
    'sip' => const [
        Icons.calendar_month_outlined,
        Icons.trending_up,
        Icons.account_balance_wallet_outlined,
      ],
    'emi' => const [
        Icons.payments_outlined,
        Icons.percent,
        Icons.table_chart_outlined,
      ],
    'mortgage' => const [
        Icons.house_outlined,
        Icons.fact_check_outlined,
        Icons.account_balance,
      ],
    'lumpsum' => const [
        Icons.savings_outlined,
        Icons.lock_clock,
        Icons.trending_flat,
      ],
    'ppf' => const [
        Icons.account_balance_outlined,
        Icons.verified_user_outlined,
        Icons.receipt_long,
      ],
    'cagr' => const [
        Icons.show_chart,
        Icons.timeline,
        Icons.analytics_outlined,
      ],
    'inflation' => const [
        Icons.price_change_outlined,
        Icons.shopping_bag_outlined,
        Icons.arrow_upward,
      ],
    'gst' => const [
        Icons.receipt_long,
        Icons.percent,
        Icons.calculate_outlined,
      ],
    'loan_compare' => const [
        Icons.compare_arrows,
        Icons.credit_card,
        Icons.savings,
      ],
    'retirement' => const [
        Icons.elderly,
        Icons.health_and_safety_outlined,
        Icons.event_available,
      ],
    'step_up_sip' => const [
        Icons.stacked_line_chart,
        Icons.add_circle_outline,
        Icons.trending_up,
      ],
    'loan_eligibility' => const [
        Icons.badge_outlined,
        Icons.home_work_outlined,
        Icons.check_circle_outline,
      ],
    _ => const [
        Icons.calculate_outlined,
        Icons.insights,
        Icons.done_all,
      ],
  };
}

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({required this.module, super.key});

  final FinanceModule module;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: ValueKey(module.id),
      padding: const EdgeInsets.all(20),
      children: [
        Row(
          children: [
            Icon(module.icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    module.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(module.subtitle),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        module.builder(context),
        if (module.faqs.isNotEmpty) ...[
          const SizedBox(height: 24),
          FAQSection(faqs: module.faqs),
        ],
        const SizedBox(height: 16),
        const AdBanner(),
      ],
    );
  }
}

class SipCalculator extends StatefulWidget {
  const SipCalculator({super.key});

  @override
  State<SipCalculator> createState() => _SipCalculatorState();
}

class _SipCalculatorState extends State<SipCalculator> {
  final amount = TextEditingController(text: '10000');
  final rate = TextEditingController(text: '12');
  final years = TextEditingController(text: '15');

  @override
  Widget build(BuildContext context) {
    final monthly = value(amount);
    final term = value(years).round();
    final invested = monthly * term * 12;
    final maturity = calc.futureValueSip(
      monthlyInvestment: monthly,
      annualReturnPercent: value(rate),
      years: term,
    );

    return CalculatorCard(
      inputs: [
        MoneyField(
            label: 'Monthly SIP', controller: amount, onChanged: refresh),
        PercentField(
            label: 'Expected return', controller: rate, onChanged: refresh),
        NumberField(label: 'Years', controller: years, onChanged: refresh),
      ],
      results: [
        ResultMetric('Maturity value', money(maturity)),
        ResultMetric('Invested amount', money(invested)),
        ResultMetric('Wealth gain', money(maturity - invested)),
      ],
      chart: VisualInsightPanel(
        title: 'SIP Growth Mix',
        subtitle: 'Invested capital, estimated gain, and corpus path',
        segments: [
          ChartItem(
            label: 'Invested',
            value: invested,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Wealth gain',
            value: max(0, maturity - invested),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'Invested',
            value: invested,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Maturity',
            value: maturity,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        linePoints: projectionPoints(
          years: term,
          valueAtYear: (year) => calc.futureValueSip(
            monthlyInvestment: monthly,
            annualReturnPercent: value(rate),
            years: year,
          ),
        ),
      ),
      tracker: PlanTracker(
        key: const ValueKey('sip-tracker'),
        title: 'Track your SIP',
        icon: Icons.calendar_month_outlined,
        currentLabel: 'Invested',
        currentValue: invested,
        targetLabel: 'Projected corpus',
        targetValue: maturity,
        markers: [
          TrackingMarker('Monthly habit', money(monthly)),
          TrackingMarker('Time left', '$term years'),
          TrackingMarker(
              'Gain share', percentOf(maturity - invested, maturity)),
        ],
      ),
      extra: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SipMarketPanel(),
          SizedBox(height: 12),
          AffiliatePanel(offer: AffiliateOffers.sip),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class EmiCalculator extends StatefulWidget {
  const EmiCalculator({super.key});

  @override
  State<EmiCalculator> createState() => _EmiCalculatorState();
}

class _EmiCalculatorState extends State<EmiCalculator> {
  final principal = TextEditingController(text: '2500000');
  final rate = TextEditingController(text: '8.5');
  final years = TextEditingController(text: '20');

  @override
  Widget build(BuildContext context) {
    final loan = value(principal);
    final term = value(years).round();
    final monthlyEmi = calc.emi(
      principal: loan,
      annualRatePercent: value(rate),
      years: term,
    );
    final total = monthlyEmi * term * 12;
    final rows = calc.amortisation(
      principal: loan,
      annualRatePercent: value(rate),
      years: term,
      maxRows: 6,
    );

    return CalculatorCard(
      inputs: [
        MoneyField(
            label: 'Loan amount', controller: principal, onChanged: refresh),
        PercentField(
            label: 'Interest rate', controller: rate, onChanged: refresh),
        NumberField(label: 'Years', controller: years, onChanged: refresh),
      ],
      results: [
        ResultMetric('Monthly EMI', money(monthlyEmi)),
        ResultMetric('Total interest', money(total - loan)),
        ResultMetric('Total payment', money(total)),
      ],
      chart: VisualInsightPanel(
        title: 'Loan Cost Breakdown',
        subtitle: 'Principal, interest, and balance reduction over time',
        segments: [
          ChartItem(
            label: 'Principal',
            value: loan,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Interest',
            value: max(0, total - loan),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'Loan',
            value: loan,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Interest',
            value: max(0, total - loan),
            color: Theme.of(context).colorScheme.tertiary,
          ),
          ChartItem(
            label: 'Total',
            value: total,
            color: const Color(0xFFD92755),
          ),
        ],
        linePoints: amortisationBalancePoints(
          principal: loan,
          annualRatePercent: value(rate),
          years: term,
        ),
      ),
      tracker: PlanTracker(
        key: const ValueKey('emi-tracker'),
        title: 'Track your loan',
        icon: Icons.payments_outlined,
        currentLabel: 'Principal borrowed',
        currentValue: loan,
        targetLabel: 'Total repayment',
        targetValue: total,
        markers: [
          TrackingMarker('Monthly EMI', money(monthlyEmi)),
          TrackingMarker('Interest load', percentOf(total - loan, total)),
          TrackingMarker('Tenure', '$term years'),
        ],
        inverseProgress: true,
      ),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AmortisationPreview(rows: rows),
          const SizedBox(height: 12),
          LowInterestLoanPanel(
            loanAmount: loan,
            years: term,
            title: 'Banks With Low EMI Offers',
          ),
          const SizedBox(height: 12),
          const AffiliatePanel(offer: AffiliateOffers.loan),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class MortgageCalculator extends StatefulWidget {
  const MortgageCalculator({super.key});

  @override
  State<MortgageCalculator> createState() => _MortgageCalculatorState();
}

class _MortgageCalculatorState extends State<MortgageCalculator> {
  final homePrice = TextEditingController(text: '4000000');
  final downPayment = TextEditingController(text: '20');
  final rate = TextEditingController(text: '8.5');
  final years = TextEditingController(text: '20');
  final propertyTax = TextEditingController(text: '1.2');
  final homeInsurance = TextEditingController(text: '24000');
  final hoa = TextEditingController(text: '0');
  final otherCosts = TextEditingController(text: '3000');
  final city = TextEditingController(text: 'Bengaluru');
  var cibilBand = '750-799';
  var employmentType = 'Salaried';
  var loanPurpose = 'Purchase';
  var rateSort = IndianRateSort.effectiveCost;

  @override
  Widget build(BuildContext context) {
    final result = calc.mortgage(
      homePrice: value(homePrice),
      downPaymentPercent: value(downPayment),
      annualRatePercent: value(rate),
      years: max(1, value(years).round()),
      annualPropertyTaxPercent: value(propertyTax),
      annualHomeInsurance: value(homeInsurance),
      monthlyHoa: value(hoa),
      monthlyOtherCosts: value(otherCosts),
    );
    final schedule = calc.annualAmortisation(
      principal: result.loanAmount,
      annualRatePercent: value(rate),
      years: max(1, value(years).round()),
      maxRows: 30,
    );

    return CalculatorCard(
      inputs: [
        MoneyField(
            label: 'Home price', controller: homePrice, onChanged: refresh),
        PercentField(
            label: 'Down payment', controller: downPayment, onChanged: refresh),
        NumberField(label: 'Loan term', controller: years, onChanged: refresh),
        PercentField(
            label: 'Interest rate', controller: rate, onChanged: refresh),
        const SectionLabel('Taxes and Costs'),
        PercentField(
            label: 'Property tax yearly',
            controller: propertyTax,
            onChanged: refresh),
        MoneyField(
            label: 'Home insurance yearly',
            controller: homeInsurance,
            onChanged: refresh),
        MoneyField(label: 'HOA monthly', controller: hoa, onChanged: refresh),
        MoneyField(
            label: 'Other costs monthly',
            controller: otherCosts,
            onChanged: refresh),
      ],
      results: [
        ResultMetric('Monthly payment', money(result.principalAndInterest)),
        ResultMetric('Total monthly cost', money(result.monthlyTotal)),
        ResultMetric('Loan amount', money(result.loanAmount)),
        ResultMetric('Total interest', money(result.totalInterest)),
      ],
      chart: MortgageBreakdown(result: result, schedule: schedule),
      tracker: PlanTracker(
        key: const ValueKey('mortgage-tracker'),
        title: 'Track your home loan',
        icon: Icons.house_outlined,
        currentLabel: 'Down payment',
        currentValue: result.downPayment,
        targetLabel: 'Home price',
        targetValue: result.homePrice,
        markers: [
          TrackingMarker('Monthly cost', money(result.monthlyTotal)),
          TrackingMarker('Loan amount', money(result.loanAmount)),
          TrackingMarker(
            'LTV',
            percentOf(result.loanAmount, max(1, result.homePrice)),
          ),
        ],
      ),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MortgageSummary(result: result),
          const SizedBox(height: 16),
          IndianRateComparisonPanel(
            city: city,
            cibilBand: cibilBand,
            employmentType: employmentType,
            loanPurpose: loanPurpose,
            sort: rateSort,
            loanAmount: result.loanAmount,
            years: max(1, value(years).round()),
            ltvPercent: result.homePrice <= 0
                ? 0
                : result.loanAmount / result.homePrice * 100,
            onCityChanged: refresh,
            onCibilChanged: (next) => setState(() => cibilBand = next),
            onEmploymentChanged: (next) =>
                setState(() => employmentType = next),
            onPurposeChanged: (next) => setState(() => loanPurpose = next),
            onSortChanged: (next) => setState(() => rateSort = next),
          ),
          const SizedBox(height: 16),
          AnnualAmortisationPreview(rows: schedule),
          const SizedBox(height: 12),
          const AffiliatePanel(offer: AffiliateOffers.loan),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({required this.kind, super.key});

  final SimpleKind kind;

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  final a = TextEditingController();
  final b = TextEditingController();
  final c = TextEditingController();
  var toggle = false;

  @override
  void initState() {
    super.initState();
    switch (widget.kind) {
      case SimpleKind.lumpsum:
        a.text = '100000';
        b.text = '7.5';
        c.text = '10';
        break;
      case SimpleKind.ppf:
        a.text = '150000';
        b.text = '7.1';
        c.text = '15';
        break;
      case SimpleKind.cagr:
        a.text = '100000';
        b.text = '250000';
        c.text = '5';
        break;
      case SimpleKind.inflation:
        a.text = '50000';
        b.text = '6';
        c.text = '15';
        break;
      case SimpleKind.gst:
        a.text = '10000';
        b.text = '18';
        c.text = '0';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return switch (widget.kind) {
      SimpleKind.lumpsum => _standard(
          inputs: [
            MoneyField(
                label: 'Investment amount', controller: a, onChanged: refresh),
            PercentField(
                label: 'Annual return', controller: b, onChanged: refresh),
            NumberField(label: 'Years', controller: c, onChanged: refresh),
          ],
          results: [
            ResultMetric(
              'Future value',
              money(
                calc.futureValueLumpsum(
                  principal: value(a),
                  annualRatePercent: value(b),
                  years: value(c).round(),
                  compoundsPerYear: 4,
                ),
              ),
            ),
          ],
          chart: VisualInsightPanel(
            title: 'FD Growth View',
            subtitle: 'Principal, earned return, and projected compounding',
            segments: [
              ChartItem(
                label: 'Principal',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Returns',
                value: max(
                  0,
                  calc.futureValueLumpsum(
                        principal: value(a),
                        annualRatePercent: value(b),
                        years: value(c).round(),
                        compoundsPerYear: 4,
                      ) -
                      value(a),
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            bars: [
              ChartItem(
                label: 'Now',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Future',
                value: calc.futureValueLumpsum(
                  principal: value(a),
                  annualRatePercent: value(b),
                  years: value(c).round(),
                  compoundsPerYear: 4,
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            linePoints: projectionPoints(
              years: value(c).round(),
              valueAtYear: (year) => calc.futureValueLumpsum(
                principal: value(a),
                annualRatePercent: value(b),
                years: year,
                compoundsPerYear: 4,
              ),
            ),
          ),
          tracker: PlanTracker(
            key: const ValueKey('fd-tracker'),
            title: 'Track your FD',
            icon: Icons.savings_outlined,
            currentLabel: 'Principal locked',
            currentValue: value(a),
            targetLabel: 'Maturity value',
            targetValue: calc.futureValueLumpsum(
              principal: value(a),
              annualRatePercent: value(b),
              years: value(c).round(),
              compoundsPerYear: 4,
            ),
            markers: [
              TrackingMarker('Rate', '${value(b).toStringAsFixed(2)}%'),
              TrackingMarker('Tenure', '${value(c).round()} years'),
              TrackingMarker(
                'Earned return',
                money(
                  calc.futureValueLumpsum(
                        principal: value(a),
                        annualRatePercent: value(b),
                        years: value(c).round(),
                        compoundsPerYear: 4,
                      ) -
                      value(a),
                ),
              ),
            ],
          ),
          extra: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FdRatePanel(
                amount: value(a),
                years: value(c).round(),
              ),
              const SizedBox(height: 12),
              const AffiliatePanel(offer: AffiliateOffers.deposit),
            ],
          ),
        ),
      SimpleKind.ppf => _standard(
          inputs: [
            MoneyField(
                label: 'Yearly deposit', controller: a, onChanged: refresh),
            PercentField(label: 'PPF rate', controller: b, onChanged: refresh),
            NumberField(label: 'Years', controller: c, onChanged: refresh),
          ],
          results: [
            ResultMetric(
              'Tax-free corpus',
              money(
                calc.ppfCorpus(
                  yearlyDeposit: value(a),
                  annualRatePercent: value(b),
                  years: value(c).round(),
                ),
              ),
            ),
            const ResultMetric('Section 80C note', 'Up to INR 1.5L/year'),
          ],
          chart: VisualInsightPanel(
            title: 'PPF Corpus Mix',
            subtitle: 'Deposits against tax-free compounding',
            segments: [
              ChartItem(
                label: 'Deposits',
                value: value(a) * value(c).round(),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Interest',
                value: max(
                  0,
                  calc.ppfCorpus(
                        yearlyDeposit: value(a),
                        annualRatePercent: value(b),
                        years: value(c).round(),
                      ) -
                      value(a) * value(c).round(),
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            bars: [
              ChartItem(
                label: 'Deposits',
                value: value(a) * value(c).round(),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Corpus',
                value: calc.ppfCorpus(
                  yearlyDeposit: value(a),
                  annualRatePercent: value(b),
                  years: value(c).round(),
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            linePoints: projectionPoints(
              years: value(c).round(),
              valueAtYear: (year) => calc.ppfCorpus(
                yearlyDeposit: value(a),
                annualRatePercent: value(b),
                years: year,
              ),
            ),
          ),
          tracker: PlanTracker(
            key: const ValueKey('ppf-tracker'),
            title: 'Track your PPF',
            icon: Icons.account_balance_outlined,
            currentLabel: 'Deposits planned',
            currentValue: value(a) * value(c).round(),
            targetLabel: 'Tax-free corpus',
            targetValue: calc.ppfCorpus(
              yearlyDeposit: value(a),
              annualRatePercent: value(b),
              years: value(c).round(),
            ),
            markers: [
              TrackingMarker('Yearly deposit', money(value(a))),
              TrackingMarker('Years', '${value(c).round()}'),
              TrackingMarker(
                'Interest share',
                percentOf(
                  calc.ppfCorpus(
                        yearlyDeposit: value(a),
                        annualRatePercent: value(b),
                        years: value(c).round(),
                      ) -
                      value(a) * value(c).round(),
                  calc.ppfCorpus(
                    yearlyDeposit: value(a),
                    annualRatePercent: value(b),
                    years: value(c).round(),
                  ),
                ),
              ),
            ],
          ),
          extra: const AffiliatePanel(offer: AffiliateOffers.sip),
        ),
      SimpleKind.cagr => _standard(
          inputs: [
            MoneyField(
                label: 'Initial value', controller: a, onChanged: refresh),
            MoneyField(label: 'Final value', controller: b, onChanged: refresh),
            NumberField(label: 'Years', controller: c, onChanged: refresh),
          ],
          results: [
            ResultMetric(
              'CAGR',
              '${calc.cagr(initialValue: value(a), finalValue: value(b), years: value(c).round()).toStringAsFixed(2)}%',
            ),
          ],
          chart: VisualInsightPanel(
            title: 'Growth Rate Story',
            subtitle: 'Starting value, ending value, and smoothed CAGR path',
            segments: [
              ChartItem(
                label: 'Initial',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Gain',
                value: max(0, value(b) - value(a)),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            bars: [
              ChartItem(
                label: 'Initial',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Final',
                value: value(b),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            linePoints: projectionPoints(
              years: value(c).round(),
              valueAtYear: (year) {
                final annualRate = calc.cagr(
                  initialValue: value(a),
                  finalValue: value(b),
                  years: value(c).round(),
                );
                return calc.futureValueLumpsum(
                  principal: value(a),
                  annualRatePercent: annualRate,
                  years: year,
                );
              },
            ),
          ),
          tracker: PlanTracker(
            key: const ValueKey('cagr-tracker'),
            title: 'Track your CAGR',
            icon: Icons.show_chart,
            currentLabel: 'Initial value',
            currentValue: value(a),
            targetLabel: 'Final value',
            targetValue: value(b),
            markers: [
              TrackingMarker(
                'CAGR',
                '${calc.cagr(initialValue: value(a), finalValue: value(b), years: value(c).round()).toStringAsFixed(2)}%',
              ),
              TrackingMarker('Duration', '${value(c).round()} years'),
              TrackingMarker('Growth', money(value(b) - value(a))),
            ],
          ),
        ),
      SimpleKind.inflation => _standard(
          inputs: [
            MoneyField(
                label: 'Current monthly amount',
                controller: a,
                onChanged: refresh),
            PercentField(
                label: 'Inflation rate', controller: b, onChanged: refresh),
            NumberField(label: 'Years', controller: c, onChanged: refresh),
          ],
          results: [
            ResultMetric(
              'Future monthly need',
              money(
                calc.inflatedValue(
                  currentAmount: value(a),
                  annualInflationPercent: value(b),
                  years: value(c).round(),
                ),
              ),
            ),
          ],
          chart: VisualInsightPanel(
            title: 'Inflation Impact',
            subtitle: 'Today’s expense versus future buying-power need',
            segments: [
              ChartItem(
                label: 'Today',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Inflation gap',
                value: max(
                  0,
                  calc.inflatedValue(
                        currentAmount: value(a),
                        annualInflationPercent: value(b),
                        years: value(c).round(),
                      ) -
                      value(a),
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            bars: [
              ChartItem(
                label: 'Today',
                value: value(a),
                color: Theme.of(context).colorScheme.primary,
              ),
              ChartItem(
                label: 'Future',
                value: calc.inflatedValue(
                  currentAmount: value(a),
                  annualInflationPercent: value(b),
                  years: value(c).round(),
                ),
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ],
            linePoints: projectionPoints(
              years: value(c).round(),
              valueAtYear: (year) => calc.inflatedValue(
                currentAmount: value(a),
                annualInflationPercent: value(b),
                years: year,
              ),
            ),
          ),
          tracker: PlanTracker(
            key: const ValueKey('inflation-tracker'),
            title: 'Track inflation pressure',
            icon: Icons.price_change_outlined,
            currentLabel: 'Today',
            currentValue: value(a),
            targetLabel: 'Future need',
            targetValue: calc.inflatedValue(
              currentAmount: value(a),
              annualInflationPercent: value(b),
              years: value(c).round(),
            ),
            markers: [
              TrackingMarker('Inflation', '${value(b).toStringAsFixed(2)}%'),
              TrackingMarker('Years', '${value(c).round()}'),
              TrackingMarker(
                'Extra needed',
                money(
                  calc.inflatedValue(
                        currentAmount: value(a),
                        annualInflationPercent: value(b),
                        years: value(c).round(),
                      ) -
                      value(a),
                ),
              ),
            ],
          ),
        ),
      SimpleKind.gst => _standard(
          inputs: [
            MoneyField(label: 'Amount', controller: a, onChanged: refresh),
            PercentField(label: 'GST rate', controller: b, onChanged: refresh),
            SwitchListTile(
              value: toggle,
              onChanged: (next) => setState(() => toggle = next),
              title: const Text('Amount already includes GST'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
          results: _gstResults(),
          chart: _gstChart(context),
          tracker: _gstTracker(),
        ),
    };
  }

  List<ResultMetric> _gstResults() {
    final result = calc.gst(
      amount: value(a),
      ratePercent: value(b),
      includesGst: toggle,
    );
    return [
      ResultMetric('Base amount', money(result.baseAmount)),
      ResultMetric('GST amount', money(result.gstAmount)),
      ResultMetric('Final amount', money(result.totalAmount)),
    ];
  }

  Widget _standard({
    required List<Widget> inputs,
    required List<ResultMetric> results,
    Widget? chart,
    Widget? tracker,
    Widget? extra,
  }) {
    return CalculatorCard(
      inputs: inputs,
      results: results,
      chart: chart,
      tracker: tracker,
      extra: extra,
    );
  }

  Widget _gstTracker() {
    final result = calc.gst(
      amount: value(a),
      ratePercent: value(b),
      includesGst: toggle,
    );

    return PlanTracker(
      key: const ValueKey('gst-tracker'),
      title: 'Track GST split',
      icon: Icons.receipt_long,
      currentLabel: toggle ? 'Base recovered' : 'Base amount',
      currentValue: result.baseAmount,
      targetLabel: toggle ? 'Invoice total' : 'Final amount',
      targetValue: result.totalAmount,
      markers: [
        TrackingMarker('GST rate', '${value(b).toStringAsFixed(2)}%'),
        TrackingMarker('GST amount', money(result.gstAmount)),
        TrackingMarker(
            'Tax share', percentOf(result.gstAmount, result.totalAmount)),
      ],
    );
  }

  Widget _gstChart(BuildContext context) {
    final result = calc.gst(
      amount: value(a),
      ratePercent: value(b),
      includesGst: toggle,
    );
    return VisualInsightPanel(
      title: 'GST Split',
      subtitle: toggle
          ? 'Included tax separated from total'
          : 'Tax added over base amount',
      segments: [
        ChartItem(
          label: 'Base',
          value: result.baseAmount,
          color: Theme.of(context).colorScheme.primary,
        ),
        ChartItem(
          label: 'GST',
          value: result.gstAmount,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
      bars: [
        ChartItem(
          label: 'Base',
          value: result.baseAmount,
          color: Theme.of(context).colorScheme.primary,
        ),
        ChartItem(
          label: 'GST',
          value: result.gstAmount,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        ChartItem(
          label: 'Total',
          value: result.totalAmount,
          color: const Color(0xFFD92755),
        ),
      ],
    );
  }

  void refresh(String _) => setState(() {});
}

class LoanCompareCalculator extends StatefulWidget {
  const LoanCompareCalculator({super.key});

  @override
  State<LoanCompareCalculator> createState() => _LoanCompareCalculatorState();
}

class _LoanCompareCalculatorState extends State<LoanCompareCalculator> {
  final loanA = TextEditingController(text: '3000000');
  final rateA = TextEditingController(text: '8.5');
  final yearsA = TextEditingController(text: '20');
  final loanB = TextEditingController(text: '3000000');
  final rateB = TextEditingController(text: '9.25');
  final yearsB = TextEditingController(text: '20');

  @override
  Widget build(BuildContext context) {
    final emiA = calc.emi(
      principal: value(loanA),
      annualRatePercent: value(rateA),
      years: value(yearsA).round(),
    );
    final emiB = calc.emi(
      principal: value(loanB),
      annualRatePercent: value(rateB),
      years: value(yearsB).round(),
    );
    final totalA = emiA * value(yearsA).round() * 12;
    final totalB = emiB * value(yearsB).round() * 12;

    return CalculatorCard(
      inputs: [
        const SectionLabel('Loan A'),
        MoneyField(label: 'Amount A', controller: loanA, onChanged: refresh),
        PercentField(label: 'Rate A', controller: rateA, onChanged: refresh),
        NumberField(label: 'Years A', controller: yearsA, onChanged: refresh),
        const SectionLabel('Loan B'),
        MoneyField(label: 'Amount B', controller: loanB, onChanged: refresh),
        PercentField(label: 'Rate B', controller: rateB, onChanged: refresh),
        NumberField(label: 'Years B', controller: yearsB, onChanged: refresh),
      ],
      results: [
        ResultMetric('EMI A', money(emiA)),
        ResultMetric('EMI B', money(emiB)),
        ResultMetric('Cheaper option', totalA <= totalB ? 'Loan A' : 'Loan B'),
        ResultMetric('Lifetime saving', money((totalA - totalB).abs())),
      ],
      chart: VisualInsightPanel(
        title: 'Loan A vs Loan B',
        subtitle: 'Compare EMI pressure and total repayment side by side',
        segments: [
          ChartItem(
            label: 'Loan A cost',
            value: totalA,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Loan B cost',
            value: totalB,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'EMI A',
            value: emiA,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'EMI B',
            value: emiB,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          ChartItem(
            label: 'Total A',
            value: totalA,
            color: const Color(0xFF0F766E),
          ),
          ChartItem(
            label: 'Total B',
            value: totalB,
            color: const Color(0xFFD92755),
          ),
        ],
      ),
      tracker: PlanTracker(
        key: const ValueKey('loan-compare-tracker'),
        title: 'Track loan comparison',
        icon: Icons.compare_arrows,
        currentLabel: totalA <= totalB ? 'Best total cost' : 'Best total cost',
        currentValue: min(totalA, totalB),
        targetLabel: 'Costlier option',
        targetValue: max(totalA, totalB),
        markers: [
          TrackingMarker('EMI gap', money((emiA - emiB).abs())),
          TrackingMarker('Saving', money((totalA - totalB).abs())),
          TrackingMarker('Winner', totalA <= totalB ? 'Loan A' : 'Loan B'),
        ],
      ),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LowInterestLoanPanel(
            loanAmount: value(loanA),
            years: value(yearsA).round(),
            title: 'Low Interest Loan Desk',
          ),
          const SizedBox(height: 12),
          const AffiliatePanel(offer: AffiliateOffers.loan),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class RetirementCalculator extends StatefulWidget {
  const RetirementCalculator({super.key});

  @override
  State<RetirementCalculator> createState() => _RetirementCalculatorState();
}

class _RetirementCalculatorState extends State<RetirementCalculator> {
  final age = TextEditingController(text: '32');
  final retireAge = TextEditingController(text: '60');
  final expense = TextEditingController(text: '60000');
  final inflation = TextEditingController(text: '6');
  final retireReturn = TextEditingController(text: '7');
  final preReturn = TextEditingController(text: '12');

  @override
  Widget build(BuildContext context) {
    final result = calc.retirementPlan(
      currentAge: value(age).round(),
      retirementAge: value(retireAge).round(),
      monthlyExpenseToday: value(expense),
      inflationPercent: value(inflation),
      retirementReturnPercent: value(retireReturn),
      preRetirementReturnPercent: value(preReturn),
    );

    return CalculatorCard(
      inputs: [
        NumberField(label: 'Current age', controller: age, onChanged: refresh),
        NumberField(
            label: 'Retirement age', controller: retireAge, onChanged: refresh),
        MoneyField(
            label: 'Monthly expense today',
            controller: expense,
            onChanged: refresh),
        PercentField(
            label: 'Inflation', controller: inflation, onChanged: refresh),
        PercentField(
            label: 'Return after retirement',
            controller: retireReturn,
            onChanged: refresh),
        PercentField(
            label: 'Return before retirement',
            controller: preReturn,
            onChanged: refresh),
      ],
      results: [
        ResultMetric('Corpus needed', money(result.corpusNeeded)),
        ResultMetric('Monthly SIP required', money(result.monthlySipRequired)),
        ResultMetric(
            'Retirement expense/month', money(result.futureMonthlyExpense)),
      ],
      chart: VisualInsightPanel(
        title: 'Retirement Readiness',
        subtitle: 'Expense growth, target corpus, and savings ramp',
        segments: [
          ChartItem(
            label: 'Annual expense',
            value: result.futureMonthlyExpense * 12,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Corpus buffer',
            value:
                max(0, result.corpusNeeded - result.futureMonthlyExpense * 12),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'Expense now',
            value: value(expense),
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'At retire',
            value: result.futureMonthlyExpense,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          ChartItem(
            label: 'SIP need',
            value: result.monthlySipRequired,
            color: const Color(0xFFD92755),
          ),
        ],
        linePoints: projectionPoints(
          years: max(1, value(retireAge).round() - value(age).round()),
          valueAtYear: (year) => calc.inflatedValue(
            currentAmount: value(expense),
            annualInflationPercent: value(inflation),
            years: year,
          ),
        ),
      ),
      tracker: PlanTracker(
        key: const ValueKey('retirement-tracker'),
        title: 'Track retirement plan',
        icon: Icons.elderly,
        currentLabel: 'Annual expense at retirement',
        currentValue: result.futureMonthlyExpense * 12,
        targetLabel: 'Corpus needed',
        targetValue: result.corpusNeeded,
        markers: [
          TrackingMarker('Monthly SIP', money(result.monthlySipRequired)),
          TrackingMarker(
            'Years to invest',
            '${max(1, value(retireAge).round() - value(age).round())}',
          ),
          TrackingMarker('Future expense', money(result.futureMonthlyExpense)),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class StepUpSipCalculator extends StatefulWidget {
  const StepUpSipCalculator({super.key});

  @override
  State<StepUpSipCalculator> createState() => _StepUpSipCalculatorState();
}

class _StepUpSipCalculatorState extends State<StepUpSipCalculator> {
  final amount = TextEditingController(text: '5000');
  final rate = TextEditingController(text: '12');
  final step = TextEditingController(text: '10');
  final years = TextEditingController(text: '20');

  @override
  Widget build(BuildContext context) {
    final normal = calc.futureValueSip(
      monthlyInvestment: value(amount),
      annualReturnPercent: value(rate),
      years: value(years).round(),
    );
    final stepped = calc.futureValueStepUpSip(
      monthlyInvestment: value(amount),
      annualReturnPercent: value(rate),
      annualStepUpPercent: value(step),
      years: value(years).round(),
    );

    return CalculatorCard(
      inputs: [
        MoneyField(
            label: 'Starting SIP', controller: amount, onChanged: refresh),
        PercentField(
            label: 'Expected return', controller: rate, onChanged: refresh),
        PercentField(
            label: 'Annual step-up', controller: step, onChanged: refresh),
        NumberField(label: 'Years', controller: years, onChanged: refresh),
      ],
      results: [
        ResultMetric('Step-up corpus', money(stepped)),
        ResultMetric('Normal SIP corpus', money(normal)),
        ResultMetric('Extra created', money(stepped - normal)),
      ],
      chart: VisualInsightPanel(
        title: 'Step-up Advantage',
        subtitle: 'Normal SIP baseline, extra corpus, and annual ramp',
        segments: [
          ChartItem(
            label: 'Normal SIP',
            value: normal,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Extra created',
            value: max(0, stepped - normal),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'Normal',
            value: normal,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Step-up',
            value: stepped,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        linePoints: projectionPoints(
          years: value(years).round(),
          valueAtYear: (year) => calc.futureValueStepUpSip(
            monthlyInvestment: value(amount),
            annualReturnPercent: value(rate),
            annualStepUpPercent: value(step),
            years: year,
          ),
        ),
      ),
      tracker: PlanTracker(
        key: const ValueKey('step-up-sip-tracker'),
        title: 'Track your step-up SIP',
        icon: Icons.stacked_line_chart,
        currentLabel: 'Normal SIP corpus',
        currentValue: normal,
        targetLabel: 'Step-up corpus',
        targetValue: stepped,
        markers: [
          TrackingMarker('Starting SIP', money(value(amount))),
          TrackingMarker(
              'Annual step-up', '${value(step).toStringAsFixed(2)}%'),
          TrackingMarker('Extra created', money(stepped - normal)),
        ],
      ),
      extra: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SipMarketPanel(title: 'Step-up SIP Watchlist'),
          SizedBox(height: 12),
          AffiliatePanel(offer: AffiliateOffers.sip),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class EligibilityCalculator extends StatefulWidget {
  const EligibilityCalculator({super.key});

  @override
  State<EligibilityCalculator> createState() => _EligibilityCalculatorState();
}

class _EligibilityCalculatorState extends State<EligibilityCalculator> {
  final income = TextEditingController(text: '120000');
  final obligations = TextEditingController(text: '15000');
  final rate = TextEditingController(text: '8.75');
  final years = TextEditingController(text: '20');
  final foir = TextEditingController(text: '50');

  @override
  Widget build(BuildContext context) {
    final eligible = calc.maxLoanEligibility(
      monthlyIncome: value(income),
      existingEmis: value(obligations),
      annualRatePercent: value(rate),
      years: value(years).round(),
      foirPercent: value(foir),
    );
    final eligibleEmi =
        max(0, value(income) * value(foir) / 100 - value(obligations))
            .toDouble();

    return CalculatorCard(
      inputs: [
        MoneyField(
            label: 'Monthly income', controller: income, onChanged: refresh),
        MoneyField(
            label: 'Existing EMIs',
            controller: obligations,
            onChanged: refresh),
        PercentField(
            label: 'Interest rate', controller: rate, onChanged: refresh),
        NumberField(
            label: 'Loan tenure years', controller: years, onChanged: refresh),
        PercentField(label: 'FOIR limit', controller: foir, onChanged: refresh),
      ],
      results: [
        ResultMetric('Maximum loan', money(eligible)),
        ResultMetric('Affordable EMI', money(eligibleEmi)),
        ResultMetric('Income buffer',
            money(value(income) - value(obligations) - eligibleEmi)),
      ],
      chart: VisualInsightPanel(
        title: 'Eligibility Capacity',
        subtitle: 'Income allocation and the loan amount it can support',
        segments: [
          ChartItem(
            label: 'Existing EMI',
            value: value(obligations),
            color: const Color(0xFFD92755),
          ),
          ChartItem(
            label: 'New EMI room',
            value: eligibleEmi,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Income buffer',
            value: max(0, value(income) - value(obligations) - eligibleEmi),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
        bars: [
          ChartItem(
            label: 'Income',
            value: value(income),
            color: const Color(0xFF0F766E),
          ),
          ChartItem(
            label: 'EMI room',
            value: eligibleEmi,
            color: Theme.of(context).colorScheme.primary,
          ),
          ChartItem(
            label: 'Max loan',
            value: eligible,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ],
      ),
      tracker: PlanTracker(
        key: const ValueKey('eligibility-tracker'),
        title: 'Track loan eligibility',
        icon: Icons.home_work_outlined,
        currentLabel: 'Existing obligations',
        currentValue: value(obligations),
        targetLabel: 'FOIR EMI limit',
        targetValue: value(income) * value(foir) / 100,
        markers: [
          TrackingMarker('Affordable EMI', money(eligibleEmi)),
          TrackingMarker('Maximum loan', money(eligible)),
          TrackingMarker('FOIR', '${value(foir).toStringAsFixed(2)}%'),
        ],
      ),
      extra: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LowInterestLoanPanel(
            loanAmount: eligible,
            years: value(years).round(),
            title: 'Banks Matching This Eligibility',
          ),
          const SizedBox(height: 12),
          const AffiliatePanel(offer: AffiliateOffers.loan),
        ],
      ),
    );
  }

  void refresh(String _) => setState(() {});
}

class CalculatorCard extends StatelessWidget {
  const CalculatorCard({
    required this.inputs,
    required this.results,
    this.chart,
    this.tracker,
    this.extra,
    super.key,
  });

  final List<Widget> inputs;
  final List<ResultMetric> results;
  final Widget? chart;
  final Widget? tracker;
  final Widget? extra;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 780;
        final inputPanel = Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionLabel('Inputs'),
                const SizedBox(height: 12),
                ...spaced(inputs),
              ],
            ),
          ),
        );
        final resultPanel = Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionLabel('Results'),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final result in results) ResultTile(metric: result),
                  ],
                ),
                if (chart != null) ...[const SizedBox(height: 16), chart!],
                if (tracker != null) ...[
                  const SizedBox(height: 16),
                  tracker!,
                ],
                if (extra != null) ...[const SizedBox(height: 16), extra!],
              ],
            ),
          ),
        );

        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 330, child: inputPanel),
              const SizedBox(width: 12),
              Expanded(child: resultPanel),
            ],
          );
        }

        return Column(children: [inputPanel, resultPanel]);
      },
    );
  }
}

class PlanTracker extends StatefulWidget {
  const PlanTracker({
    required this.title,
    required this.icon,
    required this.currentLabel,
    required this.currentValue,
    required this.targetLabel,
    required this.targetValue,
    required this.markers,
    this.inverseProgress = false,
    super.key,
  });

  final String title;
  final IconData icon;
  final String currentLabel;
  final double currentValue;
  final String targetLabel;
  final double targetValue;
  final List<TrackingMarker> markers;
  final bool inverseProgress;

  @override
  State<PlanTracker> createState() => _PlanTrackerState();
}

class _PlanTrackerState extends State<PlanTracker> {
  final paid = TextEditingController();
  final entries = <TrackingEntry>[];
  var trackedTotal = 0.0;
  late final String storageKey;

  @override
  void initState() {
    super.initState();
    storageKey = 'plan_tracker_${_keyName(widget.key)}';
    _loadEntries();
  }

  @override
  void dispose() {
    paid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeTarget = max(1.0, widget.targetValue.abs());
    final progress = (trackedTotal / safeTarget).clamp(0.0, 1.0).toDouble();
    final remaining =
        max(0, widget.targetValue.abs() - trackedTotal).toDouble();
    final color = widget.inverseProgress
        ? const Color(0xFFD92755)
        : Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFFFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(widget.icon, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
              Text(
                '${(progress * 100).clamp(0, 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 12,
              value: progress,
              backgroundColor:
                  Theme.of(context).colorScheme.surfaceContainerHighest,
              color: color,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: TrackerValue(
                      label: 'Tracked paid', value: money(trackedTotal))),
              const SizedBox(width: 12),
              Expanded(
                child: TrackerValue(
                  label: 'Remaining',
                  value: money(remaining),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 520;
              final field = TextField(
                controller: paid,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onSubmitted: (_) => _addEntry(),
                decoration: const InputDecoration(
                  labelText: 'Amount paid this month',
                  prefixText: 'INR ',
                ),
              );
              final actions = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton.icon(
                    onPressed: _addEntry,
                    icon: const Icon(Icons.add),
                    label: const Text('Add'),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed: trackedTotal > 0 ? _resetTracker : null,
                    tooltip: 'Reset tracker',
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              );

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: field),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: actions,
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  field,
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerRight, child: actions),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TrackerValue(
                  label: widget.currentLabel,
                  value: money(widget.currentValue),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TrackerValue(
                  label: widget.targetLabel,
                  value: money(widget.targetValue),
                  alignEnd: true,
                ),
              ),
            ],
          ),
          if (entries.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final entry in entries.take(4))
                  TrackingPill(
                    marker: TrackingMarker(entry.label, money(entry.amount)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final marker in widget.markers) TrackingPill(marker: marker),
            ],
          ),
        ],
      ),
    );
  }

  void _addEntry() {
    final amount = value(paid);
    if (amount <= 0) return;
    setState(() {
      trackedTotal += amount;
      entries.insert(
        0,
        TrackingEntry(
          label: 'Month ${entries.length + 1}',
          amount: amount,
        ),
      );
      paid.clear();
    });
    _saveEntries();
  }

  void _resetTracker() {
    setState(() {
      trackedTotal = 0;
      entries.clear();
      paid.clear();
    });
    _clearEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(storageKey) ?? const [];
    final loaded = [
      for (final row in saved)
        if (TrackingEntry.tryParse(row) case final entry?) entry,
    ];
    if (!mounted || loaded.isEmpty) return;
    setState(() {
      entries
        ..clear()
        ..addAll(loaded);
      trackedTotal = entries.fold(0.0, (total, entry) => total + entry.amount);
    });
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      storageKey,
      [for (final entry in entries) entry.serialize()],
    );
  }

  Future<void> _clearEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(storageKey);
  }

  String _keyName(Key? key) {
    if (key is ValueKey<String>) return key.value;
    return widget.title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}

class TrackerValue extends StatelessWidget {
  const TrackerValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
    super.key,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

class TrackingPill extends StatelessWidget {
  const TrackingPill({required this.marker, super.key});

  final TrackingMarker marker;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 36),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${marker.label}: ${marker.value}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class TrackingMarker {
  const TrackingMarker(this.label, this.value);

  final String label;
  final String value;
}

class TrackingEntry {
  const TrackingEntry({
    required this.label,
    required this.amount,
  });

  final String label;
  final double amount;

  static TrackingEntry? tryParse(String raw) {
    final separator = raw.lastIndexOf('|');
    if (separator <= 0 || separator == raw.length - 1) return null;
    final amount = double.tryParse(raw.substring(separator + 1));
    if (amount == null) return null;
    return TrackingEntry(label: raw.substring(0, separator), amount: amount);
  }

  String serialize() => '$label|$amount';
}

class ResultTile extends StatelessWidget {
  const ResultTile({required this.metric, super.key});

  final ResultMetric metric;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Text(
            metric.value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class SplitBar extends StatelessWidget {
  const SplitBar({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftValue,
    required this.rightValue,
    super.key,
  });

  final String leftLabel;
  final String rightLabel;
  final double leftValue;
  final double rightValue;

  @override
  Widget build(BuildContext context) {
    final total = max(1, leftValue + rightValue);
    final leftFlex = max(1, (leftValue / total * 1000).round());
    final rightFlex = max(1, (rightValue / total * 1000).round());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 18,
            child: Row(
              children: [
                Expanded(
                  flex: leftFlex,
                  child:
                      ColoredBox(color: Theme.of(context).colorScheme.primary),
                ),
                Expanded(
                  flex: rightFlex,
                  child:
                      ColoredBox(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
            '$leftLabel ${money(leftValue)}   $rightLabel ${money(rightValue)}'),
      ],
    );
  }
}

class ChartItem {
  const ChartItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

class VisualInsightPanel extends StatelessWidget {
  const VisualInsightPanel({
    required this.title,
    required this.subtitle,
    required this.segments,
    required this.bars,
    this.linePoints = const [],
    super.key,
  });

  final String title;
  final String subtitle;
  final List<ChartItem> segments;
  final List<ChartItem> bars;
  final List<double> linePoints;

  @override
  Widget build(BuildContext context) {
    final cleanedSegments = positiveItems(segments);
    final cleanedBars = positiveItems(bars);
    final showPie = cleanedSegments.length >= 2;
    final showLine = linePoints.where((point) => point.isFinite).length >= 2;
    final stats = _panelStats(cleanedSegments, cleanedBars, linePoints);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.insights,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (stats.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final stat in stats) InsightStatChip(stat: stat),
              ],
            ),
            const SizedBox(height: 14),
          ],
          LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 620;
              final visualChildren = [
                if (showPie)
                  _InsightTile(
                    title: 'Split',
                    child: PieInsight(items: cleanedSegments),
                  ),
                _InsightTile(
                  title: 'Comparison',
                  child: BarInsight(items: cleanedBars),
                ),
                if (showLine)
                  _InsightTile(
                    title: 'Trend',
                    child: LineInsight(
                      points: linePoints,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
              ];

              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < visualChildren.length; i++) ...[
                      Expanded(child: visualChildren[i]),
                      if (i != visualChildren.length - 1)
                        const SizedBox(width: 12),
                    ],
                  ],
                );
              }

              return Column(
                children: [
                  for (var i = 0; i < visualChildren.length; i++) ...[
                    visualChildren[i],
                    if (i != visualChildren.length - 1)
                      const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  List<InsightStat> _panelStats(
    List<ChartItem> cleanedSegments,
    List<ChartItem> cleanedBars,
    List<double> rawLinePoints,
  ) {
    final stats = <InsightStat>[];
    if (cleanedSegments.isNotEmpty) {
      final total =
          cleanedSegments.fold<double>(0, (sum, item) => sum + item.value);
      final leading = cleanedSegments.reduce(
        (best, item) => item.value > best.value ? item : best,
      );
      stats.add(
        InsightStat(
          'Largest share',
          '${leading.label} ${percentOf(leading.value, total)}',
        ),
      );
    }

    if (cleanedBars.length >= 2) {
      final first = cleanedBars.first.value;
      final last = cleanedBars.last.value;
      stats.add(InsightStat('Change', money(last - first)));
    }

    final cleanLine = rawLinePoints.where((point) => point.isFinite).toList();
    if (cleanLine.length >= 2) {
      stats.add(InsightStat('Trend end', money(cleanLine.last)));
    }

    return stats.take(3).toList();
  }
}

class InsightStatChip extends StatelessWidget {
  const InsightStatChip({required this.stat, super.key});

  final InsightStat stat;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 42, minWidth: 138),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class InsightStat {
  const InsightStat(this.label, this.value);

  final String label;
  final String value;
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 210),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 10),
          SizedBox(height: 150, child: child),
        ],
      ),
    );
  }
}

class PieInsight extends StatelessWidget {
  const PieInsight({required this.items, super.key});

  final List<ChartItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: CustomPaint(painter: PieInsightPainter(items)),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ChartLegend(items: items),
      ],
    );
  }
}

class PieInsightPainter extends CustomPainter {
  const PieInsightPainter(this.items);

  final List<ChartItem> items;

  @override
  void paint(Canvas canvas, Size size) {
    final total = items.fold<double>(0, (sum, item) => sum + item.value);
    if (total <= 0) return;

    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    var start = -pi / 2;

    for (final item in items) {
      final sweep = item.value / total * pi * 2;
      canvas.drawArc(
        rect,
        start,
        sweep,
        true,
        Paint()..color = item.color,
      );
      start += sweep;
    }

    canvas.drawCircle(
      center,
      radius * 0.52,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant PieInsightPainter oldDelegate) {
    return oldDelegate.items != items;
  }
}

class BarInsight extends StatelessWidget {
  const BarInsight({required this.items, super.key});

  final List<ChartItem> items;

  @override
  Widget build(BuildContext context) {
    final maxValue = max(
      1.0,
      items.fold<double>(0, (largest, item) => max(largest, item.value)),
    );

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < items.length; i++) ...[
                Expanded(
                  child: _BarColumn(item: items[i], maxValue: maxValue),
                ),
                if (i != items.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BarColumn extends StatelessWidget {
  const _BarColumn({required this.item, required this.maxValue});

  final ChartItem item;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final fill = (item.value / maxValue).clamp(0.06, 1.0).toDouble();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          money(item.value),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: fill,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: item.color,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          item.label,
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class LineInsight extends StatelessWidget {
  const LineInsight({required this.points, required this.color, super.key});

  final List<double> points;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final cleaned = points.where((point) => point.isFinite).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: CustomPaint(
            painter: LineInsightPainter(
              points: cleaned,
              color: color,
              gridColor: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(
                'Start ${money(cleaned.first)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Spacer(),
            Expanded(
              child: Text(
                'End ${money(cleaned.last)}',
                maxLines: 1,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class LineInsightPainter extends CustomPainter {
  const LineInsightPainter({
    required this.points,
    required this.color,
    required this.gridColor,
  });

  final List<double> points;
  final Color color;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    const inset = EdgeInsets.fromLTRB(6, 8, 6, 10);
    final chart = Rect.fromLTWH(
      inset.left,
      inset.top,
      size.width - inset.horizontal,
      size.height - inset.vertical,
    );
    final minValue = points.reduce(min);
    final maxValue = points.reduce(max);
    final span = max(1, maxValue - minValue);
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;

    for (var i = 0; i < 4; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = chart.left + chart.width * i / (points.length - 1);
      final y = chart.bottom - ((points[i] - minValue) / span) * chart.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(chart.right, chart.bottom)
      ..lineTo(chart.left, chart.bottom)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()..color = color.withValues(alpha: 0.12),
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (final pointIndex in [0, points.length - 1]) {
      final x = chart.left + chart.width * pointIndex / (points.length - 1);
      final y = chart.bottom -
          ((points[pointIndex] - minValue) / span) * chart.height;
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()..color = Colors.white,
      );
      canvas.drawCircle(
        Offset(x, y),
        5,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LineInsightPainter oldDelegate) {
    return oldDelegate.points != points ||
        oldDelegate.color != color ||
        oldDelegate.gridColor != gridColor;
  }
}

class ChartLegend extends StatelessWidget {
  const ChartLegend({required this.items, super.key});

  final List<ChartItem> items;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 8,
      children: [
        for (final item in items)
          SizedBox(
            width: 128,
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration:
                      BoxDecoration(color: item.color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${item.label} ${money(item.value)}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class MortgageBreakdown extends StatelessWidget {
  const MortgageBreakdown({
    required this.result,
    required this.schedule,
    super.key,
  });

  final calc.MortgageResult result;
  final List<calc.AnnualAmortisationRow> schedule;

  @override
  Widget build(BuildContext context) {
    final parts = [
      BreakdownPart(
        'Principal & interest',
        result.principalAndInterest,
        Theme.of(context).colorScheme.primary,
      ),
      BreakdownPart(
          'Property tax', result.monthlyPropertyTax, const Color(0xFF7FB800)),
      BreakdownPart(
          'Insurance', result.monthlyHomeInsurance, const Color(0xFFD92755)),
      BreakdownPart('HOA', result.monthlyHoa, const Color(0xFFF6C85F)),
      BreakdownPart('Other', result.monthlyOtherCosts,
          Theme.of(context).colorScheme.tertiary),
    ].where((part) => part.value > 0).toList();

    return VisualInsightPanel(
      title: 'Monthly Housing Cost',
      subtitle: 'Payment split, total cost, and loan balance path',
      segments: [
        for (final part in parts)
          ChartItem(label: part.label, value: part.value, color: part.color),
      ],
      bars: [
        ChartItem(
          label: 'Down pay',
          value: result.downPayment,
          color: const Color(0xFF0F766E),
        ),
        ChartItem(
          label: 'Loan',
          value: result.loanAmount,
          color: Theme.of(context).colorScheme.primary,
        ),
        ChartItem(
          label: 'Interest',
          value: result.totalInterest,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
      linePoints: [
        result.loanAmount,
        for (final row in schedule) row.balance,
      ],
    );
  }
}

class MortgageLegendItem extends StatelessWidget {
  const MortgageLegendItem({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          '$label ${money(value)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class MortgageSummary extends StatelessWidget {
  const MortgageSummary({required this.result, super.key});

  final calc.MortgageResult result;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionLabel('Mortgage Snapshot'),
          const SizedBox(height: 10),
          MortgageSummaryRow('House price', money(result.homePrice)),
          MortgageSummaryRow('Down payment', money(result.downPayment)),
          MortgageSummaryRow(
              'Principal & interest/month', money(result.principalAndInterest)),
          MortgageSummaryRow('Taxes, insurance & costs/month',
              money(result.monthlyTotal - result.principalAndInterest)),
          MortgageSummaryRow(
              'Total out of pocket', money(result.totalOutOfPocket)),
        ],
      ),
    );
  }
}

class MortgageSummaryRow extends StatelessWidget {
  const MortgageSummaryRow(this.label, this.value, {super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          const SizedBox(width: 12),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class IndianRateComparisonPanel extends StatelessWidget {
  const IndianRateComparisonPanel({
    required this.city,
    required this.cibilBand,
    required this.employmentType,
    required this.loanPurpose,
    required this.sort,
    required this.loanAmount,
    required this.years,
    required this.ltvPercent,
    required this.onCityChanged,
    required this.onCibilChanged,
    required this.onEmploymentChanged,
    required this.onPurposeChanged,
    required this.onSortChanged,
    super.key,
  });

  final TextEditingController city;
  final String cibilBand;
  final String employmentType;
  final String loanPurpose;
  final IndianRateSort sort;
  final double loanAmount;
  final int years;
  final double ltvPercent;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onCibilChanged;
  final ValueChanged<String> onEmploymentChanged;
  final ValueChanged<String> onPurposeChanged;
  final ValueChanged<IndianRateSort> onSortChanged;

  @override
  Widget build(BuildContext context) {
    final offers = _pricedOffers();
    final best = offers.isEmpty ? null : offers.first;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionLabel('Indian Home Loan Rate Desk'),
                    const SizedBox(height: 4),
                    Text(
                      'Compare indicative bank and HFC offers for ${city.text.trim().isEmpty ? 'your city' : city.text.trim()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (best != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${best.rate.toStringAsFixed(2)}% onwards',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          RateSearchOptions(
            city: city,
            cibilBand: cibilBand,
            employmentType: employmentType,
            loanPurpose: loanPurpose,
            onCityChanged: onCityChanged,
            onCibilChanged: onCibilChanged,
            onEmploymentChanged: onEmploymentChanged,
            onPurposeChanged: onPurposeChanged,
          ),
          const SizedBox(height: 12),
          RateSortBar(sort: sort, onChanged: onSortChanged),
          const SizedBox(height: 12),
          ...spaced([
            for (final offer in offers)
              IndianRateOfferCard(offer: offer, loanPurpose: loanPurpose),
          ]),
          const SizedBox(height: 16),
          IndianPreApprovalPanel(
            loanPurpose: loanPurpose,
            loanAmount: loanAmount,
            cibilBand: cibilBand,
            city: city.text,
          ),
          const SizedBox(height: 10),
          Text(
            'Indicative rows only. Final rates, spreads, concessions, legal valuation, processing fees, and insurance requirements depend on each lender, property, income profile, CIBIL score, and sanction terms.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  List<PricedIndianRateOffer> _pricedOffers() {
    final cibilAdjustment = switch (cibilBand) {
      '800+' => 0.0,
      '750-799' => 0.10,
      '700-749' => 0.35,
      _ => 0.75,
    };
    final employmentAdjustment = employmentType == 'Self-employed' ? 0.20 : 0.0;
    final purposeAdjustment = loanPurpose == 'Balance transfer' ? 0.05 : 0.0;
    final ltvAdjustment = ltvPercent > 80 ? 0.15 : 0.0;

    final offers = [
      for (final provider in indianRateProviders)
        PricedIndianRateOffer.fromProvider(
          provider,
          rateAdjustment: cibilAdjustment +
              employmentAdjustment +
              purposeAdjustment +
              ltvAdjustment,
          loanAmount: loanAmount,
          years: years,
        ),
    ];

    offers.sort((a, b) {
      return switch (sort) {
        IndianRateSort.effectiveCost =>
          a.effectiveCost.compareTo(b.effectiveCost),
        IndianRateSort.emi => a.monthlyEmi.compareTo(b.monthlyEmi),
        IndianRateSort.rate => a.rate.compareTo(b.rate),
        IndianRateSort.fees => a.processingFee.compareTo(b.processingFee),
      };
    });
    return offers;
  }
}

class RateSearchOptions extends StatelessWidget {
  const RateSearchOptions({
    required this.city,
    required this.cibilBand,
    required this.employmentType,
    required this.loanPurpose,
    required this.onCityChanged,
    required this.onCibilChanged,
    required this.onEmploymentChanged,
    required this.onPurposeChanged,
    super.key,
  });

  final TextEditingController city;
  final String cibilBand;
  final String employmentType;
  final String loanPurpose;
  final ValueChanged<String> onCityChanged;
  final ValueChanged<String> onCibilChanged;
  final ValueChanged<String> onEmploymentChanged;
  final ValueChanged<String> onPurposeChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 760 ? 4 : 2;
        return GridView.count(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: columns == 4 ? 2.5 : 2.2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TextField(
              controller: city,
              onChanged: onCityChanged,
              decoration: const InputDecoration(
                labelText: 'City',
                prefixIcon: Icon(Icons.location_city_outlined),
              ),
            ),
            SelectField(
              label: 'CIBIL band',
              value: cibilBand,
              options: const ['800+', '750-799', '700-749', '<700'],
              onChanged: onCibilChanged,
            ),
            SelectField(
              label: 'Profile',
              value: employmentType,
              options: const ['Salaried', 'Self-employed'],
              onChanged: onEmploymentChanged,
            ),
            SelectField(
              label: 'Loan use',
              value: loanPurpose,
              options: const ['Purchase', 'Balance transfer'],
              onChanged: onPurposeChanged,
            ),
          ],
        );
      },
    );
  }
}

class SelectField extends StatelessWidget {
  const SelectField({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    super.key,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      items: [
        for (final option in options)
          DropdownMenuItem(value: option, child: Text(option)),
      ],
      onChanged: (next) {
        if (next != null) onChanged(next);
      },
      decoration: InputDecoration(labelText: label),
    );
  }
}

class RateSortBar extends StatelessWidget {
  const RateSortBar({required this.sort, required this.onChanged, super.key});

  final IndianRateSort sort;
  final ValueChanged<IndianRateSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SegmentedButton<IndianRateSort>(
        selected: {sort},
        onSelectionChanged: (next) => onChanged(next.single),
        segments: const [
          ButtonSegment(
            value: IndianRateSort.effectiveCost,
            label: Text('Cost'),
            icon: Icon(Icons.savings_outlined),
          ),
          ButtonSegment(
            value: IndianRateSort.emi,
            label: Text('EMI'),
            icon: Icon(Icons.calendar_month_outlined),
          ),
          ButtonSegment(
            value: IndianRateSort.rate,
            label: Text('Rate'),
            icon: Icon(Icons.percent),
          ),
          ButtonSegment(
            value: IndianRateSort.fees,
            label: Text('Fees'),
            icon: Icon(Icons.receipt_long),
          ),
        ],
      ),
    );
  }
}

class IndianRateOfferCard extends StatelessWidget {
  const IndianRateOfferCard({
    required this.offer,
    required this.loanPurpose,
    super.key,
  });

  final PricedIndianRateOffer offer;
  final String loanPurpose;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 680;
          final metrics = [
            RateMetric('Cost', '${offer.effectiveCost.toStringAsFixed(2)}%'),
            RateMetric('EMI', '${money(offer.monthlyEmi)}/mo'),
            RateMetric('Rate', '${offer.rate.toStringAsFixed(2)}%'),
            RateMetric('Fee + GST', money(offer.processingFee)),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flex(
                direction: wide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: wide
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: wide ? 190 : null,
                    child: LenderIdentity(provider: offer.provider),
                  ),
                  if (wide) const SizedBox(width: 16),
                  if (wide)
                    Expanded(
                      child: Wrap(
                        spacing: 18,
                        runSpacing: 12,
                        children: [
                          for (final metric in metrics)
                            LenderMetricTile(metric: metric),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: 18,
                      runSpacing: 12,
                      children: [
                        for (final metric in metrics)
                          LenderMetricTile(metric: metric),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  RateChip(offer.provider.loanType),
                  RateChip(offer.provider.resetType),
                  RateChip(loanPurpose),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                offer.provider.notes,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class LenderIdentity extends StatelessWidget {
  const LenderIdentity({required this.provider, super.key});

  final IndianRateProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: provider.color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(provider.icon, color: provider.color),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                provider.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 2),
              Text(
                provider.category,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LenderMetricTile extends StatelessWidget {
  const LenderMetricTile({required this.metric, super.key});

  final RateMetric metric;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            metric.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            metric.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
        ],
      ),
    );
  }
}

class RateChip extends StatelessWidget {
  const RateChip(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
      ),
    );
  }
}

class IndianPreApprovalPanel extends StatelessWidget {
  const IndianPreApprovalPanel({
    required this.loanPurpose,
    required this.loanAmount,
    required this.cibilBand,
    required this.city,
    super.key,
  });

  final String loanPurpose;
  final double loanAmount;
  final String cibilBand;
  final String city;

  @override
  Widget build(BuildContext context) {
    final isTransfer = loanPurpose == 'Balance transfer';
    final steps = isTransfer
        ? const [
            'Existing loan statement and sanction letter',
            'Foreclosure quote from current lender',
            'Property chain documents and latest tax receipt',
            'Income proofs, bank statements, PAN, Aadhaar, and CIBIL consent',
          ]
        : const [
            'Builder or seller property papers',
            'Agreement value, own contribution, and bank statement trail',
            'Salary slips or ITRs with Form 16 / GST returns',
            'PAN, Aadhaar, address proof, and CIBIL consent',
          ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF064D3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isTransfer ? Icons.compare_arrows : Icons.fact_check_outlined,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isTransfer
                      ? 'Balance Transfer Readiness'
                      : 'Home Loan Pre-Approval Readiness',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${money(loanAmount)} request • $cibilBand CIBIL • ${city.trim().isEmpty ? 'India' : city.trim()}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...spaced([
            for (final step in steps) PreApprovalStep(label: step),
          ]),
        ],
      ),
    );
  }
}

class PreApprovalStep extends StatelessWidget {
  const PreApprovalStep({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle, color: Color(0xFFF6C85F), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.92),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class AnnualAmortisationPreview extends StatelessWidget {
  const AnnualAmortisationPreview({required this.rows, super.key});

  final List<calc.AnnualAmortisationRow> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionLabel('Annual Amortisation Schedule'),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('Year')),
              DataColumn(label: Text('Interest')),
              DataColumn(label: Text('Principal')),
              DataColumn(label: Text('Ending balance')),
            ],
            rows: [
              for (final row in rows)
                DataRow(
                  cells: [
                    DataCell(Text('${row.year}')),
                    DataCell(Text(money(row.interest))),
                    DataCell(Text(money(row.principal))),
                    DataCell(Text(money(row.balance))),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class BreakdownPart {
  const BreakdownPart(this.label, this.value, this.color);

  final String label;
  final double value;
  final Color color;
}

enum IndianRateSort { effectiveCost, emi, rate, fees }

class IndianRateProvider {
  const IndianRateProvider({
    required this.name,
    required this.category,
    required this.baseRate,
    required this.processingFeePercent,
    required this.maxProcessingFee,
    required this.loanType,
    required this.resetType,
    required this.notes,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final double baseRate;
  final double processingFeePercent;
  final double maxProcessingFee;
  final String loanType;
  final String resetType;
  final String notes;
  final IconData icon;
  final Color color;
}

class PricedIndianRateOffer {
  const PricedIndianRateOffer({
    required this.provider,
    required this.rate,
    required this.monthlyEmi,
    required this.processingFee,
    required this.effectiveCost,
  });

  factory PricedIndianRateOffer.fromProvider(
    IndianRateProvider provider, {
    required double rateAdjustment,
    required double loanAmount,
    required int years,
  }) {
    final rate = provider.baseRate + rateAdjustment;
    final monthlyEmi = calc.emi(
      principal: loanAmount,
      annualRatePercent: rate,
      years: max(1, years),
    );
    final feeBeforeGst = min(
      loanAmount * provider.processingFeePercent / 100,
      provider.maxProcessingFee,
    ).toDouble();
    final processingFee = feeBeforeGst * 1.18;
    final annualizedFeeCost = loanAmount <= 0
        ? 0.0
        : processingFee / loanAmount / max(1, years) * 100;

    return PricedIndianRateOffer(
      provider: provider,
      rate: rate,
      monthlyEmi: monthlyEmi,
      processingFee: processingFee,
      effectiveCost: rate + annualizedFeeCost,
    );
  }

  final IndianRateProvider provider;
  final double rate;
  final double monthlyEmi;
  final double processingFee;
  final double effectiveCost;
}

class RateMetric {
  const RateMetric(this.label, this.value);

  final String label;
  final String value;
}

const indianRateProviders = [
  IndianRateProvider(
    name: 'SBI Home Loan',
    category: 'Public sector bank',
    baseRate: 7.50,
    processingFeePercent: 0.35,
    maxProcessingFee: 30000,
    loanType: 'Repo-linked floating',
    resetType: 'EBLR / spread',
    notes:
        'Strong fit for salaried buyers, women-borrower concessions, MaxGain option, and large branch coverage.',
    icon: Icons.account_balance,
    color: Color(0xFF1E5EFF),
  ),
  IndianRateProvider(
    name: 'ICICI Bank',
    category: 'Private bank',
    baseRate: 7.50,
    processingFeePercent: 0.50,
    maxProcessingFee: 50000,
    loanType: 'Floating home loan',
    resetType: 'Repo / bank benchmark',
    notes:
        'Useful for fast digital sanction, top-up needs, and balance-transfer conversations.',
    icon: Icons.domain,
    color: Color(0xFFB75C12),
  ),
  IndianRateProvider(
    name: 'HDFC Bank',
    category: 'Private bank / HFC heritage',
    baseRate: 7.90,
    processingFeePercent: 0.50,
    maxProcessingFee: 45000,
    loanType: 'Adjustable rate',
    resetType: 'RPLR / policy linked',
    notes:
        'Common choice for resale property, construction-linked disbursal, and builder projects.',
    icon: Icons.apartment,
    color: Color(0xFF0B5CAD),
  ),
  IndianRateProvider(
    name: 'Bank of Baroda',
    category: 'Public sector bank',
    baseRate: 7.60,
    processingFeePercent: 0.40,
    maxProcessingFee: 30000,
    loanType: 'Floating home loan',
    resetType: 'Repo-linked',
    notes:
        'Competitive PSU option for purchase, takeover, and salaried government profiles.',
    icon: Icons.assured_workload_outlined,
    color: Color(0xFFD92755),
  ),
  IndianRateProvider(
    name: 'Axis Bank',
    category: 'Private bank',
    baseRate: 8.35,
    processingFeePercent: 0.50,
    maxProcessingFee: 50000,
    loanType: 'Floating home loan',
    resetType: 'Repo + spread',
    notes:
        'Works well for higher-ticket urban properties and balance-transfer evaluations.',
    icon: Icons.business_center_outlined,
    color: Color(0xFF6D3FD1),
  ),
];

class SipMarketPanel extends StatelessWidget {
  const SipMarketPanel({this.title = 'Trending SIP Watchlist', super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return MarketDesk(
      title: title,
      subtitle: 'Popular long-term SIP categories and scheme styles to compare',
      icon: Icons.trending_up,
      highlight: 'Equity SIPs',
      footer:
          'Indicative watchlist only. Mutual fund schemes are not guaranteed return products; compare risk, expense ratio, rolling performance, portfolio overlap, and your goal horizon before investing.',
      children: [
        for (final item in sipWatchlist) SipWatchCard(item: item),
      ],
    );
  }
}

class FdRatePanel extends StatelessWidget {
  const FdRatePanel({
    required this.amount,
    required this.years,
    super.key,
  });

  final double amount;
  final int years;

  @override
  Widget build(BuildContext context) {
    final sorted = [...fdRateProviders]
      ..sort((a, b) => b.rate.compareTo(a.rate));
    final best = sorted.first;

    return MarketDesk(
      title: 'Indian FD Rate Desk',
      subtitle: 'Compare indicative bank FD rates and maturity estimates',
      icon: Icons.savings_outlined,
      highlight: '${best.rate.toStringAsFixed(2)}% top shown',
      footer:
          'Rates are indicative public snapshots for regular deposits and can change by amount, tenure, payout type, senior-citizen status, and bank campaign windows. Verify on the bank site before booking.',
      children: [
        for (final provider in sorted)
          FdRateCard(provider: provider, amount: amount, years: years),
      ],
    );
  }
}

class LowInterestLoanPanel extends StatelessWidget {
  const LowInterestLoanPanel({
    required this.loanAmount,
    required this.years,
    this.title = 'Low Interest Loan Desk',
    super.key,
  });

  final double loanAmount;
  final int years;
  final String title;

  @override
  Widget build(BuildContext context) {
    final offers = [
      for (final provider in indianRateProviders)
        PricedIndianRateOffer.fromProvider(
          provider,
          rateAdjustment: 0.10,
          loanAmount: loanAmount,
          years: max(1, years),
        ),
    ]..sort((a, b) => a.rate.compareTo(b.rate));
    final best = offers.first;

    return MarketDesk(
      title: title,
      subtitle: 'Banks and HFCs ordered by indicative starting rate',
      icon: Icons.account_balance,
      highlight: '${best.rate.toStringAsFixed(2)}% onwards',
      footer:
          'Indicative rows only. Final loan rates depend on CIBIL, income, property, employer profile, loan amount, LTV, fees, insurance, and sanction terms.',
      children: [
        for (final offer in offers)
          LoanRateMiniCard(offer: offer, years: max(1, years)),
      ],
    );
  }
}

class MarketDesk extends StatefulWidget {
  const MarketDesk({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.highlight,
    required this.children,
    required this.footer,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final String highlight;
  final List<Widget> children;
  final String footer;

  @override
  State<MarketDesk> createState() => _MarketDeskState();
}

class _MarketDeskState extends State<MarketDesk> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FCFF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => isExpanded = !isExpanded),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        widget.icon,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SectionLabel(widget.title),
                          const SizedBox(height: 4),
                          Text(
                            widget.subtitle,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.highlight,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...spaced(widget.children),
                  const SizedBox(height: 12),
                  Text(
                    widget.footer,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
            sizeCurve: Curves.easeOutCubic,
          ),
          if (!isExpanded) ...[
            const SizedBox(height: 8),
            Text(
              'Tap to view offers and comparison details',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}

class SipWatchCard extends StatelessWidget {
  const SipWatchCard({required this.item, super.key});

  final SipWatchItem item;

  @override
  Widget build(BuildContext context) {
    return MarketRowCard(
      color: item.color,
      icon: item.icon,
      title: item.name,
      subtitle: item.category,
      metrics: [
        RateMetric('Style', item.style),
        RateMetric('Risk', item.risk),
        RateMetric('Min SIP', item.minSip),
      ],
      chips: [item.horizon, item.taxTreatment],
      note: item.notes,
    );
  }
}

class FdRateCard extends StatelessWidget {
  const FdRateCard({
    required this.provider,
    required this.amount,
    required this.years,
    super.key,
  });

  final FdRateProvider provider;
  final double amount;
  final int years;

  @override
  Widget build(BuildContext context) {
    final maturity = calc.futureValueLumpsum(
      principal: amount,
      annualRatePercent: provider.rate,
      years: max(1, years),
      compoundsPerYear: 4,
    );

    return MarketRowCard(
      color: provider.color,
      icon: Icons.account_balance,
      title: provider.name,
      subtitle: provider.tenure,
      metrics: [
        RateMetric('Rate', '${provider.rate.toStringAsFixed(2)}%'),
        RateMetric('Maturity', money(maturity)),
        RateMetric('Senior+', provider.seniorCitizenAddOn),
      ],
      chips: [provider.payout, 'DICGC eligible bank'],
      note: provider.notes,
    );
  }
}

class LoanRateMiniCard extends StatelessWidget {
  const LoanRateMiniCard({
    required this.offer,
    required this.years,
    super.key,
  });

  final PricedIndianRateOffer offer;
  final int years;

  @override
  Widget build(BuildContext context) {
    return MarketRowCard(
      color: offer.provider.color,
      icon: offer.provider.icon,
      title: offer.provider.name,
      subtitle: offer.provider.category,
      metrics: [
        RateMetric('Rate', '${offer.rate.toStringAsFixed(2)}%'),
        RateMetric('EMI', '${money(offer.monthlyEmi)}/mo'),
        RateMetric('Fee + GST', money(offer.processingFee)),
      ],
      chips: [offer.provider.loanType, '$years years'],
      note: offer.provider.notes,
    );
  }
}

class MarketRowCard extends StatelessWidget {
  const MarketRowCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.metrics,
    required this.chips,
    required this.note,
    super.key,
  });

  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<RateMetric> metrics;
  final List<String> chips;
  final String note;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth > 680;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flex(
                direction: wide ? Axis.horizontal : Axis.vertical,
                crossAxisAlignment: wide
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: wide ? 210 : null,
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(icon, color: color),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                subtitle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (wide) const SizedBox(width: 16),
                  if (wide)
                    Expanded(
                      child: Wrap(
                        spacing: 18,
                        runSpacing: 12,
                        children: [
                          for (final metric in metrics)
                            LenderMetricTile(metric: metric),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: 18,
                      runSpacing: 12,
                      children: [
                        for (final metric in metrics)
                          LenderMetricTile(metric: metric),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [for (final chip in chips) RateChip(chip)],
              ),
              const SizedBox(height: 12),
              Text(note, style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}

class SipWatchItem {
  const SipWatchItem({
    required this.name,
    required this.category,
    required this.style,
    required this.risk,
    required this.minSip,
    required this.horizon,
    required this.taxTreatment,
    required this.notes,
    required this.icon,
    required this.color,
  });

  final String name;
  final String category;
  final String style;
  final String risk;
  final String minSip;
  final String horizon;
  final String taxTreatment;
  final String notes;
  final IconData icon;
  final Color color;
}

class FdRateProvider {
  const FdRateProvider({
    required this.name,
    required this.rate,
    required this.tenure,
    required this.payout,
    required this.seniorCitizenAddOn,
    required this.notes,
    required this.color,
  });

  final String name;
  final double rate;
  final String tenure;
  final String payout;
  final String seniorCitizenAddOn;
  final String notes;
  final Color color;
}

const sipWatchlist = [
  SipWatchItem(
    name: 'Parag Parikh Flexi Cap',
    category: 'Flexi cap equity',
    style: 'Diversified',
    risk: 'Very high',
    minSip: 'INR 1,000',
    horizon: '7+ years',
    taxTreatment: 'Equity tax',
    notes:
        'Popular for diversified large, mid, and overseas exposure; compare current portfolio limits, expense ratio, and overlap before adding.',
    icon: Icons.auto_graph,
    color: Color(0xFF0B5CAD),
  ),
  SipWatchItem(
    name: 'Nippon India Large Cap',
    category: 'Large cap equity',
    style: 'Core equity',
    risk: 'Very high',
    minSip: 'INR 100',
    horizon: '5+ years',
    taxTreatment: 'Equity tax',
    notes:
        'Large-cap option for investors who want relatively established companies while still accepting equity volatility.',
    icon: Icons.domain,
    color: Color(0xFF169B62),
  ),
  SipWatchItem(
    name: 'HDFC Mid-Cap Opportunities',
    category: 'Mid cap equity',
    style: 'Growth',
    risk: 'Very high',
    minSip: 'INR 100',
    horizon: '7+ years',
    taxTreatment: 'Equity tax',
    notes:
        'Mid-cap exposure can compound well but usually has sharper drawdowns; best compared after checking allocation and fund size.',
    icon: Icons.stacked_line_chart,
    color: Color(0xFFD92755),
  ),
  SipWatchItem(
    name: 'ICICI Prudential Value Discovery',
    category: 'Value equity',
    style: 'Value',
    risk: 'Very high',
    minSip: 'INR 100',
    horizon: '7+ years',
    taxTreatment: 'Equity tax',
    notes:
        'Useful watchlist candidate for valuation-led equity allocation; performance can lag growth cycles.',
    icon: Icons.saved_search,
    color: Color(0xFF6D3FD1),
  ),
];

const fdRateProviders = [
  FdRateProvider(
    name: 'ICICI Bank FD',
    rate: 6.50,
    tenure: '3 years 1 day to 10 years',
    payout: 'Cumulative / payout',
    seniorCitizenAddOn: '+0.50%',
    notes:
        'Private-bank FD option with online booking and sweep features; check exact slab before booking.',
    color: Color(0xFFB75C12),
  ),
  FdRateProvider(
    name: 'Bank of Baroda FD',
    rate: 6.50,
    tenure: 'Medium-term slabs',
    payout: 'Cumulative / payout',
    seniorCitizenAddOn: '+0.50%',
    notes:
        'PSU bank option to compare for conservative deposits and branch-led servicing.',
    color: Color(0xFFD92755),
  ),
  FdRateProvider(
    name: 'SBI Term Deposit',
    rate: 6.45,
    tenure: 'Popular retail tenures',
    payout: 'Cumulative / payout',
    seniorCitizenAddOn: '+0.50%',
    notes:
        'Large PSU bank coverage; rates differ by tenor and special schemes.',
    color: Color(0xFF1E5EFF),
  ),
  FdRateProvider(
    name: 'HDFC Bank FD',
    rate: 6.35,
    tenure: '3 years 1 day to 5 years',
    payout: 'Cumulative / payout',
    seniorCitizenAddOn: '+0.50%',
    notes:
        'Useful private-bank comparator for digital account holders and renewal planning.',
    color: Color(0xFF0B5CAD),
  ),
  FdRateProvider(
    name: 'Axis Bank FD',
    rate: 6.35,
    tenure: 'Selected retail tenures',
    payout: 'Cumulative / payout',
    seniorCitizenAddOn: '+0.50%',
    notes:
        'Compare against your savings-bank relationship, penalty rules, and payout preference.',
    color: Color(0xFF6D3FD1),
  ),
];

class AmortisationPreview extends StatelessWidget {
  const AmortisationPreview({required this.rows, super.key});

  final List<calc.AmortisationRow> rows;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Month')),
          DataColumn(label: Text('Principal')),
          DataColumn(label: Text('Interest')),
          DataColumn(label: Text('Balance')),
        ],
        rows: [
          for (final row in rows)
            DataRow(
              cells: [
                DataCell(Text('${row.month}')),
                DataCell(Text(money(row.principal))),
                DataCell(Text(money(row.interest))),
                DataCell(Text(money(row.balance))),
              ],
            ),
        ],
      ),
    );
  }
}

class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const slotId = AdSenseSettings.displaySlotId;
    return Container(
      constraints: const BoxConstraints(minHeight: 120),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: adsense.buildAdSenseSlot(
        publisherId: AdSenseSettings.publisherId,
        slotId: slotId,
      ),
    );
  }
}

class FAQSection extends StatelessWidget {
  const FAQSection({required this.faqs, super.key});

  final List<FAQ> faqs;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionLabel('Frequently Asked Questions'),
            const SizedBox(height: 12),
            ...spaced([
              for (final faq in faqs) FAQTile(faq: faq),
            ]),
          ],
        ),
      ),
    );
  }
}

class FAQTile extends StatefulWidget {
  const FAQTile({required this.faq, super.key});

  final FAQ faq;

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: _isExpanded
                ? Theme.of(context).colorScheme.surfaceContainerHighest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isExpanded
                  ? Theme.of(context).colorScheme.outline
                  : Colors.transparent,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 12),
                Text(
                  widget.faq.answer,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        height: 1.5,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class AdPreview extends StatelessWidget {
  const AdPreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF101820),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFF6C85F), width: 1.4),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF6C85F),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                const Icon(Icons.ads_click, color: Color(0xFF101820), size: 18),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'AdSense Auto ads active. Add display slot ID for this banner.',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'WEB',
            style: TextStyle(
                color: Color(0xFFF6C85F), fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class AffiliatePanel extends StatelessWidget {
  const AffiliatePanel({required this.offer, super.key});

  final AffiliateOffer offer;

  @override
  Widget build(BuildContext context) {
    final hasUrl = offer.url != null && offer.url!.trim().isNotEmpty;
    if (!AffiliateSettings.enabled || !hasUrl) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: offer.color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: offer.color.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: offer.color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(offer.icon, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF101820),
                          ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      hasUrl
                          ? 'Affiliate link connected'
                          : 'Affiliate slot ready',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: offer.color,
                            fontWeight: FontWeight.w900,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            offer.subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF263238),
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: offer.color,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => _openOffer(context),
            icon: Icon(hasUrl ? Icons.open_in_new : Icons.link),
            label: Text(hasUrl ? offer.buttonLabel : 'Add affiliate URL'),
          ),
        ],
      ),
    );
  }

  Future<void> _openOffer(BuildContext context) async {
    final rawUrl = offer.url?.trim();
    if (rawUrl == null || rawUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add your approved affiliate URL in AffiliateLinks.'),
        ),
      );
      return;
    }

    final uri = Uri.tryParse(rawUrl);
    if (uri == null ||
        !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open affiliate link.')),
      );
    }
  }
}

class MoneyField extends StatelessWidget {
  const MoneyField({
    required this.label,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return NumberField(
      label: label,
      controller: controller,
      onChanged: onChanged,
      prefix: 'INR',
    );
  }
}

class PercentField extends StatelessWidget {
  const PercentField({
    required this.label,
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return NumberField(
      label: label,
      controller: controller,
      onChanged: onChanged,
      suffix: '%',
    );
  }
}

class NumberField extends StatelessWidget {
  const NumberField({
    required this.label,
    required this.controller,
    required this.onChanged,
    this.prefix,
    this.suffix,
    super.key,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? prefix;
  final String? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix == null ? null : '$prefix ',
        suffixText: suffix,
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
    );
  }
}

class FAQ {
  const FAQ({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FinanceModule {
  const FinanceModule({
    required this.id,
    required this.title,
    required this.shortTitle,
    required this.subtitle,
    required this.icon,
    required this.accent,
    this.onAccent = Colors.white,
    required this.builder,
    this.faqs = const [],
  });

  final String id;
  final String title;
  final String shortTitle;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final Color onAccent;
  final WidgetBuilder builder;
  final List<FAQ> faqs;
}

class ResultMetric {
  const ResultMetric(this.label, this.value);

  final String label;
  final String value;
}

enum SimpleKind { lumpsum, ppf, cagr, inflation, gst }

final modules = <FinanceModule>[
  FinanceModule(
    id: 'home',
    title: 'Home dashboard',
    shortTitle: 'Home',
    subtitle: 'All calculators',
    icon: Icons.home_outlined,
    accent: const Color(0xFF064D3E),
    builder: (_) => const SizedBox.shrink(),
  ),
  FinanceModule(
    id: 'sip',
    title: 'SIP calculator',
    shortTitle: 'SIP',
    subtitle: 'Monthly SIP to maturity and wealth gain',
    icon: Icons.trending_up,
    accent: const Color(0xFF087A5D),
    builder: (_) => const SipCalculator(),
    faqs: [
      const FAQ(
        question: 'What is SIP?',
        answer:
            'Systematic Investment Plan (SIP) is a method of investing a fixed amount regularly (usually monthly) in mutual funds. It helps build wealth over time through the power of compounding and averaging.',
      ),
      const FAQ(
        question: 'How much returns can I expect from SIP?',
        answer:
            'Returns depend on the type of fund and market conditions. Equity SIPs typically offer 12-15% average returns over the long term, while debt funds offer 6-8%. Past performance doesn\'t guarantee future results.',
      ),
      const FAQ(
        question: 'Can I stop my SIP anytime?',
        answer:
            'Yes, you can stop, pause, or modify your SIP anytime without penalty. However, to benefit from compounding, it\'s recommended to continue for at least 5-10 years.',
      ),
      const FAQ(
        question: 'How is SIP better than lump sum investment?',
        answer:
            'SIP averages out market volatility through regular investments, reducing the risk of entering at market peaks. Lump sum investing works better if you have a large corpus and market timing is favorable.',
      ),
    ],
  ),
  FinanceModule(
    id: 'emi',
    title: 'EMI calculator',
    shortTitle: 'EMI',
    subtitle: 'EMI, total interest, and amortisation preview',
    icon: Icons.credit_card,
    accent: const Color(0xFF1E5EFF),
    builder: (_) => const EmiCalculator(),
    faqs: [
      const FAQ(
        question: 'What is EMI?',
        answer:
            'EMI (Equated Monthly Installment) is the fixed amount you pay each month to repay a loan. It includes both principal (loan amount) and interest components.',
      ),
      const FAQ(
        question: 'How is EMI calculated?',
        answer:
            'EMI is calculated using the formula: EMI = P × r × (1 + r)^n / [(1 + r)^n - 1], where P is principal, r is monthly interest rate, and n is number of months.',
      ),
      const FAQ(
        question: 'Why does my EMI amount remain the same?',
        answer:
            'EMI is equated (fixed) by design. While it remains constant, the interest portion decreases over time and principal portion increases, until the loan is fully paid.',
      ),
      const FAQ(
        question: 'Can I pay extra to reduce my loan tenure?',
        answer:
            'Yes, most lenders allow prepayment or additional payments. This reduces your principal faster, saving significantly on interest and reducing the loan tenure.',
      ),
      const FAQ(
        question: 'What is the amortization schedule?',
        answer:
            'The amortization schedule shows how each EMI payment is split between principal and interest. Early payments are mostly interest, while later payments are mostly principal.',
      ),
    ],
  ),
  FinanceModule(
    id: 'mortgage',
    title: 'Mortgage calculator',
    shortTitle: 'Mortgage',
    subtitle: 'Home loan payment with taxes, insurance, and schedule',
    icon: Icons.house_outlined,
    accent: const Color(0xFF0B5CAD),
    builder: (_) => const MortgageCalculator(),
    faqs: [
      const FAQ(
        question: 'What does the mortgage payment include?',
        answer:
            'The main mortgage payment is principal plus interest. This calculator can also add property tax, home insurance, HOA, and other monthly costs to estimate the full housing outflow.',
      ),
      const FAQ(
        question: 'How does the down payment affect my loan?',
        answer:
            'A higher down payment reduces the loan amount, which lowers the monthly payment and the total interest paid over the loan tenure.',
      ),
      const FAQ(
        question: 'What is an amortisation schedule?',
        answer:
            'An amortisation schedule shows how each year of payments is split between interest and principal, and how the remaining loan balance falls over time.',
      ),
    ],
  ),
  FinanceModule(
    id: 'lumpsum',
    title: 'Lumpsum / FD',
    shortTitle: 'FD',
    subtitle: 'One-time investment future value',
    icon: Icons.savings_outlined,
    accent: const Color(0xFFB75C12),
    builder: (_) => const SimpleCalculator(kind: SimpleKind.lumpsum),
    faqs: [
      const FAQ(
        question: 'What is the difference between FD and Lumpsum investment?',
        answer:
            'Fixed Deposit (FD) offers guaranteed fixed returns from banks with lower risk. Lumpsum investment in mutual funds or stocks offers higher potential returns but with more volatility and risk.',
      ),
      const FAQ(
        question: 'What is the current FD interest rate in India?',
        answer:
            'Bank FD rates typically range from 5-7.5% depending on the bank and tenure. Post office FDs offer slightly lower rates. Rates keep changing based on RBI policy.',
      ),
      const FAQ(
        question: 'Is FD interest taxed?',
        answer:
            'Yes, FD interest is added to your income and taxed at your applicable tax rate. Senior citizens can claim TDS relief if their income is below the limit.',
      ),
      const FAQ(
        question: 'Can I break my FD before maturity?',
        answer:
            'Yes, most banks allow premature withdrawal with a penalty. The penalty typically reduces your interest by 0.5-1%. Check your bank\'s terms before investing.',
      ),
    ],
  ),
  FinanceModule(
    id: 'ppf',
    title: 'PPF calculator',
    shortTitle: 'PPF',
    subtitle: '15-year corpus with tax-saving note',
    icon: Icons.account_balance_outlined,
    accent: const Color(0xFF6D3FD1),
    builder: (_) => const SimpleCalculator(kind: SimpleKind.ppf),
    faqs: [
      const FAQ(
        question: 'What is PPF (Public Provident Fund)?',
        answer:
            'PPF is a long-term savings scheme offered by the Indian government providing guaranteed returns. It has a 15-year maturity period with tax-free returns and contributions eligible for Section 80C deduction.',
      ),
      const FAQ(
        question: 'What is the current PPF interest rate?',
        answer:
            'PPF interest rate is currently 7.1% per annum (varies quarterly). It\'s compounded annually. The rate is declared by the Ministry of Finance every quarter based on government securities yield.',
      ),
      const FAQ(
        question: 'What is the maximum annual contribution to PPF?',
        answer:
            'You can contribute a maximum of INR 1.5 lakhs per financial year to PPF. Minimum annual contribution is INR 500. You must contribute in multiples of INR 50.',
      ),
      const FAQ(
        question: 'Can I withdraw from PPF before 15 years?',
        answer:
            'Partial withdrawal is allowed from the 7th financial year up to 50% of the balance or previous year balance. Full withdrawal is available after 15 years or after 7 years from the date of opening.',
      ),
      const FAQ(
        question: 'Is PPF suitable for long-term planning?',
        answer:
            'Yes, PPF is ideal for long-term financial goals like children\'s education or retirement. The guaranteed returns, tax benefits, and government backing make it a safe investment option.',
      ),
    ],
  ),
  FinanceModule(
    id: 'cagr',
    title: 'CAGR calculator',
    shortTitle: 'CAGR',
    subtitle: 'Initial to final value growth rate',
    icon: Icons.show_chart,
    accent: const Color(0xFF0F766E),
    builder: (_) => const SimpleCalculator(kind: SimpleKind.cagr),
    faqs: [
      const FAQ(
        question: 'What is CAGR?',
        answer:
            'CAGR (Compound Annual Growth Rate) represents the average annual growth rate of an investment over multiple years, accounting for compounding. It\'s useful to compare growth across different time periods.',
      ),
      const FAQ(
        question: 'How is CAGR calculated?',
        answer:
            'CAGR = (Final Value / Initial Value)^(1/Number of Years) - 1. It shows the year-on-year growth rate as if the investment grew at a constant rate.',
      ),
      const FAQ(
        question: 'Is CAGR the same as average return?',
        answer:
            'No, CAGR accounts for compounding while average return doesn\'t. CAGR is more accurate for comparing investments over different time periods.',
      ),
      const FAQ(
        question: 'Why should I use CAGR to evaluate investments?',
        answer:
            'CAGR helps you compare investment performance fairly across different time periods and investment types. A higher CAGR indicates better growth, but also consider volatility and risk.',
      ),
    ],
  ),
  FinanceModule(
    id: 'inflation',
    title: 'Inflation calculator',
    shortTitle: 'Infl.',
    subtitle: 'Today amount to future needed value',
    icon: Icons.price_change_outlined,
    accent: const Color(0xFFCA8A04),
    onAccent: const Color(0xFF17120A),
    builder: (_) => const SimpleCalculator(kind: SimpleKind.inflation),
    faqs: [
      const FAQ(
        question: 'What is inflation?',
        answer:
            'Inflation is the rate at which the general price level of goods and services rises, reducing your money\'s purchasing power. It\'s usually expressed as an annual percentage.',
      ),
      const FAQ(
        question: 'How does inflation affect my savings?',
        answer:
            'If inflation is 6% and your savings earn 4%, you\'re losing 2% in real purchasing power yearly. This is why you need investments that return more than inflation to preserve wealth.',
      ),
      const FAQ(
        question: 'What is India\'s current inflation rate?',
        answer:
            'India\'s inflation rate typically ranges from 4-7% annually. The RBI targets an inflation rate around 4%. You can check the latest rate on the RBI website.',
      ),
      const FAQ(
        question: 'How should I plan for inflation?',
        answer:
            'Invest in assets that can beat inflation like equities, real estate, or inflation-indexed bonds. Adjust your retirement corpus and goals upward to account for rising costs.',
      ),
    ],
  ),
  FinanceModule(
    id: 'gst',
    title: 'GST calculator',
    shortTitle: 'GST',
    subtitle: 'Add or remove GST with instant split',
    icon: Icons.receipt_long,
    accent: const Color(0xFFD92755),
    builder: (_) => const SimpleCalculator(kind: SimpleKind.gst),
    faqs: [
      const FAQ(
        question: 'What is GST?',
        answer:
            'GST (Goods and Services Tax) is a unified indirect tax in India applied on most goods and services. It replaced multiple taxes like VAT, excise, and service tax.',
      ),
      const FAQ(
        question: 'What are the different GST rates in India?',
        answer:
            'GST rates are 5%, 12%, 18%, and 28% depending on the product or service category. Essential items are often 5%, while luxury goods are 28%. Some items are GST-exempt.',
      ),
      const FAQ(
        question: 'Do I need to pay GST if I\'m a small business?',
        answer:
            'GST registration is mandatory if your annual turnover exceeds INR 20 lakhs (INR 10 lakhs for certain states). Unregistered vendors pay GST but cannot claim input tax credit.',
      ),
      const FAQ(
        question: 'Can I claim GST as input tax credit?',
        answer:
            'If you\'re GST-registered and have a valid GST invoice, you can claim input tax credit on business purchases. This reduces your GST liability.',
      ),
      const FAQ(
        question: 'How do I calculate GST on an amount?',
        answer:
            'If GST is not included: Final Amount = Base Amount + (Base Amount × GST%). If GST is included: Base Amount = Final Amount / (1 + GST%). This calculator does both.',
      ),
    ],
  ),
  FinanceModule(
    id: 'loan_compare',
    title: 'Loan compare',
    shortTitle: 'Compare',
    subtitle: 'Side-by-side EMI and total cost comparison',
    icon: Icons.compare_arrows,
    accent: const Color(0xFF0B5CAD),
    builder: (_) => const LoanCompareCalculator(),
    faqs: [
      const FAQ(
        question: 'Why should I compare loans before taking?',
        answer:
            'Comparing loans helps you find the best interest rates and lowest total cost. A 0.5% rate difference can save you lakhs over the loan tenure.',
      ),
      const FAQ(
        question: 'What factors should I consider when comparing loans?',
        answer:
            'Compare interest rates, tenure options, processing fees, prepayment penalties, and hidden charges. Also check eligibility criteria and documents required.',
      ),
      const FAQ(
        question: 'Is a lower EMI always better?',
        answer:
            'Not always. A lower EMI might mean a longer tenure, resulting in higher total interest paid. Compare the total cost over the entire loan period.',
      ),
      const FAQ(
        question: 'Can I negotiate loan interest rates?',
        answer:
            'Yes, banks may negotiate rates based on your credit score, income, and existing relationship. Compare offers and use competitive quotes for leverage.',
      ),
      const FAQ(
        question: 'What is prepayment and its benefit?',
        answer:
            'Prepayment allows you to pay part or full loan before tenure ends. It reduces your interest liability and loan tenure but some lenders charge prepayment penalty.',
      ),
    ],
  ),
  FinanceModule(
    id: 'retirement',
    title: 'Retirement planner',
    shortTitle: 'Retire',
    subtitle: 'Corpus needed and monthly SIP required',
    icon: Icons.elderly,
    accent: const Color(0xFF7C2D12),
    builder: (_) => const RetirementCalculator(),
    faqs: [
      const FAQ(
        question: 'How much corpus do I need for retirement?',
        answer:
            'A common rule of thumb is to save 25 times your annual expenses. This assumes 4% annual withdrawal. Adjust based on your lifestyle and life expectancy.',
      ),
      const FAQ(
        question:
            'What\'s the difference between pre-retirement and post-retirement returns?',
        answer:
            'Pre-retirement returns (from equity) are higher due to more risk. Post-retirement returns (from stable investments) are lower but safer to preserve capital.',
      ),
      const FAQ(
        question: 'How does inflation affect my retirement planning?',
        answer:
            'Inflation reduces purchasing power. A 6% inflation over 25 years means your current INR 50,000 monthly expense becomes INR 2,13,000. Plan accordingly.',
      ),
      const FAQ(
        question: 'When should I start saving for retirement?',
        answer:
            'The earlier you start, the better. Starting at 25 requires lower monthly SIP than starting at 35, due to compounding over a longer period.',
      ),
      const FAQ(
        question: 'What are good post-retirement investment options?',
        answer:
            'Consider low-risk options like fixed deposits, government securities, bonds, or dividend-paying stocks. A balanced portfolio is safer than single asset type.',
      ),
    ],
  ),
  FinanceModule(
    id: 'step_up_sip',
    title: 'Step-up SIP',
    shortTitle: 'Step-up',
    subtitle: 'Annual SIP increase and extra corpus',
    icon: Icons.stacked_line_chart,
    accent: const Color(0xFF169B62),
    builder: (_) => const StepUpSipCalculator(),
    faqs: [
      const FAQ(
        question: 'What is Step-up SIP?',
        answer:
            'Step-up SIP is a modified SIP where your monthly investment amount increases by a fixed percentage every year. This is ideal if your income grows over time.',
      ),
      const FAQ(
        question: 'How much extra corpus can Step-up SIP create?',
        answer:
            'A Step-up SIP can create 30-50% more corpus compared to regular SIP over 20-25 years, depending on the step-up percentage and investment tenure.',
      ),
      const FAQ(
        question: 'Is Step-up SIP suitable for everyone?',
        answer:
            'Step-up SIP is ideal for young professionals with growing income. It aligns your investments with salary growth, making it easier to maintain without financial strain.',
      ),
      const FAQ(
        question: 'How do I choose the right step-up percentage?',
        answer:
            'Choose a step-up percentage close to your expected annual salary growth (usually 10-20%). Starting with your expected next year\'s income gives a realistic plan.',
      ),
      const FAQ(
        question: 'Can I modify my Step-up SIP?',
        answer:
            'Most mutual fund companies allow you to modify your SIP amount or step-up percentage. Contact your fund house or use their online platform to make changes.',
      ),
    ],
  ),
  FinanceModule(
    id: 'loan_eligibility',
    title: 'Loan eligibility',
    shortTitle: 'Eligible',
    subtitle: 'Salary and obligations to maximum loan',
    icon: Icons.home_work_outlined,
    accent: const Color(0xFF263238),
    builder: (_) => const EligibilityCalculator(),
    faqs: [
      const FAQ(
        question: 'What is FOIR and how does it affect loan eligibility?',
        answer:
            'FOIR (Fixed Obligation to Income Ratio) is the percentage of your monthly income that can go towards all loan EMIs. Most banks use 50% FOIR limit, meaning your total EMIs shouldn\'t exceed 50% of income.',
      ),
      const FAQ(
        question: 'How do banks calculate loan eligibility?',
        answer:
            'Banks calculate maximum affordable EMI based on your income and FOIR limit, then determine the loan amount at your requested interest rate and tenure.',
      ),
      const FAQ(
        question: 'What factors improve my loan eligibility?',
        answer:
            'Higher income, lower existing EMIs, better credit score, stable employment, and lower requested interest rates all improve your loan eligibility amount.',
      ),
      const FAQ(
        question: 'Can I increase my eligibility?',
        answer:
            'Yes, you can increase eligibility by: 1) Increasing income (co-applicant helps), 2) Reducing existing EMIs, 3) Requesting longer tenure, 4) Improving credit score.',
      ),
      const FAQ(
        question:
            'What\'s the difference between eligible loan and sanctioned loan?',
        answer:
            'Eligible loan is the maximum based on income. Sanctioned loan is what the bank actually approves after checking credit history, collateral, and other factors.',
      ),
    ],
  ),
];

List<Widget> spaced(List<Widget> children) {
  return [
    for (var i = 0; i < children.length; i++) ...[
      children[i],
      if (i != children.length - 1) const SizedBox(height: 12),
    ],
  ];
}

double value(TextEditingController controller) {
  return double.tryParse(controller.text.replaceAll(',', '').trim()) ?? 0;
}

List<ChartItem> positiveItems(List<ChartItem> items) {
  return [
    for (final item in items)
      if (item.value.isFinite && item.value > 0) item,
  ];
}

List<double> projectionPoints({
  required int years,
  required double Function(int year) valueAtYear,
}) {
  final safeYears = max(1, years);
  final step = max(1, (safeYears / 8).ceil());
  final points = <double>[];

  for (var year = 0; year <= safeYears; year += step) {
    points.add(valueAtYear(year));
  }
  if (points.isEmpty || points.last != valueAtYear(safeYears)) {
    points.add(valueAtYear(safeYears));
  }

  return points;
}

List<double> amortisationBalancePoints({
  required double principal,
  required double annualRatePercent,
  required int years,
}) {
  final schedule = calc.annualAmortisation(
    principal: principal,
    annualRatePercent: annualRatePercent,
    years: max(1, years),
    maxRows: 40,
  );
  return [
    principal,
    for (final row in schedule) row.balance,
  ];
}

String money(double amount) {
  if (amount.isNaN || amount.isInfinite) return 'INR 0';
  final sign = amount < 0 ? '-' : '';
  final absAmount = amount.abs();
  if (absAmount >= 10000000) {
    return '${sign}INR ${(absAmount / 10000000).toStringAsFixed(2)} Cr';
  }
  if (absAmount >= 100000) {
    return '${sign}INR ${(absAmount / 100000).toStringAsFixed(2)} L';
  }
  return '${sign}INR ${absAmount.round()}';
}

String percentOf(double part, double total) {
  if (!part.isFinite || !total.isFinite || total == 0) return '0%';
  return '${(part / total * 100).clamp(0, 999).toStringAsFixed(1)}%';
}
