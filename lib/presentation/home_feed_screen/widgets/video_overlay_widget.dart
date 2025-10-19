import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VideoOverlayWidget extends StatelessWidget {
  final Map<String, dynamic> videoData;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onChallenge;
  final VoidCallback onProfileTap;
  final bool isLiked;
  final bool isMuted;
  final VoidCallback onMuteToggle;

  const VideoOverlayWidget({
    super.key,
    required this.videoData,
    required this.onLike,
    required this.onComment,
    required this.onShare,
    required this.onChallenge,
    required this.onProfileTap,
    required this.isLiked,
    required this.isMuted,
    required this.onMuteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left side - Video info
        Positioned(
          left: 4.w,
          bottom: 20.h,
          right: 20.w,
          child: _buildVideoInfo(),
        ),
        // Right side - Action buttons
        Positioned(
          right: 3.w,
          bottom: 15.h,
          child: _buildActionButtons(),
        ),
        // Bottom - Mute toggle
        Positioned(
          right: 4.w,
          bottom: 8.h,
          child: _buildMuteButton(),
        ),
      ],
    );
  }

  Widget _buildVideoInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Creator username
        Text(
          '@${(videoData["creator"] as Map<String, dynamic>)["username"] as String}',
          style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        // Video caption
        Text(
          videoData["caption"] as String,
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 1.h),
        // Hashtags
        if ((videoData["hashtags"] as List).isNotEmpty)
          Wrap(
            spacing: 2.w,
            runSpacing: 0.5.h,
            children: (videoData["hashtags"] as List)
                .take(3)
                .map((hashtag) => Text(
                      '#${hashtag as String}',
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ))
                .toList(),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Profile avatar
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onProfileTap();
          },
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppTheme.textPrimary,
                width: 2,
              ),
            ),
            child: ClipOval(
              child: CustomImageWidget(
                imageUrl: (videoData["creator"]
                    as Map<String, dynamic>)["avatar"] as String,
                width: 12.w,
                height: 12.w,
                fit: BoxFit.cover,
                semanticLabel: (videoData["creator"]
                    as Map<String, dynamic>)["avatarSemanticLabel"] as String,
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        // Like button
        _buildActionButton(
          icon: isLiked ? 'favorite' : 'favorite_border',
          count: videoData["likes"] as int,
          onTap: () {
            HapticFeedback.lightImpact();
            onLike();
          },
          isActive: isLiked,
        ),
        SizedBox(height: 3.h),
        // Comment button
        _buildActionButton(
          icon: 'chat_bubble_outline',
          count: videoData["comments"] as int,
          onTap: () {
            HapticFeedback.lightImpact();
            onComment();
          },
        ),
        SizedBox(height: 3.h),
        // Share button
        _buildActionButton(
          icon: 'share',
          count: videoData["shares"] as int,
          onTap: () {
            HapticFeedback.lightImpact();
            onShare();
          },
        ),
        SizedBox(height: 3.h),
        // Challenge button
        GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            onChallenge();
          },
          child: Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryOrange,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryOrange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'sports_mma',
              color: AppTheme.pureBlack,
              size: 6.w,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String icon,
    required int count,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: icon,
              color: isActive ? AppTheme.primaryOrange : AppTheme.textPrimary,
              size: 7.w,
            ),
          ),
          SizedBox(height: 0.5.h),
          Text(
            _formatCount(count),
            style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
              color: AppTheme.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMuteButton() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onMuteToggle();
      },
      child: Container(
        width: 10.w,
        height: 10.w,
        decoration: BoxDecoration(
          color: AppTheme.pureBlack.withValues(alpha: 0.5),
          shape: BoxShape.circle,
        ),
        child: CustomIconWidget(
          iconName: isMuted ? 'volume_off' : 'volume_up',
          color: AppTheme.textPrimary,
          size: 5.w,
        ),
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K';
    }
    return count.toString();
  }
}
