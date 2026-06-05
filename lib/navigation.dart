import 'package:flutter/material.dart';

class CalculatorNavItem {
  const CalculatorNavItem({
    required this.title,
    required this.route,
    required this.icon,
    required this.description,
  });

  final String title;
  final String route;
  final IconData icon;
  final String description;
}

const calculatorNavItems = <CalculatorNavItem>[
  CalculatorNavItem(
      title: 'SIP Calculator',
      route: '/sip-calculator',
      icon: Icons.trending_up,
      description: 'Monthly SIP maturity and wealth gain'),
  CalculatorNavItem(
      title: 'EMI Calculator',
      route: '/emi-calculator',
      icon: Icons.credit_card,
      description: 'Loan EMI and total interest'),
  CalculatorNavItem(
      title: 'Loan Calculator',
      route: '/loan-calculator',
      icon: Icons.compare_arrows,
      description: 'Compare loan cost side by side'),
  CalculatorNavItem(
      title: 'FD Calculator',
      route: '/fd-calculator',
      icon: Icons.savings_outlined,
      description: 'One-time deposit future value'),
  CalculatorNavItem(
      title: 'PPF Calculator',
      route: '/ppf-calculator',
      icon: Icons.account_balance_outlined,
      description: '15-year PPF corpus estimate'),
  CalculatorNavItem(
      title: 'GST Calculator',
      route: '/gst-calculator',
      icon: Icons.receipt_long,
      description: 'Add or remove GST instantly'),
  CalculatorNavItem(
      title: 'CAGR Calculator',
      route: '/cagr-calculator',
      icon: Icons.show_chart,
      description: 'Annualized investment growth'),
  CalculatorNavItem(
      title: 'Inflation Calculator',
      route: '/inflation-calculator',
      icon: Icons.price_change_outlined,
      description: 'Future value after inflation'),
  CalculatorNavItem(
      title: 'Retirement Calculator',
      route: '/retirement-calculator',
      icon: Icons.elderly,
      description: 'Corpus and SIP required'),
  CalculatorNavItem(
      title: 'Step-up SIP Calculator',
      route: '/step-up-sip-calculator',
      icon: Icons.stacked_line_chart,
      description: 'Annual SIP increase and extra corpus'),
  CalculatorNavItem(
      title: 'Mortgage Calculator',
      route: '/mortgage-calculator',
      icon: Icons.house_outlined,
      description: 'Home loan payment estimate'),
  CalculatorNavItem(
      title: 'Loan Eligibility Calculator',
      route: '/loan-eligibility-calculator',
      icon: Icons.home_work_outlined,
      description: 'Income to maximum eligible loan'),
];

void goNamed(BuildContext context, String route) {
  final current = ModalRoute.of(context)?.settings.name;
  if (current == route) return;
  Navigator.of(context).pushNamed(route);
}
