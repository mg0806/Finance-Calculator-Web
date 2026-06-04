import 'dart:math';

double monthlyRate(double annualRatePercent) => annualRatePercent / 12 / 100;

double futureValueSip({
  required double monthlyInvestment,
  required double annualReturnPercent,
  required int years,
}) {
  final months = years * 12;
  final rate = monthlyRate(annualReturnPercent);
  if (rate == 0) return monthlyInvestment * months;
  return monthlyInvestment * ((pow(1 + rate, months) - 1) / rate) * (1 + rate);
}

double futureValueStepUpSip({
  required double monthlyInvestment,
  required double annualReturnPercent,
  required double annualStepUpPercent,
  required int years,
}) {
  final rate = monthlyRate(annualReturnPercent);
  var corpus = 0.0;
  var sip = monthlyInvestment;

  for (var year = 0; year < years; year++) {
    for (var month = 0; month < 12; month++) {
      corpus = (corpus + sip) * (1 + rate);
    }
    sip *= 1 + annualStepUpPercent / 100;
  }

  return corpus;
}

double emi({
  required double principal,
  required double annualRatePercent,
  required int years,
}) {
  final months = years * 12;
  final rate = monthlyRate(annualRatePercent);
  if (rate == 0) return principal / months;
  final factor = pow(1 + rate, months);
  return principal * rate * factor / (factor - 1);
}

List<AmortisationRow> amortisation({
  required double principal,
  required double annualRatePercent,
  required int years,
  int maxRows = 12,
}) {
  final payment = emi(
    principal: principal,
    annualRatePercent: annualRatePercent,
    years: years,
  );
  final rate = monthlyRate(annualRatePercent);
  var balance = principal;
  final rows = <AmortisationRow>[];

  for (var month = 1; month <= years * 12 && month <= maxRows; month++) {
    final interest = balance * rate;
    final principalPaid = min(payment - interest, balance);
    balance = max(0, balance - principalPaid);
    rows.add(
      AmortisationRow(
        month: month,
        emi: payment,
        principal: principalPaid,
        interest: interest,
        balance: balance,
      ),
    );
  }

  return rows;
}

MortgageResult mortgage({
  required double homePrice,
  required double downPaymentPercent,
  required double annualRatePercent,
  required int years,
  required double annualPropertyTaxPercent,
  required double annualHomeInsurance,
  required double monthlyHoa,
  required double monthlyOtherCosts,
}) {
  final clampedDownPaymentPercent = downPaymentPercent.clamp(0, 100);
  final downPayment = homePrice * clampedDownPaymentPercent / 100;
  final loanAmount = max(0, homePrice - downPayment).toDouble();
  final principalAndInterest = emi(
    principal: loanAmount,
    annualRatePercent: annualRatePercent,
    years: years,
  );
  final monthlyPropertyTax = homePrice * annualPropertyTaxPercent / 100 / 12;
  final monthlyHomeInsurance = annualHomeInsurance / 12;
  final monthlyTotal = principalAndInterest +
      monthlyPropertyTax +
      monthlyHomeInsurance +
      monthlyHoa +
      monthlyOtherCosts;
  final totalPrincipalAndInterest = principalAndInterest * years * 12;
  final totalInterest = max(0, totalPrincipalAndInterest - loanAmount);

  return MortgageResult(
    homePrice: homePrice,
    downPayment: downPayment,
    loanAmount: loanAmount,
    principalAndInterest: principalAndInterest,
    monthlyPropertyTax: monthlyPropertyTax,
    monthlyHomeInsurance: monthlyHomeInsurance,
    monthlyHoa: monthlyHoa,
    monthlyOtherCosts: monthlyOtherCosts,
    monthlyTotal: monthlyTotal,
    totalPrincipalAndInterest: totalPrincipalAndInterest,
    totalInterest: totalInterest.toDouble(),
    totalOutOfPocket: monthlyTotal * years * 12 + downPayment,
  );
}

List<AnnualAmortisationRow> annualAmortisation({
  required double principal,
  required double annualRatePercent,
  required int years,
  int maxRows = 30,
}) {
  final payment = emi(
    principal: principal,
    annualRatePercent: annualRatePercent,
    years: years,
  );
  final rate = monthlyRate(annualRatePercent);
  var balance = principal;
  final rows = <AnnualAmortisationRow>[];

  for (var year = 1; year <= years && year <= maxRows; year++) {
    var yearlyPrincipal = 0.0;
    var yearlyInterest = 0.0;

    for (var month = 1; month <= 12 && balance > 0; month++) {
      final interest = balance * rate;
      final principalPaid = min(payment - interest, balance);
      yearlyInterest += interest;
      yearlyPrincipal += principalPaid;
      balance = max(0, balance - principalPaid);
    }

    rows.add(
      AnnualAmortisationRow(
        year: year,
        principal: yearlyPrincipal,
        interest: yearlyInterest,
        balance: balance,
      ),
    );
  }

  return rows;
}

double futureValueLumpsum({
  required double principal,
  required double annualRatePercent,
  required int years,
  int compoundsPerYear = 1,
}) {
  return principal *
      pow(1 + annualRatePercent / 100 / compoundsPerYear,
          compoundsPerYear * years);
}

