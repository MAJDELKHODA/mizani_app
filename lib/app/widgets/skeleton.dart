import 'package:flutter/material.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// تأثير اللمعة (Shimmer) بدون أي package
// =========================
class Shimmer extends StatefulWidget {
  final Widget child;

  const Shimmer({super.key, required this.child});

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1300),
  )..repeat();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: widget.child,
      builder: (context, child) {
        final t = controller.value;

        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.5 + 3 * t, -0.3),
              end: Alignment(-0.5 + 3 * t, 0.3),
              colors: [
                AppColors.skeletonBase,
                AppColors.skeletonHighlight,
                AppColors.skeletonBase,
              ],
              stops: const [0.1, 0.5, 0.9],
            ).createShader(bounds);
          },
          child: child,
        );
      },
    );
  }
}

// =========================
// مربع رمادي (مكان المحتوى)
// =========================
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.skeletonBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// =========================
// شكل الهوم وهو بيحمّل
// =========================
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            children: [
              SkeletonBox(width: 50, height: 50, radius: 25),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 70, height: 12),
                    SizedBox(height: 8),
                    SkeletonBox(width: 140, height: 18),
                  ],
                ),
              ),
              SkeletonBox(width: 46, height: 46, radius: 14),
            ],
          ),

          const SizedBox(height: 22),

          // Balance card
          const SkeletonBox(height: 190, radius: 28),

          const SizedBox(height: 24),

          const SkeletonBox(width: 110, height: 16),

          const SizedBox(height: 12),

          // Quick actions
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(end: i == 2 ? 0 : 12),
                  child: const SkeletonBox(height: 100, radius: 20),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Budget
          const SkeletonBox(height: 140, radius: 24),

          const SizedBox(height: 26),

          const SkeletonBox(width: 120, height: 16),

          const SizedBox(height: 14),

          // Transactions
          ...List.generate(
            3,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: SkeletonBox(height: 78, radius: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// قائمة عمليات وهي بتحمّل (شاشة العمليات)
// =========================
class TransactionListSkeleton extends StatelessWidget {
  final int count;

  const TransactionListSkeleton({super.key, this.count = 6});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        children: List.generate(
          count,
          (_) => const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                SkeletonBox(width: 48, height: 48, radius: 15),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 130, height: 13),
                      SizedBox(height: 8),
                      SkeletonBox(width: 90, height: 10),
                    ],
                  ),
                ),
                SkeletonBox(width: 64, height: 26, radius: 13),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// شاشة التقارير وهي بتحمّل
// =========================
class ReportsSkeleton extends StatelessWidget {
  const ReportsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Expanded(child: SkeletonBox(height: 90, radius: 20)),
              SizedBox(width: 12),
              Expanded(child: SkeletonBox(height: 90, radius: 20)),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonBox(height: 230, radius: 24),
          const SizedBox(height: 20),
          const SkeletonBox(width: 120, height: 16),
          const SizedBox(height: 14),
          ...List.generate(
            4,
            (_) => const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SkeletonBox(width: 40, height: 40, radius: 12),
                  SizedBox(width: 12),
                  Expanded(child: SkeletonBox(height: 12)),
                  SizedBox(width: 30),
                  SkeletonBox(width: 50, height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================
// Skeleton فوق كرت ملوّن (أخضر) — بيرمش بنعومة
// =========================
class OnDarkSkeleton extends StatefulWidget {
  const OnDarkSkeleton({super.key});

  @override
  State<OnDarkSkeleton> createState() => _OnDarkSkeletonState();
}

class _OnDarkSkeletonState extends State<OnDarkSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
    upperBound: 1,
  )..repeat(reverse: true);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget _line(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _line(90, 9),
          const SizedBox(height: 8),
          _line(150, 16),
          const SizedBox(height: 8),
          _line(double.infinity, 7),
        ],
      ),
    );
  }
}
