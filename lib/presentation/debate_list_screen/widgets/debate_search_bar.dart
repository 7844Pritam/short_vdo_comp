import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class DebateSearchBar extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final VoidCallback? onFilterTap;
  final List<String>? suggestions;

  const DebateSearchBar({
    super.key,
    this.onSearchChanged,
    this.onFilterTap,
    this.suggestions,
  });

  @override
  State<DebateSearchBar> createState() => _DebateSearchBarState();
}

class _DebateSearchBarState extends State<DebateSearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions = _focusNode.hasFocus &&
            _searchController.text.isNotEmpty &&
            (widget.suggestions?.isNotEmpty ?? false);
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  onChanged: (value) {
                    widget.onSearchChanged?.call(value);
                    setState(() {
                      _showSuggestions = value.isNotEmpty &&
                          _focusNode.hasFocus &&
                          (widget.suggestions?.isNotEmpty ?? false);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search debate topics...',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'search',
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _searchController.clear();
                              widget.onSearchChanged?.call('');
                              setState(() {
                                _showSuggestions = false;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: CustomIconWidget(
                                iconName: 'clear',
                                color: theme.colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                            ),
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 3.w,
                      vertical: 2.h,
                    ),
                  ),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Container(
                width: 1,
                height: 6.h,
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onFilterTap?.call();
                },
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'tune',
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_showSuggestions) _buildSuggestions(theme),
      ],
    );
  }

  Widget _buildSuggestions(ThemeData theme) {
    final filteredSuggestions = widget.suggestions
            ?.where((suggestion) => suggestion
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .take(5)
            .toList() ??
        [];

    if (filteredSuggestions.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: filteredSuggestions.map((suggestion) {
          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              _searchController.text = suggestion;
              widget.onSearchChanged?.call(suggestion);
              setState(() {
                _showSuggestions = false;
              });
              _focusNode.unfocus();
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'search',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      suggestion,
                      style: theme.textTheme.bodyMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CustomIconWidget(
                    iconName: 'north_west',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
