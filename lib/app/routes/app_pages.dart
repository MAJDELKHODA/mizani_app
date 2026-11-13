import 'package:get/get.dart';
import 'package:mizani_app/app/modules/splash/bindings/splash_binding.dart';
import 'package:mizani_app/app/modules/splash/views/splash_view.dart';
import 'package:mizani_app/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:mizani_app/app/modules/onboarding/views/onboarding_view.dart';
import 'package:mizani_app/app/modules/login/bindings/login_binding.dart';
import 'package:mizani_app/app/modules/login/views/login_view.dart';
import 'package:mizani_app/app/modules/register/bindings/register_binding.dart';
import 'package:mizani_app/app/modules/register/views/register_view.dart';
import 'package:mizani_app/app/modules/home/bindings/home_binding.dart';
import 'package:mizani_app/app/modules/home/views/home_view.dart';
import 'package:mizani_app/app/modules/transactions/bindings/transactions_binding.dart';
import 'package:mizani_app/app/modules/transactions/views/transactions_view.dart';
import 'package:mizani_app/app/modules/transaction_details/bindings/transaction_details_binding.dart';
import 'package:mizani_app/app/modules/transaction_details/views/transaction_details_view.dart';
import 'package:mizani_app/app/modules/add_expense/bindings/add_expense_binding.dart';
import 'package:mizani_app/app/modules/add_expense/views/add_expense_view.dart';
import 'package:mizani_app/app/modules/add_income/bindings/add_income_binding.dart';
import 'package:mizani_app/app/modules/add_income/views/add_income_view.dart';
import 'package:mizani_app/app/modules/edit_expense/bindings/edit_expense_binding.dart';
import 'package:mizani_app/app/modules/edit_expense/views/edit_expense_view.dart';
import 'package:mizani_app/app/modules/edit_income/bindings/edit_income_binding.dart';
import 'package:mizani_app/app/modules/edit_income/views/edit_income_view.dart';
import 'package:mizani_app/app/modules/budget/bindings/budget_binding.dart';
import 'package:mizani_app/app/modules/budget/views/budget_view.dart';
import 'package:mizani_app/app/modules/reports/bindings/reports_binding.dart';
import 'package:mizani_app/app/modules/reports/views/reports_view.dart';
import 'package:mizani_app/app/modules/profile/bindings/profile_binding.dart';
import 'package:mizani_app/app/modules/profile/views/profile_view.dart';
import 'package:mizani_app/app/routes/app_routes.dart';

// =========================
// ربط كل Route بالشاشة والـ Binding تبعها
// =========================
class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final pages = <GetPage>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.register,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.transactions,
      page: () => const TransactionsView(),
      binding: TransactionsBinding(),
    ),
    GetPage(
      name: Routes.transactionDetails,
      page: () => const TransactionDetailsView(),
      binding: TransactionDetailsBinding(),
    ),
    GetPage(
      name: Routes.addExpense,
      page: () => const AddExpenseView(),
      binding: AddExpenseBinding(),
    ),
    GetPage(
      name: Routes.addIncome,
      page: () => const AddIncomeView(),
      binding: AddIncomeBinding(),
    ),
    GetPage(
      name: Routes.editExpense,
      page: () => const EditExpenseView(),
      binding: EditExpenseBinding(),
    ),
    GetPage(
      name: Routes.editIncome,
      page: () => const EditIncomeView(),
      binding: EditIncomeBinding(),
    ),
    GetPage(
      name: Routes.budget,
      page: () => const BudgetView(),
      binding: BudgetBinding(),
    ),
    GetPage(
      name: Routes.reports,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
