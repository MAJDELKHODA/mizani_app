# ميزاني | Mizani 💚

تطبيق موبايل لإدارة المصاريف الشخصية: تسجيل الدخل والمصاريف، ميزانية يومية / أسبوعية / شهرية، تقارير ورسوم بيانية، إشعارات، ووضع فاتح وداكن — بواجهة عربية بالكامل (RTL).

## التقنيات

- **Flutter / Dart**
- **GetX** لإدارة الحالة والتنقل وحقن الاعتمادات
- **Firebase**: Authentication · Cloud Firestore · Cloud Messaging
- **fl_chart** للرسوم البيانية

## هيكلة المشروع (GetX Pattern)

```
lib/
├─ main.dart
└─ app/
   ├─ core/
   │  ├─ base/          → Controllers أساسية مشتركة (FinanceAware, TransactionForm)
   │  ├─ bindings/      → InitialBinding (Repositories + Services)
   │  ├─ constants/     → التصنيفات ومصادر الدخل وطرق الدفع
   │  ├─ theme/         → الألوان (فاتح/داكن)، الثيم، الستايلات، حركات الانتقال
   │  └─ utils/         → تنسيق المبالغ والتواريخ، السناك بار
   ├─ data/
   │  ├─ models/        → TransactionModel, BudgetModel, UserModel
   │  ├─ repositories/  → Auth, Transaction, Budget, User (كل التعامل مع Firebase)
   │  └─ services/      → FinanceService, ThemeService, NotificationService, AuthService
   ├─ modules/          → كل شاشة: controllers / views / bindings
   ├─ routes/           → AppRoutes + AppPages
   └─ widgets/          → مكوّنات واجهة مشتركة
```

### تدفق البيانات

```
Firestore ──stream──▶ Repositories ──▶ FinanceService (Rx) ──▶ Controllers ──▶ Views
```

`FinanceService` بيسمع لعمليات المستخدم وميزانيته لحظياً، فأي إضافة أو تعديل أو حذف بتنعكس فوراً على الرئيسية والميزانية والتقارير بدون إعادة تحميل يدوي.

## التشغيل

```bash
flutter pub get
flutter run
```
