import 'package:flutter/material.dart';

import '../../models/article_model.dart';
import '../../widgets/article_page_template.dart';
import '../../widgets/calculator_cta_banner.dart';

class HomeLoanGuidePage extends StatelessWidget {
  const HomeLoanGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ArticlePageTemplate(
      article: articles[3],
      intro:
          'A home loan is usually the largest debt in a household. Good preparation can improve approval chances and reduce total cost.',
      ctas: const [
        CalculatorCtaBanner(
            title: 'Home Loan EMI Calculator', route: '/emi-calculator')
      ],
      blocks: const [
        ArticleBlock.heading('Step-by-Step Flow'),
        ArticleBlock.bullets([
          [
            'Check eligibility using income, current EMIs, credit score, and expected tenure.'
          ],
          [
            'Collect documents: identity proof, address proof, income proof, bank statements, and property papers.'
          ],
          ['Compare fixed, floating, and hybrid rate offers.'],
          [
            'Estimate EMI and keep room for maintenance, insurance, and registration costs.'
          ],
          ['Read prepayment, foreclosure, and reset clauses before signing.']
        ]),
        ArticleBlock.heading('EMI Breakdown'),
        ArticleBlock.paragraph(
            'Each EMI contains principal and interest. Early EMIs are interest-heavy; later EMIs reduce principal faster. This is why prepayments in the early years are powerful.'),
        ArticleBlock.tip(
            'Home loan comparison platforms may be monetized with approved CueLinks affiliate URLs, but users should compare total cost and terms independently.'),
      ],
    );
  }
}
