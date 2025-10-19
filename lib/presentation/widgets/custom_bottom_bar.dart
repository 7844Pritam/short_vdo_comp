import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum BottomBarVariant {
  standard,
  floating,
  minimal,
}

class CustomBottomBar extends StatelessWidget {
  final BottomBarVariant variant;
  final String currentRoute;
  final Function(String)? onRouteChanged;
  final bool showLabels;
  final double? elevation;
  final EdgeInsets? margin;

  const CustomBottomBar({
    super.key,
    this.variant = BottomBarVariant.standard,
    required this.currentRoute,
    this.onRouteChanged,
    this.showLabels = true,
    this.elevation,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case BottomBarVariant.floating:
        return _buildFloatingBottomBar(context, theme);
      case BottomBarVariant.minimal:
        return _buildMinimalBottomBar(context, theme);
      case BottomBarVariant.standard:
      default:
        return _buildStandardBottomBar(context, theme);
    }
  }

  Widget _buildStandardBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      child: SafeArea(
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context, theme),
          ),
        ),
      ),
    );
  }

  Widget _buildMinimalBottomBar(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withAlpha(242),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildNavigationItems(context, theme, isMinimal: true),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNavigationItems(
    BuildContext context,
    ThemeData theme, {
    bool isMinimal = false,
  }) {
    final items = [
      _NavigationItem(
        icon: Icons.home_rounded,
        activeIcon: Icons.home,
        label: 'Home',
        route: '/home-feed-screen',
      ),
      _NavigationItem(
        icon: Icons.emoji_events_outlined,
        activeIcon: Icons.emoji_events,
        label: 'Compete',
        route: '/competition-list-screen',
      ),
      _NavigationItem(
        icon: Icons.add_circle_outline,
        activeIcon: Icons.add_circle,
        label: 'Challenge',
        route: '/challenge-screen',
        isCenter: true,
      ),
      _NavigationItem(
        icon: Icons.sports_mma_outlined,
        activeIcon: Icons.sports_mma,
        label: 'Battle',
        route: '/battle-screen',
      ),
      _NavigationItem(
        icon: Icons.forum_outlined,
        activeIcon: Icons.forum,
        label: 'Debate',
        route: '/debate-list-screen',
      ),
    ];

    return items.map((item) {
      final isActive = currentRoute == item.route;
      return _buildNavigationButton(
        context,
        theme,
        item,
        isActive,
        isMinimal: isMinimal,
      );
    }).toList();
  }

  Widget _buildNavigationButton(
    BuildContext context,
    ThemeData theme,
    _NavigationItem item,
    bool isActive, {
    bool isMinimal = false,
  }) {
    final primaryColor = theme.colorScheme.primary;
    final onSurfaceColor = theme.colorScheme.onSurface;
    final secondaryTextColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          if (onRouteChanged != null) {
            onRouteChanged!(item.route);
          } else {
            Navigator.pushNamed(context, item.route);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: isMinimal ? 8 : 12,
            horizontal: 4,
          ),
          child: item.isCenter && !isMinimal
              ? _buildCenterButton(theme, item, isActive)
              : _buildRegularButton(
                  theme,
                  item,
                  isActive,
                  primaryColor,
                  onSurfaceColor,
                  secondaryTextColor,
                  isMinimal,
                ),
        ),
      ),
    );
  }

  Widget _buildCenterButton(
      ThemeData theme, _NavigationItem item, bool isActive) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(77),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        isActive ? item.activeIcon : item.icon,
        color: theme.colorScheme.onPrimary,
        size: 24,
      ),
    );
  }

  Widget _buildRegularButton(
    ThemeData theme,
    _NavigationItem item,
    bool isActive,
    Color primaryColor,
    Color onSurfaceColor,
    Color secondaryTextColor,
    bool isMinimal,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(4),
          decoration: isActive && !isMinimal
              ? BoxDecoration(
                  color: primaryColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: Icon(
            isActive ? item.activeIcon : item.icon,
            color: isActive ? primaryColor : secondaryTextColor,
            size: isMinimal ? 20 : 24,
          ),
        ),
        if (showLabels && !isMinimal) ...[
          const SizedBox(height: 4),
          Text(
            item.label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: isActive ? primaryColor : secondaryTextColor,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}

class _NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  final bool isCenter;

  const _NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
    this.isCenter = false,
  });
}
