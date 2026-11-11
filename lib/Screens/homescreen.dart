import 'package:flutter/material.dart';
import 'package:mizani_app/Screens/profile_screen.dart';
import 'package:mizani_app/Screens/reports_screen.dart';
import 'package:mizani_app/Screens/transactions_screen.dart';

import '../Widgets/transaction_item.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'budget_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'transaction_details_screen.dart';


class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}


class _HomescreenState extends State<Homescreen> {
  bool isRecentTransactionsLoading = true;
  List<Map<String, dynamic>> recentTransactions = [];
  int currentIndex = 0;
  double totalIncome = 0; //مجموع كل عمليات الدخل
  double totalExpense = 0;//مجموع كل عمليات المصروف هاي كل المصاريف
  double balance = 0;//الدخل - المصروف
  String userName = ""; // هون حخزن الاسم الجاي من لفير بيز
  double budgetAmount = 0;
  double budgetRemaining = 0;
  double budgetProgress = 0;

  String budgetPeriod = "";
  double budgetSpent = 0; // قديش صرف المستخدم ضمن فترة الميزانية الحالية.

  @override
  void initState() {
    super.initState();

    loadHomeData();

  }
  Future<void> loadHomeData() async {

    await getUserData(); //// هاي داله يجيب اسم المستخدم عشان اعرضو عند مرحبا

    await getFinancialData(); //// جيب عملياته واحسب الأرقام

    await getBudgetData();

    await getRecentTransactions();
  }
  Future<void> getUserData() async {
//مين المستخدم المسجل دخول هلا؟ هات الـUID تبعه
    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    final userDoc =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!mounted) return;