double cagr({
  required double initialValue,
  required double finalValue,
  required int years,
}) {
  if (initialValue <= 0 || finalValue <= 0 || years <= 0) return 0;
  return (pow(finalValue / initialValue, 1 / years) - 1) * 100;
}

double inflatedValue({
  required double currentAmount,
  required double annualInflationPercent,
  required int years,
}) {
  return currentAmount * pow(1 + annualInflationPercent / 100, years);
}

double ppfCorpus({
  required double yearlyDeposit,
  required double annualRatePercent,
  int years = 15,
}) {
  var corpus = 0.0;
  for (var year = 0; year < years; year++) {
    corpus = (corpus + yearlyDeposit) * (1 + annualRatePercent / 100);
  }
  return corpus;
}

GstResult gst({
  required double amount,
  required double ratePercent,
  required bool includesGst,
}) {
  if (includesGst) {
    final base = amount / (1 + ratePercent / 100);
    return GstResult(
        baseAmount: base, gstAmount: amount - base, totalAmount: amount);
  }
  final gstAmount = amount * ratePercent / 100;
  return GstResult(
    baseAmount: amount,
    gstAmount: gstAmount,
    totalAmount: amount + gstAmount,
  );
}

double maxLoanEligibility({
  required double monthlyIncome,
  required double existingEmis,
  required double annualRatePercent,
  required int years,
  double foirPercent = 50,
}) {
  final availableEmi =
      max(0, monthlyIncome * foirPercent / 100 - existingEmis).toDouble();
  final months = years * 12;
  final rate = monthlyRate(annualRatePercent);
  if (rate == 0) return availableEmi * months;
  return availableEmi *
      (pow(1 + rate, months) - 1) /
      (rate * pow(1 + rate, months));
}

RetirementResult retirementPlan({
  required int currentAge,
  required int retirementAge,
  required double monthlyExpenseToday,
  required double inflationPercent,
  required double retirementReturnPercent,
  required double preRetirementReturnPercent,
  int yearsInRetirement = 25,
}) {
  final yearsToRetire = max(1, retirementAge - currentAge);
  final futureMonthlyExpense = inflatedValue(
    currentAmount: monthlyExpenseToday,
    annualInflationPercent: inflationPercent,
    years: yearsToRetire,
  );
  final annualExpense = futureMonthlyExpense * 12;
  final realReturn =
      ((1 + retirementReturnPercent / 100) / (1 + inflationPercent / 100)) - 1;
  final corpus = realReturn == 0
      ? annualExpense * yearsInRetirement
      : annualExpense *
          (1 - pow(1 + realReturn, -yearsInRetirement)) /
          realReturn;
  final requiredSip = requiredSipForGoal(
    goal: corpus,
    annualReturnPercent: preRetirementReturnPercent,
    years: yearsToRetire,
  );
  return RetirementResult(
    corpusNeeded: corpus,
    monthlySipRequired: requiredSip,
    futureMonthlyExpense: futureMonthlyExpense,
  );
}

double requiredSipForGoal({
  required double goal,
  required double annualReturnPercent,
  required int years,
}) {
  final months = years * 12;
  final rate = monthlyRate(annualReturnPercent);
  if (rate == 0) return goal / months;
  return goal / (((pow(1 + rate, months) - 1) / rate) * (1 + rate));
}

class AmortisationRow {
  const AmortisationRow({
    required this.month,
    required this.emi,
    required this.principal,
    required this.interest,
    required this.balance,
  });

  final int month;
  final double emi;
  final double principal;
  final double interest;
  final double balance;
}

class AnnualAmortisationRow {
  const AnnualAmortisationRow({
    required this.year,
    required this.principal,
    required this.interest,
    required this.balance,
  });

  final int year;
  final double principal;
  final double interest;
  final double balance;
}

class MortgageResult {
  const MortgageResult({
    required this.homePrice,
    required this.downPayment,
    required this.loanAmount,
    required this.principalAndInterest,
    required this.monthlyPropertyTax,
    required this.monthlyHomeInsurance,
    required this.monthlyHoa,
    required this.monthlyOtherCosts,
    required this.monthlyTotal,
    required this.totalPrincipalAndInterest,
    required this.totalInterest,
    required this.totalOutOfPocket,
  });

  final double homePrice;
  final double downPayment;
  final double loanAmount;
  final double principalAndInterest;
  final double monthlyPropertyTax;
  final double monthlyHomeInsurance;
  final double monthlyHoa;
  final double monthlyOtherCosts;
  final double monthlyTotal;
  final double totalPrincipalAndInterest;
  final double totalInterest;
  final double totalOutOfPocket;
}

class GstResult {
  const GstResult({
    required this.baseAmount,
    required this.gstAmount,
    required this.totalAmount,
  });

  final double baseAmount;
  final double gstAmount;
  final double totalAmount;
}

class RetirementResult {
  const RetirementResult({
    required this.corpusNeeded,
    required this.monthlySipRequired,
    required this.futureMonthlyExpense,
  });

  final double corpusNeeded;
  final double monthlySipRequired;
  final double futureMonthlyExpense;
}
