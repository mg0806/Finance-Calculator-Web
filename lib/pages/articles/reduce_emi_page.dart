import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class ReduceEmiPage extends StatelessWidget {
  const ReduceEmiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[1],
      intro:
          'Your EMI is controlled by three levers: principal, rate, and tenure. Small improvements can save serious money over a home loan.',
      ctas: const [
        CalculatorCtaBanner(title: 'EMI Calculator', route: '/emi-calculator')
      ],
      blocks: const [
        ArticleBlock.heading('7 Ways to Reduce EMI'),
        ArticleBlock.bullets([
          ['Prepay principal whenever you receive a bonus or surplus cash.'],
          [
            'Choose a longer tenure if monthly affordability is the immediate problem.'
          ],
          [
            'Negotiate the interest rate with your existing lender when your credit score improves.'
          ],
          [
            'Consider a balance transfer after comparing processing fees and remaining tenure.'
          ],
          ['Increase down payment before loan disbursal to reduce principal.'],
          ['Avoid unnecessary top-up loans that reset your debt burden.'],
          [
            'Review floating rates periodically instead of ignoring bank notices.'
          ]
        ]),
        ArticleBlock.tip(
            'A lower EMI is useful, but lower total interest is usually the better long-term goal. Compare both before deciding.'),
        ArticleBlock.heading('Balance Transfer Check'),
        ArticleBlock.paragraph(
            'A balance transfer makes sense only when the interest saving is larger than processing fees, legal charges, valuation charges, and the time required to complete paperwork.'),
        ArticleBlock.heading('Final Word'),
        ArticleBlock.paragraph(
            'The cleanest EMI reduction usually comes from a mix of principal prepayment and rate negotiation. Use the calculator before and after every change so you know the real saving.'),
      ],
    );
  }
}
