import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BattleVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final String creatorName;
  final String creatorAvatar;
  final int votes;
  final double votePercentage;
  final bool isLeftSide;
  final bool hasUserVoted;
  final bool isUserChoice;
  final VoidCallback? onVote;
  final VoidCallback? onLike;
  final VoidCallback? onFullScreen;

  const BattleVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.creatorName,
    required this.creatorAvatar,
    required this.votes,
    required this.votePercentage,
    required this.isLeftSide,
    this.hasUserVoted = false,
    this.isUserChoice = false,
    this.onVote,
    this.onLike,
    this.onFullScreen,
  });

  @override
  State<BattleVideoPlayer> createState() => _BattleVideoPlayerState();
}

class _BattleVideoPlayerState extends State<BattleVideoPlayer> {
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isLiked = false;

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    HapticFeedback.lightImpact();
  }

  void _handleDoubleTap() {
    setState(() {
      _isLiked = !_isLiked;
    });
    widget.onLike?.call();
    HapticFeedback.mediumImpact();
  }

  void _handleSingleTap() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: _handleSingleTap,
        onDoubleTap: _handleDoubleTap,
        onLongPress: widget.onFullScreen,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.pureBlack,
            border: Border(
              right: widget.isLeftSide
                  ? BorderSide(color: AppTheme.borderGray, width: 0.5)
                  : BorderSide.none,
              left: !widget.isLeftSide
                  ? BorderSide(color: AppTheme.borderGray, width: 0.5)
                  : BorderSide.none,
            ),
          ),
          child: Stack(
            children: [
              // Video placeholder with thumbnail
              Positioned.fill(
                child: CustomImageWidget(
                  imageUrl: widget.videoUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  semanticLabel:
                      "Video thumbnail showing ${widget.creatorName}'s battle entry",
                ),
              ),

              // Play/Pause overlay
              if (_showControls)
                Center(
                  child: GestureDetector(
                    onTap: _togglePlayPause,
                    child: Container(
                      width: 60.w,
                      height: 60.w,
                      decoration: BoxDecoration(
                        color: AppTheme.pureBlack.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: _isPlaying ? 'pause' : 'play_arrow',
                        color: AppTheme.textPrimary,
                        size: 32,
                      ),
                    ),
                  ),
                ),

              // Creator info overlay (top)
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: widget.isUserChoice
                              ? AppTheme.primaryOrange
                              : AppTheme.textSecondary,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: widget.creatorAvatar,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          semanticLabel:
                              "Profile photo of ${widget.creatorName}",
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.creatorName,
                            style: AppTheme.darkTheme.textTheme.titleSmall
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.pureBlack.withValues(
                                        alpha: 0.8,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${widget.votes} votes',
                            style: AppTheme.darkTheme.textTheme.bodySmall
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                  shadows: [
                                    Shadow(
                                      color: AppTheme.pureBlack.withValues(
                                        alpha: 0.8,
                                      ),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Vote percentage bar (bottom)
              Positioned(
                bottom: 80,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.votePercentage.toStringAsFixed(1)}%',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.w700,
                        shadows: [
                          Shadow(
                            color: AppTheme.pureBlack.withValues(alpha: 0.8),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppTheme.borderGray,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.votePercentage / 100,
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.isUserChoice
                                ? AppTheme.primaryOrange
                                : AppTheme.textSecondary,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Vote button (bottom)
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  onPressed: widget.hasUserVoted ? null : widget.onVote,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.isUserChoice
                        ? AppTheme.primaryOrange
                        : (widget.hasUserVoted
                              ? AppTheme.borderGray
                              : AppTheme.elevatedSurface),
                    foregroundColor: widget.isUserChoice
                        ? AppTheme.pureBlack
                        : AppTheme.textPrimary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: widget.isUserChoice
                          ? BorderSide.none
                          : BorderSide(color: AppTheme.borderGray, width: 1),
                    ),
                  ),
                  child: Text(
                    widget.hasUserVoted
                        ? (widget.isUserChoice ? 'Your Vote' : 'Voted')
                        : 'Vote',
                    style: AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Like animation overlay
              if (_isLiked)
                Positioned.fill(
                  child: IgnorePointer(
                    child: AnimatedOpacity(
                      opacity: _isLiked ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'favorite',
                          color: AppTheme.primaryOrange,
                          size: 80,
                        ),
                      ),
                      onEnd: () {
                        if (mounted) {
                          setState(() {
                            _isLiked = false;
                          });
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
