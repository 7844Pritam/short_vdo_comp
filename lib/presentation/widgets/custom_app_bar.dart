import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppBarVariant {
  transparent,
  solid,
  gradient,
  minimal,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AppBarVariant variant;
  final String? title;
  final Widget? titleWidget;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final VoidCallback? onBackPressed;
  final bool showProfileAction;
  final bool showSearchAction;
  final bool showNotificationAction;

  const CustomAppBar({
    super.key,
    this.variant = AppBarVariant.transparent,
    this.title,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.onBackPressed,
    this.showProfileAction = false,
    this.showSearchAction = false,
    this.showNotificationAction = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppBarVariant.solid:
        return _buildSolidAppBar(context, theme);
      case AppBarVariant.gradient:
        return _buildGradientAppBar(context, theme);
      case AppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme);
      case AppBarVariant.transparent:
      default:
        return _buildTransparentAppBar(context, theme);
    }
  }

  Widget _buildTransparentAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
      leading: _buildLeading(context, theme),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: _buildTitle(theme),
      centerTitle: centerTitle,
      actions: _buildActions(context, theme),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withAlpha(179),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSolidAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: backgroundColor ?? theme.colorScheme.surface,
      elevation: elevation ?? 2.0,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
      leading: _buildLeading(context, theme),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: _buildTitle(theme),
      centerTitle: centerTitle,
      actions: _buildActions(context, theme),
      shadowColor: theme.colorScheme.shadow,
    );
  }

  Widget _buildGradientAppBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
        leading: _buildLeading(context, theme),
        automaticallyImplyLeading: automaticallyImplyLeading,
        title: _buildTitle(theme),
        centerTitle: centerTitle,
        actions: _buildActions(context, theme),
      ),
    );
  }

  Widget _buildMinimalAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.light,
      leading: _buildLeading(context, theme),
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: _buildTitle(theme),
      centerTitle: centerTitle,
      actions: _buildActions(context, theme),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 0.5,
          color: theme.colorScheme.outline.withAlpha(77),
        ),
      ),
    );
  }

  Widget? _buildLeading(BuildContext context, ThemeData theme) {
    if (leading != null) return leading;

    if (automaticallyImplyLeading && Navigator.canPop(context)) {
      return IconButton(
        icon: Icon(
          Icons.arrow_back_ios_rounded,
          color: theme.colorScheme.onSurface,
        ),
        onPressed: onBackPressed ??
            () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
      );
    }

    return null;
  }

  Widget? _buildTitle(ThemeData theme) {
    if (titleWidget != null) return titleWidget;

    if (title != null) {
      return Text(
        title!,
        style: theme.textTheme.titleLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context, ThemeData theme) {
    final List<Widget> actionsList = [];

    // Add custom actions first
    if (actions != null) {
      actionsList.addAll(actions!);
    }

    // Add default actions based on flags
    if (showSearchAction) {
      actionsList.add(
        IconButton(
          icon: Icon(
            Icons.search_rounded,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle search action
          },
        ),
      );
    }

    if (showNotificationAction) {
      actionsList.add(
        Stack(
          children: [
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                // Handle notification action
              },
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (showProfileAction) {
      actionsList.add(
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              // Handle profile action
            },
            child: CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      );
    }

    return actionsList.isNotEmpty ? actionsList : null;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
