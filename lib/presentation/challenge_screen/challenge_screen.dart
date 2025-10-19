import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/category_selection_widget.dart';
import './widgets/challenge_form_widget.dart';
import './widgets/challenge_preview_widget.dart';
import './widgets/duration_picker_widget.dart';
import './widgets/opponent_selection_widget.dart';
import './widgets/privacy_toggle_widget.dart';
import './widgets/prize_points_widget.dart';
import './widgets/user_search_modal.dart';
import './widgets/video_prompt_widget.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _selectedCategory = 'Dance';
  String _selectedDuration = '24 hours';
  bool _isPublic = true;
  String? _selectedOpponent;
  double _prizePoints = 100;
  XFile? _selectedVideo;
  bool _isLoading = false;
  bool _showPreview = false;

  final List<String> _categories = [
    'Dance',
    'Singing',
    'Comedy',
    'Debate',
    'Freestyle',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _titleController.text.trim().isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  void _showUserSearchModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UserSearchModal(
        onUserSelected: (username) {
          setState(() {
            _selectedOpponent = username;
          });
        },
      ),
    );
  }

  void _togglePreview() {
    setState(() {
      _showPreview = !_showPreview;
    });

    if (_showPreview) {
      // Scroll to preview section
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  Future<void> _sendChallenge() async {
    if (!_isFormValid) {
      _showErrorSnackBar('Please fill in all required fields');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to create challenge. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.successGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successGreen,
                size: 40,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Challenge Created!',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Your challenge has been posted successfully. Participants can now join!',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _resetForm();
                    },
                    child: Text('Create Another'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('View Challenge'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _selectedCategory = 'Dance';
      _selectedDuration = '24 hours';
      _isPublic = true;
      _selectedOpponent = null;
      _prizePoints = 100;
      _selectedVideo = null;
      _showPreview = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
          icon: CustomIconWidget(
            iconName: 'close',
            color: AppTheme.textPrimary,
            size: 24,
          ),
        ),
        title: Text(
          'Create Challenge',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isFormValid)
            TextButton(
              onPressed: _togglePreview,
              child: Text(
                _showPreview ? 'Edit' : 'Preview',
                style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.primaryOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Selection
                    CategorySelectionWidget(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onCategorySelected: (category) {
                        setState(() {
                          _selectedCategory = category;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Challenge Form
                    ChallengeFormWidget(
                      titleController: _titleController,
                      descriptionController: _descriptionController,
                      onTitleChanged: (value) => setState(() {}),
                      onDescriptionChanged: (value) => setState(() {}),
                    ),

                    SizedBox(height: 4.h),

                    // Duration Picker
                    DurationPickerWidget(
                      selectedDuration: _selectedDuration,
                      onDurationChanged: (duration) {
                        setState(() {
                          _selectedDuration = duration;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Privacy Toggle
                    PrivacyToggleWidget(
                      isPublic: _isPublic,
                      onPrivacyChanged: (isPublic) {
                        setState(() {
                          _isPublic = isPublic;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Opponent Selection
                    OpponentSelectionWidget(
                      selectedOpponent: _selectedOpponent,
                      onSelectOpponent: _showUserSearchModal,
                    ),

                    SizedBox(height: 4.h),

                    // Prize Points
                    PrizePointsWidget(
                      prizePoints: _prizePoints,
                      onPrizePointsChanged: (points) {
                        setState(() {
                          _prizePoints = points;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Video Prompt
                    VideoPromptWidget(
                      selectedVideo: _selectedVideo,
                      onVideoSelected: (video) {
                        setState(() {
                          _selectedVideo = video;
                        });
                      },
                    ),

                    // Preview Section
                    if (_showPreview) ...[
                      SizedBox(height: 4.h),
                      ChallengePreviewWidget(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        category: _selectedCategory,
                        duration: _selectedDuration,
                        isPublic: _isPublic,
                        opponent: _selectedOpponent,
                        prizePoints: _prizePoints,
                        hasVideo: _selectedVideo != null,
                      ),
                    ],

                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),

            // Send Challenge Button
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.elevatedSurface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.shadowColor,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed:
                      _isFormValid && !_isLoading ? _sendChallenge : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? AppTheme.primaryOrange
                        : AppTheme.borderGray,
                    foregroundColor: _isFormValid
                        ? AppTheme.pureBlack
                        : AppTheme.textSecondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.pureBlack,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'send',
                              color: _isFormValid
                                  ? AppTheme.pureBlack
                                  : AppTheme.textSecondary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Send Challenge',
                              style: AppTheme.darkTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
