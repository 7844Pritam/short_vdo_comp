import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VotingButtonsWidget extends StatefulWidget {
  final Function(bool) onVote; // true for original, false for response
  final bool hasVoted;
  final bool? votedForOriginal;
  final bool votingEnded;

  const VotingButtonsWidget({
    super.key,
    required this.onVote,
    this.hasVoted = false,
    this.votedForOriginal,
    this.votingEnded = false,
  });

  @override
  State<VotingButtonsWidget> createState() => _VotingButtonsWidgetState();
}

class _VotingButtonsWidgetState extends State<VotingButtonsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleVote(bool isOriginal) {
    if (widget.votingEnded || widget.hasVoted) return;

    HapticFeedback.mediumImpact();
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onVote(isOriginal);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Voting instruction
            if (!widget.hasVoted && !widget.votingEnded)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.primaryOrange,
                      size: 5.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        'Choose which argument you find more convincing',
                        style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (!widget.hasVoted && !widget.votingEnded) SizedBox(height: 3.h),

            // Voting buttons
            Row(
              children: [
                Expanded(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildVoteButton(
                          label: 'Agree with Original',
                          icon: 'thumb_up',
                          isOriginal: true,
                          isSelected: widget.hasVoted &&
                              widget.votedForOriginal == true,
                          onTap: () => _handleVote(true),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildVoteButton(
                          label: 'Agree with Response',
                          icon: 'thumb_up',
                          isOriginal: false,
                          isSelected: widget.hasVoted &&
                              widget.votedForOriginal == false,
                          onTap: () => _handleVote(false),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Voting status
            if (widget.hasVoted || widget.votingEnded)
              Container(
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.symmetric(
                  horizontal: 3.w,
                  vertical: 1.h,
                ),
                decoration: BoxDecoration(
                  color: widget.votingEnded
                      ? AppTheme.errorRed.withValues(alpha: 0.1)
                      : AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName:
                          widget.votingEnded ? 'schedule' : 'check_circle',
                      color: widget.votingEnded
                          ? AppTheme.errorRed
                          : AppTheme.successGreen,
                      size: 4.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      widget.votingEnded
                          ? 'Voting has ended'
                          : 'Thank you for voting!',
                      style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                        color: widget.votingEnded
                            ? AppTheme.errorRed
                            : AppTheme.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoteButton({
    required String label,
    required String icon,
    required bool isOriginal,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDisabled = widget.hasVoted || widget.votingEnded;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 2.h,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryOrange
              : isDisabled
                  ? AppTheme.borderGray
                  : AppTheme.deepCharcoal,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryOrange
                : isDisabled
                    ? AppTheme.borderGray
                    : AppTheme.primaryOrange.withValues(alpha: 0.5),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: icon,
              color: isSelected
                  ? AppTheme.pureBlack
                  : isDisabled
                      ? AppTheme.textSecondary
                      : AppTheme.primaryOrange,
              size: 6.w,
            ),
            SizedBox(height: 1.h),
            Text(
              label,
              style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.pureBlack
                    : isDisabled
                        ? AppTheme.textSecondary
                        : AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
