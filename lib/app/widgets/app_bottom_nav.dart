import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mizani_app/app/core/theme/app_colors.dart';

// =========================
// عنصر واحد بالشريط
// =========================
class AppBottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const AppBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

// =========================
// شريط تنقل عائم مودرن
// العنصر المختار بيتوسع وبيبين اسمه بكبسولة خضرا
// =========================
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<AppBottomNavItem> items;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1F053B2C),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (int i = 0; i < items.length; i++)
              _NavButton(
                item: items[i],
                isSelected: i == currentIndex,
                onTap: () {
                  HapticFeedback.selectionClick(); // اهتزاز خفيف
                  onTap(i);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final AppBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  static const _duration = Duration(milliseconds: 280);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: AppColors.primarySoft,
        highlightColor: Colors.transparent,
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 16 : 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primarySoft : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الأيقونة بتتبدل بحركة تكبير خفيفة
              AnimatedSwitcher(
                duration: _duration,
                switchInCurve: _curve,
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: Tween<double>(begin: 0.8, end: 1).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  isSelected ? item.activeIcon : item.icon,
                  key: ValueKey(isSelected),
                  size: 24,
                  color: isSelected ? AppColors.primary : AppColors.textHint,
                ),
              ),

              // الاسم بيظهر بس للعنصر المختار
              AnimatedSize(
                duration: _duration,
                curve: _curve,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
