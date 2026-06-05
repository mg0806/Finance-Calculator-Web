import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class RetirementAt40Page extends StatelessWidget {
  const RetirementAt40Page({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[4],
      intro:
          'Retiring at 40 is less about escaping work and more about buying financial choice. The math has to be honest.',
      ctas: const [
        CalculatorCtaBanner(
            title: 'Retirement Calculator', route: '/retirement-calculator')
      ],
      blocks: const [
        ArticleBlock.heading('Why 40?'),
        ArticleBlock.paragraph(
            'A 40-year retirement target compresses the earning window and extends the withdrawal window. That means savings rate, inflation assumptions, and post-retirement returns matter a lot.'),
        ArticleBlock.heading('The Corpus Formula'),
        ArticleBlock.paragraph(
            'A simple starting point is annual expenses multiplied by 25 to 33. If annual expenses are INR 12 lakh, the rough corpus range is INR 3 crore to INR 4 crore before buffers.'),
        ArticleBlock.heading('Monthly SIP Needed'),
        ArticleBlock.paragraph(
            'The monthly SIP depends on current age, target corpus, return assumption, and annual step-up. Starting at 25 gives compounding 15 years; starting at 33 leaves only 7 years and requires a much higher amount.'),
        ArticleBlock.bullets([
          ['Keep lifestyle inflation slower than income growth.'],
          ['Build emergency and health insurance buffers separately.'],
          [
            'Avoid counting primary residence as retirement income unless you plan to monetize it.'
          ]
        ]),
      ],
    );
  }
}
