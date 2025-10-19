import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum TabBarVariant {
  standard,
  segmented,
  pills,
  minimal,
}

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBarVariant variant;
  final List<CustomTab> tabs;
  final TabController? controller;
  final Function(int)? onTap;
  final bool isScrollable;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final double? height;
  final bool showIndicator;

  const CustomTabBar({
    super.key,
    this.variant = TabBarVariant.standard,
    required this.tabs,
    this.controller,
    this.onTap,
    this.isScrollable = false,
    this.padding,
    this.backgroundColor,
    this.height,
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (variant) {
      case TabBarVariant.segmented:
        return _buildSegmentedTabBar(context, theme);
      case TabBarVariant.pills:
        return _buildPillsTabBar(context, theme);
      case TabBarVariant.minimal:
        return _buildMinimalTabBar(context, theme);
      case TabBarVariant.standard:
      default:
        return _buildStandardTabBar(context, theme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ThemeData theme) {
    return Container(
      height: height ?? 48,
      color: backgroundColor ?? theme.colorScheme.surface,
      padding: padding,
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildStandardTab(tab, theme)).toList(),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap?.call(index);
        },
        isScrollable: isScrollable,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor:
            showIndicator ? theme.colorScheme.primary : Colors.transparent,
        indicatorWeight: 2.0,
        labelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: theme.colorScheme.outline.withAlpha(51),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ThemeData theme) {
    return Container(
      height: height ?? 48,
      margin: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outline.withAlpha(77),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildSegmentedTab(tab, theme)).toList(),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap?.call(index);
        },
        isScrollable: isScrollable,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.onSurface,
        indicator: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        dividerColor: Colors.transparent,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context, ThemeData theme) {
    return Container(
      height: height ?? 56,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = tabs[index];
          final isSelected = controller?.index == index;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              controller?.animateTo(index);
              onTap?.call(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline.withAlpha(77),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (tab.icon != null) ...[
                    Icon(
                      tab.icon,
                      size: 16,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    tab.text,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMinimalTabBar(BuildContext context, ThemeData theme) {
    return Container(
      height: height ?? 40,
      padding: padding,
      child: TabBar(
        controller: controller,
        tabs: tabs.map((tab) => _buildMinimalTab(tab, theme)).toList(),
        onTap: (index) {
          HapticFeedback.lightImpact();
          onTap?.call(index);
        },
        isScrollable: isScrollable,
        labelColor: theme.colorScheme.primary,
        unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
        indicatorColor:
            showIndicator ? theme.colorScheme.primary : Colors.transparent,
        indicatorWeight: 1.0,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildStandardTab(CustomTab tab, ThemeData theme) {
    return Tab(
      icon: tab.icon != null ? Icon(tab.icon, size: 20) : null,
      text: tab.text,
      iconMargin: const EdgeInsets.only(bottom: 4),
    );
  }

  Widget _buildSegmentedTab(CustomTab tab, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (tab.icon != null) ...[
            Icon(tab.icon, size: 16),
            const SizedBox(width: 4),
          ],
          Text(tab.text),
        ],
      ),
    );
  }

  Widget _buildMinimalTab(CustomTab tab, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(tab.text),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48);
}

class CustomTab {
  final String text;
  final IconData? icon;
  final Widget? child;

  const CustomTab({
    required this.text,
    this.icon,
    this.child,
  });
}
