import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

class NewDebateModal extends StatefulWidget {
  final Function(Map<String, dynamic>)? onDebateCreated;

  const NewDebateModal({
    super.key,
    this.onDebateCreated,
  });

  static void show(
    BuildContext context, {
    Function(Map<String, dynamic>)? onDebateCreated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewDebateModal(
        onDebateCreated: onDebateCreated,
      ),
    );
  }

  @override
  State<NewDebateModal> createState() => _NewDebateModalState();
}

class _NewDebateModalState extends State<NewDebateModal> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'General';
  int _selectedDuration = 24; // hours
  bool _isCreating = false;

  final List<String> _categories = [
    'General',
    'Politics',
    'Entertainment',
    'Sports',
    'Technology',
    'Science',
    'Education',
    'Health',
  ];

  final List<int> _durations = [6, 12, 24, 48, 72]; // hours

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 90.h,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleField(theme),
                    SizedBox(height: 3.h),
                    _buildDescriptionField(theme),
                    SizedBox(height: 3.h),
                    _buildCategorySelector(theme),
                    SizedBox(height: 3.h),
                    _buildDurationSelector(theme),
                    SizedBox(height: 4.h),
                    _buildCreateButton(theme),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Start New Debate',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: theme.colorScheme.onSecondaryContainer,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Debate Topic',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _titleController,
          maxLines: 2,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: 'What would you like to debate about?',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(3.w),
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 300,
          decoration: InputDecoration(
            hintText:
                'Provide more context or details about your debate topic...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
            contentPadding: EdgeInsets.all(3.w),
          ),
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCategorySelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _categories.map((category) {
            final isSelected = _selectedCategory == category;
            return GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedCategory = category;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  category,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSecondaryContainer,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDurationSelector(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Debate Duration',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          padding: EdgeInsets.all(1.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: _durations.map((duration) {
              final isSelected = _selectedDuration == duration;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedDuration = duration;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${duration}h',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateButton(ThemeData theme) {
    final canCreate = _titleController.text.trim().isNotEmpty && !_isCreating;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canCreate ? _createDebate : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isCreating
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.onPrimary,
                  ),
                ),
              )
            : Text(
                'Start Debate',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
      ),
    );
  }

  Future<void> _createDebate() async {
    if (_titleController.text.trim().isEmpty) return;

    setState(() {
      _isCreating = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      final newDebate = {
        'id': DateTime.now().millisecondsSinceEpoch,
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
        'category': _selectedCategory,
        'duration': _selectedDuration,
        'author': {
          'id': 'current_user',
          'name': 'You',
          'avatar':
              'https://images.unsplash.com/photo-1712217559097-cc2aaf698767',
          'avatarSemanticLabel':
              'Your profile picture showing a professional headshot',
        },
        'responseCount': 0,
        'responses': [],
        'isHot': false,
        'timeAgo': 'Just now',
        'endTime': '${_selectedDuration}h',
        'createdAt': DateTime.now().toIso8601String(),
      };

      widget.onDebateCreated?.call(newDebate);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Debate created successfully!'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create debate. Please try again.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}