    setState(() {

      userName =
      userDoc["name"];

    });
  }

  Future<void> getFinancialData() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;


    final snapshot =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .get();


    double income = 0;
    double expense = 0;

    //مرّ على كل Document موجود في transactions واحد واحد.
    for (var doc in snapshot.docs) {
   // هات البيانات الموجودة داخل الـDocument الحالي
      final data = doc.data();

      double amount =
      (data["amount"] as num).toDouble();
// هات نوع العمليه ممكن تكون دخل income وممكن تكون مصروف expense
      String type =
          data["type"] ?? "";


      if (type == "income") {

        income = income + amount;

      }

      else if (type == "expense") {

        expense = expense + amount;

      }
    }


    if (!mounted) return;


    setState(() {

      totalIncome = income;

      totalExpense = expense;
   // هاي تعتبر الرصيد الاجمالي يعني بالنهايه بتنقص اجمالي الدخل - اجمالي المصروفات عشان بالنهايهع تطلع الرصيد الحالي تبعي
      balance =
          totalIncome - totalExpense;

    });
  }

  Future<void> getBudgetData() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;


    final budgetDoc =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("budget")
        .doc("current")
        .get();


    if (budgetDoc.exists) {

      double amount =
      (budgetDoc["amount"] as num).toDouble();

      String period =
          budgetDoc["period"] ?? "";


      DateTime savedStartDate =
      (budgetDoc["startDate"] as Timestamp).toDate();


      DateTime startDate = DateTime(
        savedStartDate.year,
        savedStartDate.month,
        savedStartDate.day,
      );


      DateTime endDate;


      if (period == "يومية") {

        endDate =
            startDate.add(
              const Duration(days: 1),
            );

      }

      else if (period == "أسبوعية") {

        endDate =
            startDate.add(
              const Duration(days: 7),
            );

      }

      else {

        endDate = DateTime(
          startDate.year,
          startDate.month + 1,
          startDate.day,
        );

      }


      final snapshot =
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("transactions")
          .get();


      double expenseForPeriod = 0;


      for (var doc in snapshot.docs) {

        final data = doc.data();


        if (data["type"] == "expense") {

          DateTime transactionDate =
          (data["date"] as Timestamp)
              .toDate();


          if (
          !transactionDate.isBefore(startDate)
              &&
              transactionDate.isBefore(endDate)
          ) {

            double expenseAmount =
            (data["amount"] as num)
                .toDouble();


            expenseForPeriod =
                expenseForPeriod +
                    expenseAmount;

          }
        }
      }


      double remaining =
          amount - expenseForPeriod;


      double progress = 0;


      if (amount > 0) {

        progress =
            expenseForPeriod / amount;

      }


      if (progress > 1) {

        progress = 1;

      }


      if (!mounted) return;


      setState(() {

        budgetAmount = amount;

        budgetPeriod = period;

        budgetSpent =
            expenseForPeriod;

        budgetRemaining =
            remaining;

        budgetProgress =
            progress;

      });
    }
  }

  Future<void> getRecentTransactions() async {

    String uid =
        FirebaseAuth.instance.currentUser!.uid;

    final snapshot =
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("transactions")
        .orderBy(
      "date",
      descending: true,
    )
        .limit(3)
        .get();


    List<Map<String, dynamic>>
    loadedTransactions = [];


    for (var doc in snapshot.docs) {

      final data = doc.data();

      loadedTransactions.add({

        "id": doc.id,

        "amount":
        (data["amount"] as num)
            .toDouble(),

        "type":
        data["type"] ?? "",

        "date":
        (data["date"] as Timestamp)
            .toDate(),

        "category":
        data["category"] ?? "",

        "source":
        data["source"] ?? "",

        "payment":
        data["payment"] ?? "",

        "note":
        data["note"] ?? "",

        "createdAt":
        data["createdAt"] is Timestamp
            ? (data["createdAt"] as Timestamp).toDate()
            : null,

      });
    }


    if (!mounted) return;


    setState(() {

      recentTransactions =
          loadedTransactions;

      isRecentTransactionsLoading =
      false;

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F2FF),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              // =========================
              // Header
              // =========================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [

                      Text(
                        "مرحباً، $userName 👋",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff352080),
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "تابع مصروفك وتحكم بأموالك",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),

                    ],
                  ),


                  Container(
                    padding: const EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),

                    child: const Icon(
                      Icons.notifications_none,
                      color: Color(0xff6D3CE8),
                    ),
                  ),

                ],
              ),


              const SizedBox(height: 25),


              // =========================
              // Balance Card
              // =========================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff8B5CF6),
                      Color(0xff6D3CE8),
                    ],
                  ),

                  borderRadius: BorderRadius.circular(25),
                ),

                child: Column(
                  children: [

                    const Text(
                      "رصيدك الحالي",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),


                    const SizedBox(height: 8),


                    Text(
                      "$balance ₪",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                    const SizedBox(height: 20),


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: [

                        moneyItem(
                          "إجمالي الدخل",
                          "$totalIncome ₪",
                          Colors.greenAccent,
                        ),

                        moneyItem(
                          "إجمالي المصروف",
                          "$totalExpense ₪",
                          Colors.redAccent,
                        ),

                      ],
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 20),


              // =========================
              // Budget Card
              // =========================

              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    Text(
                      "ميزانيتك $budgetPeriod",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),


                    const SizedBox(height: 15),


                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [

                        Text(
                          "تم صرف $budgetSpent ₪",
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),

                        Text(
                          "المتبقي $budgetRemaining ₪",
                          style: const TextStyle(
                            color: Colors.green,
                          ),
                        ),

                      ],
                    ),


                    const SizedBox(height: 12),


                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child: LinearProgressIndicator(

                        value: budgetProgress,

                        minHeight: 10,

                        backgroundColor:
                        const Color(0xffEDE7FF),

                        color:
                        const Color(0xff6D3CE8),
                      ),
                    ),


                    const SizedBox(height: 8),


                    Text(
                      "${(budgetProgress * 100).toInt()}%",

                      style: const TextStyle(
                        color: Color(0xff6D3CE8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),


              const SizedBox(height: 20),


              // =========================
              // Quick Actions
              // =========================

              Row(
                children: [

                  actionButton(
                    Icons.remove_circle_outline,
                    "إضافة مصروف",
                    Colors.redAccent,

                    onTap: () async {

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AddExpenseScreen(),
                        ),
                      );

                      await getFinancialData();

                      await getBudgetData();

                      await getRecentTransactions();
                    },
                  ),


                  actionButton(
                    Icons.add_circle_outline,
                    "إضافة دخل",
                    Colors.green,

                    onTap: () async {

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                          const AddIncomeScreen(),
                        ),
                      );

                      await getFinancialData();

                      await getRecentTransactions();
                    },
                  ),


                  actionButton(
                    Icons.track_changes,
                    "تحديد الميزانية",
                    const Color(0xff6D3CE8),

                    onTap: () async {
                   await   Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (context) =>
                          const BudgetScreen(),
                        ),
                      );
                   await getBudgetData();
                    },
                  ),

                ],
              ),


              const SizedBox(height: 25),


              // =========================
              // Transactions Header
              // =========================

              Row(

                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  const Text(

                    "آخر العمليات",

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),


                  // يظهر فقط لو خلص التحميل
                  // وفي عمليات فعلًا

                  if (
                  !isRecentTransactionsLoading &&
                      recentTransactions.isNotEmpty
                  )

                    TextButton(

                      onPressed: () async {

                        await Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (context) =>
                            const TransactionsScreen(),

                          ),

                        );


                        await getFinancialData();

                        await getBudgetData();

                        await getRecentTransactions();

                      },


                      child: const Text(

                        "عرض الكل",

                        style: TextStyle(

                          color:
                          Color(0xff6D3CE8),

                        ),

                      ),

                    ),

                ],

              ),


              // =========================
              // Transactions
              // =========================



              if (isRecentTransactionsLoading)

                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 25,
                  ),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff6D3CE8),
                    ),
                  ),
                )

              else if (recentTransactions.isEmpty)

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 30,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Column(
                    children: [

                      Icon(
                        Icons.receipt_long_outlined,
                        size: 45,
                        color: Color(0xffB7AECF),
                      ),

                      SizedBox(height: 12),

                      Text(
                        "لا توجد عمليات حتى الآن",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff352080),
                        ),
                      ),

                      SizedBox(height: 5),

                      Text(
                        "ابدأ بإضافة دخل أو مصروف ليظهر هنا",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),

                    ],
                  ),
                )

              else

                ...recentTransactions.map(
                      (transaction) {

                    bool isIncome =
                        transaction["type"] ==
                            "income";

                    String title;
                    String subtitle;
                    IconData icon;
                    Color color;


                    if (isIncome) {

                      title =
                      transaction["source"];

                      subtitle =
                      transaction["source"];

                      icon =
                          Icons.work;

                      color =
                          Colors.green;

                    }

                    else {

                      title =
                      transaction["category"];

                      subtitle =
                      "${transaction["category"]} • ${transaction["payment"]}";

                      icon =
                          Icons.receipt_long;

                      color =
                          Colors.redAccent;

                    }


                    return TransactionItem(

                      title: title,

                      subtitle: subtitle,

                      amount:
                      transaction["amount"]
                          .toString(),

                      icon: icon,

                      iconColor: color,

                      isIncome: isIncome,

                      date:
                      formatDate(
                        transaction["date"],
                      ),

                      onTap: () async {

                        await Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                TransactionDetailsScreen(

                                  transactionId:
                                  transaction["id"],

                                  type:
                                  transaction["type"],

                                  source:
                                  transaction["source"],

                                  title:
                                  title,

                                  amount:
                                  transaction["amount"],

                                  category:
                                  isIncome
                                      ? transaction["source"]
                                      : transaction["category"],

                                  date:
                                  transaction["date"],

                                  time:
                                  formatTime(
                                    transaction["createdAt"],
                                  ),

                                  paymentMethod:
                                  isIncome
                                      ? "-"
                                      : transaction["payment"],

                                  note:
                                  transaction["note"],

                                  icon:
                                  icon,

                                  iconColor:
                                  color,

                                ),

                          ),

                        );


                        await getFinancialData();

                        await getBudgetData();

                        await getRecentTransactions();

                      },

                    );

                  },
                ),


            ],
          ),
        ),
      ),


      // =========================
      // Bottom Navigation
      // =========================

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,

        onTap: (value) {

          // 0 = الرئيسية
          if (value == 0) {
            setState(() {
              currentIndex = 0;
            });

            return;
          }


          // 1 = العمليات
          if (value == 1) {

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const TransactionsScreen(),
              ),
            ).then((_) async {

              await getFinancialData();

              await getBudgetData();

              await getRecentTransactions();

            });

            return;
          }


          // 2 = التقارير
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const ReportsScreen(),
              ),
            );

            return;
          }


          // 3 = حسابي
          if (value == 3) {

            Navigator.push(
              context,

              MaterialPageRoute(
                builder: (context) =>
                const ProfileScreen(),
              ),
            );

            return;
          }
        },

        backgroundColor: Colors.white,

        selectedItemColor:
        const Color(0xff6D3CE8),

        unselectedItemColor:
        const Color(0xffA0A0A0),

        selectedLabelStyle:
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),

        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "الرئيسية",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "العمليات",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "التقارير",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "حسابي",
          ),

        ],
      ),
    );
  }


  // =========================
  // Money Item
  // =========================

  Widget moneyItem(
      String title,
      String value,
      Color color,
      ) {
    return Column(
      children: [

        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
          ),
        ),

        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

      ],
    );
  }


  // =========================
  // Action Button
  // =========================

  Widget actionButton(
      IconData icon,
      String title,
      Color color, {
        VoidCallback? onTap,
      }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(18),

        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 4,
          ),

          padding: const EdgeInsets.all(15),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),

          child: Column(
            children: [

              Icon(
                icon,
                color: color,
                size: 30,
              ),

              const SizedBox(height: 8),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 12,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }


  String formatTime(
      DateTime? date,
      ) {

    if (date == null) {
      return "-";
    }

    String hour =
    date.hour
        .toString()
        .padLeft(2, '0');

    String minute =
    date.minute
        .toString()
        .padLeft(2, '0');

    return "$hour:$minute";
  }

  String formatDate(DateTime date) {

    String day =
    date.day
        .toString()
        .padLeft(2, '0');

    String month =
    date.month
        .toString()
        .padLeft(2, '0');

    return "$day/$month/${date.year}";
  }


}