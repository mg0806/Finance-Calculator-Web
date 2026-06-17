import 'package:flutter_test/flutter_test.dart';
import 'package:finance_calculator/calculators.dart';

void main() {
  test('emi returns expected monthly payment', () {
    final payment = emi(
      principal: 1000000,
      annualRatePercent: 9,
      years: 20,
    );

    expect(payment, closeTo(8997, 2));
  });

  test('step-up SIP grows more than flat SIP', () {
    final flat = futureValueSip(
      monthlyInvestment: 5000,
      annualReturnPercent: 12,
      years: 15,
    );
    final stepped = futureValueStepUpSip(
      monthlyInvestment: 5000,
      annualReturnPercent: 12,
      annualStepUpPercent: 10,
      years: 15,
    );

    expect(stepped, greaterThan(flat));
  });

  test('required step-up SIP reaches target corpus', () {
    final sip = requiredStepUpSipForGoal(
      goal: 5000000,
      annualReturnPercent: 11.5,
      annualStepUpPercent: 10,
      years: 15,
    );
    final corpus = futureValueStepUpSip(
      monthlyInvestment: sip,
      annualReturnPercent: 11.5,
      annualStepUpPercent: 10,
      years: 15,
    );

    expect(corpus, closeTo(5000000, 1));
  });

  test('sip yearly breakdown tracks invested corpus and real corpus', () {
    final rows = sipYearBreakdown(
      monthlyInvestment: 10000,
      annualReturnPercent: 12,
      annualStepUpPercent: 10,
      years: 3,
      inflationPercent: 6,
    );

    expect(rows, hasLength(3));
    expect(rows.last.invested, closeTo(397200, 0.01));
    expect(rows.last.corpus, greaterThan(rows.last.invested));
    expect(rows.last.realCorpus, lessThan(rows.last.corpus));
  });

  test('gst can remove included tax', () {
    final result = gst(amount: 1180, ratePercent: 18, includesGst: true);

    expect(result.baseAmount, closeTo(1000, 0.01));
    expect(result.gstAmount, closeTo(180, 0.01));
  });

  test('mortgage includes payment and ownership costs', () {
    final result = mortgage(
      homePrice: 4000000,
      downPaymentPercent: 20,
      annualRatePercent: 8.5,
      years: 20,
      annualPropertyTaxPercent: 1.2,
      annualHomeInsurance: 24000,
      monthlyHoa: 0,
      monthlyOtherCosts: 3000,
    );

    expect(result.loanAmount, 3200000);
    expect(result.principalAndInterest, closeTo(27770, 2));
    expect(result.monthlyTotal, closeTo(36770, 2));
  });
}
