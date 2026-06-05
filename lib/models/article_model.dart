class ArticleModel {
  const ArticleModel({
    required this.slug,
    required this.title,
    required this.excerpt,
    required this.category,
    required this.readTime,
    required this.route,
    required this.description,
  });

  final String slug;
  final String title;
  final String excerpt;
  final String category;
  final String readTime;
  final String route;
  final String description;
}

const articles = <ArticleModel>[
  ArticleModel(
    slug: 'sip-vs-lumpsum',
    title: 'SIP vs Lump Sum: Which Investment Strategy Wins?',
    excerpt:
        'A practical comparison of disciplined monthly investing and one-time deployment.',
    category: 'SIP',
    readTime: '6 min read',
    route: '/blog/sip-vs-lumpsum',
    description:
        'A practical comparison of SIP vs lump sum investment strategies with calculator examples.',
  ),
  ArticleModel(
    slug: 'how-to-reduce-emi',
    title: '7 Ways to Reduce Your Home Loan EMI',
    excerpt:
        'Simple levers that can reduce monthly pressure and lifetime interest.',
    category: 'Loans',
    readTime: '7 min read',
    route: '/blog/how-to-reduce-emi',
    description:
        'Learn practical ways to reduce your home loan EMI and total interest cost.',
  ),
  ArticleModel(
    slug: 'fd-vs-sip',
    title: 'FD vs SIP: Where Should You Invest in 2025?',
    excerpt:
        'Compare certainty, risk, tax, liquidity, and return expectations.',
    category: 'Investing',
    readTime: '6 min read',
    route: '/blog/fd-vs-sip',
    description:
        'Compare FD and SIP investing in India across returns, risk, liquidity, and tax.',
  ),
  ArticleModel(
    slug: 'home-loan-guide',
    title: 'Home Loan Complete Guide for First-Time Buyers in India',
    excerpt:
        'Eligibility, documents, rates, EMI math, and what to check before signing.',
    category: 'Home Loan',
    readTime: '8 min read',
    route: '/blog/home-loan-guide',
    description:
        'A first-time buyer guide to home loans in India, including eligibility, documents, and EMI planning.',
  ),
  ArticleModel(
    slug: 'retirement-at-40',
    title: 'How to Retire at 40: The Numbers You Need to Know',
    excerpt:
        'Corpus math, monthly SIP targets, inflation, and lifestyle trade-offs.',
    category: 'Retirement',
    readTime: '7 min read',
    route: '/blog/retirement-at-40',
    description:
        'Understand the corpus and monthly investing needed to target retirement at 40.',
  ),
  ArticleModel(
    slug: 'ppf-complete-guide',
    title: 'PPF Complete Guide: Rules, Limits, and Tax Benefits',
    excerpt:
        'Tenure, deposits, tax treatment, withdrawal rules, and planning uses.',
    category: 'PPF',
    readTime: '6 min read',
    route: '/blog/ppf-complete-guide',
    description:
        'PPF rules, limits, tax benefits, and maturity planning explained for Indian savers.',
  ),
  ArticleModel(
    slug: 'cagr-explained',
    title: 'What is CAGR and Why It Matters for Your Investments',
    excerpt:
        'A clean explanation of compound annual growth rate with examples.',
    category: 'CAGR',
    readTime: '5 min read',
    route: '/blog/cagr-explained',
    description:
        'Understand CAGR with a simple formula, examples, and investment comparison use cases.',
  ),
  ArticleModel(
    slug: 'tax-saving-80c',
    title: 'Best Tax-Saving Investments Under Section 80C in 2025',
    excerpt: 'Compare PPF, ELSS, NSC, insurance, and 5-year tax-saving FDs.',
    category: 'Tax',
    readTime: '7 min read',
    route: '/blog/tax-saving-80c',
    description:
        'Compare popular Section 80C tax-saving options in India by lock-in, returns, risk, and limits.',
  ),
];
