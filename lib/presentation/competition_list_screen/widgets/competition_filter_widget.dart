import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CompetitionFilterWidget extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterChanged;
  final bool isSearchVisible;
  final Function(bool) onSearchVisibilityChanged;
  final String searchQuery;
  final Function(String) onSearchChanged;

  const CompetitionFilterWidget({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isSearchVisible,
    required this.onSearchVisibilityChanged,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  State<CompetitionFilterWidget> createState() =>
      _CompetitionFilterWidgetState();
}

class _CompetitionFilterWidgetState extends State<CompetitionFilterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _searchAnimation;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _searchController.text = widget.searchQuery;
    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CompetitionFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSearchVisible != oldWidget.isSearchVisible) {
      if (widget.isSearchVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
        _searchController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.borderGray.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildFilterTabs(),
          AnimatedBuilder(
            animation: _searchAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _searchAnimation,
                child: Container(
                  margin: EdgeInsets.only(top: 2.h),
                  child: _buildSearchBar(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    final filters = ['Active', 'Pending', 'Completed'];

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 6.h,
            decoration: BoxDecoration(
              color: AppTheme.deepCharcoal,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.borderGray.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: filters.map((filter) {
                final isSelected = widget.selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onFilterChanged(filter);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primaryOrange
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          filter,
                          style: AppTheme.darkTheme.textTheme.labelMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.pureBlack
                                : AppTheme.textSecondary,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(width: 3.w),
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            widget.onSearchVisibilityChanged(!widget.isSearchVisible);
          },
          child: Container(
            width: 6.h,
            height: 6.h,
            decoration: BoxDecoration(
              color: widget.isSearchVisible
                  ? AppTheme.primaryOrange
                  : AppTheme.deepCharcoal,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.borderGray.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: widget.isSearchVisible ? 'close' : 'search',
                color: widget.isSearchVisible
                    ? AppTheme.pureBlack
                    : AppTheme.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.deepCharcoal,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.borderGray.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
          color: AppTheme.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search competitions or creators...',
          hintStyle: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.textSecondary,
              size: 20,
            ),
          ),
          suffixIcon: widget.searchQuery.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _searchController.clear();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'clear',
                      color: AppTheme.textSecondary,
                      size: 20,
                    ),
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
        onSubmitted: (value) {
          HapticFeedback.lightImpact();
        },
      ),
    );
  }
}
