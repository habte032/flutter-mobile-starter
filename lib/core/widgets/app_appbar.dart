import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/theme/app_colors.dart';

/// Flexible and reusable AppBar component
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  final Widget? flexibleSpace;
  final IconThemeData? iconTheme;
  final IconThemeData? actionsIconTheme;
  final TextStyle? titleTextStyle;
  final double? toolbarHeight;
  final ShapeBorder? shape;
  final bool primary;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final VoidCallback? onLeadingPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    this.flexibleSpace,
    this.iconTheme,
    this.actionsIconTheme,
    this.titleTextStyle,
    this.toolbarHeight,
    this.shape,
    this.primary = true,
    this.systemOverlayStyle,
    this.onLeadingPressed,
  }) : assert(
         title != null || titleWidget != null,
         'Either title or titleWidget must be provided',
       );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading:
          leading ??
          (automaticallyImplyLeading
              ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed:
                      onLeadingPressed ??
                      () => Navigator.of(context).maybePop(),
                )
              : null),
      centerTitle: centerTitle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor:
          backgroundColor ??
          theme.appBarTheme.backgroundColor ??
          theme.scaffoldBackgroundColor,
      foregroundColor:
          foregroundColor ??
          theme.appBarTheme.foregroundColor ??
          theme.colorScheme.onSurface,
      elevation: elevation ?? theme.appBarTheme.elevation ?? 0,
      bottom: bottom,
      flexibleSpace: flexibleSpace,
      iconTheme:
          iconTheme ??
          theme.appBarTheme.iconTheme ??
          IconThemeData(
            color:
                foregroundColor ??
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
          ),
      actionsIconTheme:
          actionsIconTheme ??
          theme.appBarTheme.actionsIconTheme ??
          IconThemeData(
            color:
                foregroundColor ??
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
          ),
      titleTextStyle:
          titleTextStyle ??
          theme.appBarTheme.titleTextStyle ??
          theme.textTheme.titleLarge?.copyWith(
            color:
                foregroundColor ??
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
      toolbarHeight: toolbarHeight,
      shape: shape,
      primary: primary,
      systemOverlayStyle:
          systemOverlayStyle ??
          (theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    toolbarHeight ??
        (bottom != null
            ? kToolbarHeight + (bottom?.preferredSize.height ?? 0)
            : kToolbarHeight),
  );

  /// Factory constructor for transparent AppBar
  factory CustomAppBar.transparent({
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    VoidCallback? onLeadingPressed,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      onLeadingPressed: onLeadingPressed,
    );
  }

  /// Factory constructor for gradient AppBar
  factory CustomAppBar.gradient({
    required Gradient gradient,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    VoidCallback? onLeadingPressed,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: AppColors.transparent,
      elevation: 0,
      flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
      onLeadingPressed: onLeadingPressed,
    );
  }

  /// Factory constructor for custom colored AppBar
  factory CustomAppBar.colored({
    required Color color,
    String? title,
    Widget? titleWidget,
    List<Widget>? actions,
    Widget? leading,
    bool centerTitle = true,
    Color? foregroundColor,
    VoidCallback? onLeadingPressed,
  }) {
    return CustomAppBar(
      title: title,
      titleWidget: titleWidget,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: color,
      foregroundColor: foregroundColor,
      onLeadingPressed: onLeadingPressed,
    );
  }
}
