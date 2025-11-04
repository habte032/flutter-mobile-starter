import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/config/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

PersistentBottomNavBarItem getNavBarItem(
  BuildContext context, {
  required String title,
  required String icon,
  required VoidCallback onPressed,
  bool isDisabled = false,
}) =>
    PersistentBottomNavBarItem(
      icon: _mainIcon(
        context,
        title: title,
        icon: icon,
        isActive: true,
        isDisabled: isDisabled,
      ),
      inactiveIcon: _mainIcon(
        context,
        title: title,
        icon: icon,
        isActive: false,
        isDisabled: isDisabled,
      ),
      onPressed: isDisabled ? (context) {} : (context) => onPressed(),
    );
Widget _mainIcon(
  BuildContext context, {
  required String title,
  required String icon,
  required bool isActive,
  required bool isDisabled,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      if (isActive)
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.white.withOpacity(0.6),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
      SvgPicture.asset(
        icon,
        width: 23,
        color: isDisabled
            ? AppColors.text.withOpacity(0.3)
            : isActive
                ? AppColors.white
                : AppColors.grey.withAlpha(160),
      ),
      Text(
        title,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: isDisabled
                  ? AppColors.text.withOpacity(0.3)
                  : isActive
                      ? AppColors.white
                      : AppColors.grey.withAlpha(160),
            ),
        maxLines: 1,
        overflow: TextOverflow.clip,
      ),
    ],
  );
}
