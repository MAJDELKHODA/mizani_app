import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mizani_app/app/core/constants/app_categories.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';
import 'package:mizani_app/app/core/utils/app_formatters.dart';
import 'package:mizani_app/app/modules/home/controllers/home_controller.dart';
import 'package:mizani_app/app/widgets/app_bottom_nav.dart';
import 'package:mizani_app/app/widgets/skeleton.dart';
import 'package:mizani_app/app/widgets/transaction_item.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.primary,
          // البيانات لحظية أصلاً، السحب بس للإحساس بالتحديث
          onRefresh: () => Future.delayed(const Duration(milliseconds: 600)),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
            child: Obx(
              () => AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                layoutBuilder: (current, previous) => Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ...previous,
                    ?current,
                  ],
                ),
                child: controller.isHomeLoading
                    ? const HomeSkeleton()
                    : _buildContent(),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // محتوى الهوم بعد ما تخلص البيانات
  Widget _buildContent() {
    return Column(
      key: const ValueKey("content"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeader(),
        const SizedBox(height: 22),
        buildBalanceCard(),
        const SizedBox(height: 24),
        sectionTitle("إجراءات سريعة"),
        const SizedBox(height: 12),
        buildQuickActions(),
        const SizedBox(height: 24),
        buildBudgetCard(),
        const SizedBox(height: 26),
        buildTransactionsHeader(),
        const SizedBox(height: 10),
        _buildTransactionsList(),
      ],
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        // صورة رمزية بأول حرف من الاسم
        Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.heroEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Text(
            controller.userName.isNotEmpty ? controller.userName.substring(0, 1) : "؟",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "مرحباً 👋",
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                controller.userName.isNotEmpty ? controller.userName : "...",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
  Widget buildBalanceCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [AppColors.heroStart, AppColors.heroEnd],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40065F46),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // دوائر ديكور بالخلفية
            Positioned(
              top: -50,
              left: -30,
              child: decorCircle(150, const Color(0x14FFFFFF)),
            ),
            Positioned(
              bottom: -60,
              right: -40,
              child: decorCircle(170, const Color(0x0FFFFFFF)),
            ),

            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "رصيدك الحالي",
                        style: TextStyle(
                          color: Color(0xB3FFFFFF),
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {
                          controller.toggleBalance();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0x1FFFFFFF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            controller.isBalanceHidden.value
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            controller.isBalanceHidden.value ? "••••••" : AppFormatters.amount(controller.balance),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 6),
                        child: Text(
                          "₪",
                          style: TextStyle(
                            color: Color(0xB3FFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: moneyItem(
                          "إجمالي الدخل",
                          controller.totalIncome,
                          Icons.arrow_downward_rounded,
                          const Color(0xFF6EE7B7),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: moneyItem(
                          "إجمالي المصروف",
                          controller.totalExpense,
                          Icons.arrow_upward_rounded,
                          const Color(0xFFFDA4AF),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget decorCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
  Widget moneyItem(
    String title,
    double value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0x1FFFFFFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: Color(0x26FFFFFF),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xB3FFFFFF),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  controller.isBalanceHidden.value ? "••••" : "${AppFormatters.amount(value)} ₪",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildQuickActions() {
    return Row(
      children: [
        actionButton(
          Icons.remove_rounded,
          "إضافة مصروف",
          AppColors.expense,
          AppColors.expenseSoft,
          onTap: controller.openAddExpense,
        ),
        const SizedBox(width: 12),
        actionButton(
          Icons.add_rounded,
          "إضافة دخل",
          AppColors.income,
          AppColors.incomeSoft,
          onTap: controller.openAddIncome,
        ),
        const SizedBox(width: 12),
        actionButton(
          Icons.track_changes_rounded,
          "تحديد الميزانية",
          AppColors.primary,
          AppColors.primarySoft,
          onTap: controller.openBudget,
        ),
      ],
    );
  }
  Widget actionButton(
    IconData icon,
    String title,
    Color color,
    Color softColor, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: softColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Color budgetStatusColor() {
    if (controller.budgetProgress < 0.7) return AppColors.primary;
    if (controller.budgetProgress < 0.9) return AppColors.warning;
    return AppColors.expense;
  }
  Widget buildBudgetCard() {
    // لسا ما في ميزانية
    if (!controller.hasBudget) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.savings_outlined,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "لم تحدد ميزانية بعد",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "حدد ميزانيتك وتابع مصروفك بسهولة",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: controller.openBudget,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
              ),
              child: const Text(
                "حدد الآن",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    final statusColor = budgetStatusColor();
    final isOverBudget = controller.budgetRemaining < 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.pie_chart_outline_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ميزانيتك ${controller.budgetPeriod}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "من أصل ${AppFormatters.amount(controller.budgetAmount)} ₪",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${(controller.budgetProgress * 100).toInt()}%",
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: controller.budgetProgress,
              minHeight: 10,
              backgroundColor: AppColors.border,
              color: statusColor,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              budgetInfo(
                "تم صرف",
                "${AppFormatters.amount(controller.budgetSpent)} ₪",
                AppColors.expense,
              ),
              const Spacer(),
              budgetInfo(
                "المتبقي",
                "${AppFormatters.amount(isOverBudget ? 0 : controller.budgetRemaining)} ₪",
                AppColors.income,
              ),
            ],
          ),

          if (isOverBudget) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.expenseSoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.expense,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "تجاوزت الميزانية بـ ${AppFormatters.amount(controller.budgetRemaining.abs())} ₪",
                      style: TextStyle(
                        color: AppColors.expense,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget budgetInfo(String label, String value, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          "$label ",
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
  Widget buildTransactionsHeader() {
    return Row(
      children: [
        sectionTitle("آخر العمليات"),
        const Spacer(),

        // يظهر فقط لو خلص التحميل
        // وفي عمليات فعلًا
        if (controller.recentTransactions.isNotEmpty)
          TextButton(
            onPressed: controller.openTransactions,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "عرض الكل",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 4),
                Icon(Icons.arrow_forward_ios_rounded, size: 12),
              ],
            ),
          ),
      ],
    );
  }
  Widget sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: AppColors.textDark,
      ),
    );
  }
  BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  // =========================
  // آخر العمليات
  // =========================

  Widget _buildTransactionsList() {
    final transactions = controller.recentTransactions;

    if (transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
        decoration: cardDecoration(),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_rounded,
                size: 34,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              "لا توجد عمليات حتى الآن",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "ابدأ بإضافة دخل أو مصروف ليظهر هنا",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: transactions.map((transaction) {
        final isIncome = transaction.isIncome;

        return TransactionItem(
          title: transaction.title,
          subtitle: isIncome
              ? transaction.source
              : "${transaction.category} • ${transaction.payment}",
          amount: AppFormatters.amount(transaction.amount),
          icon: AppCategories.iconFor(
            isIncome: isIncome,
            name: transaction.title,
          ),
          iconColor: isIncome ? AppColors.income : AppColors.expense,
          isIncome: isIncome,
          date: AppFormatters.date(transaction.date),
          onTap: () => controller.openDetails(transaction),
        );
      }).toList(),
    );
  }

  // =========================
  // الشريط السفلي
  // =========================

  Widget _buildBottomNav() {
    return AppBottomNav(
      currentIndex: 0,
      onTap: (index) {
        switch (index) {
          case 1:
            controller.openTransactions();
            break;
          case 2:
            controller.openReports();
            break;
          case 3:
            controller.openProfile();
            break;
        }
      },
      items: const [
        AppBottomNavItem(
          icon: Icons.home_outlined,
          activeIcon: Icons.home_rounded,
          label: "الرئيسية",
        ),
        AppBottomNavItem(
          icon: Icons.receipt_long_outlined,
          activeIcon: Icons.receipt_long_rounded,
          label: "العمليات",
        ),
        AppBottomNavItem(
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart_rounded,
          label: "التقارير",
        ),
        AppBottomNavItem(
          icon: Icons.person_outline_rounded,
          activeIcon: Icons.person_rounded,
          label: "حسابي",
        ),
      ],
    );
  }
}
