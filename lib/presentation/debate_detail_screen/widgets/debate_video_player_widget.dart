import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../core/app_export.dart';

class DebateVideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String creatorName;
  final String creatorAvatar;
  final String argumentSummary;
  final int voteCount;
  final int totalVotes;
  final bool isOriginal;
  final VoidCallback? onFullScreen;
  final VoidCallback? onVote;

  const DebateVideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.creatorName,
    required this.creatorAvatar,
    required this.argumentSummary,
    required this.voteCount,
    required this.totalVotes,
    this.isOriginal = false,
    this.onFullScreen,
    this.onVote,
  });

  @override
  State<DebateVideoPlayerWidget> createState() =>
      _DebateVideoPlayerWidgetState();
}

class _DebateVideoPlayerWidgetState extends State<DebateVideoPlayerWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      // Handle video initialization error
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      HapticFeedback.lightImpact();
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        setState(() => _isPlaying = false);
      } else {
        _controller!.play();
        setState(() => _isPlaying = true);
      }
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  double get _votePercentage {
    return widget.totalVotes > 0 ? (widget.voteCount / widget.totalVotes) : 0.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      onDoubleTap: () {
        HapticFeedback.mediumImpact();
        widget.onFullScreen?.call();
      },
      child: Container(
        height: 45.h,
        decoration: BoxDecoration(
          color: AppTheme.pureBlack,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            // Video Player
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: _isInitialized && _controller != null
                  ? AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    )
                  : Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: AppTheme.deepCharcoal,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryOrange,
                        ),
                      ),
                    ),
            ),

            // Play/Pause Overlay
            if (_showControls)
              Center(
                child: GestureDetector(
                  onTap: _togglePlayPause,
                  child: Container(
                    width: 15.w,
                    height: 15.w,
                    decoration: BoxDecoration(
                      color: AppTheme.pureBlack.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: _isPlaying ? 'pause' : 'play_arrow',
                      color: AppTheme.textPrimary,
                      size: 8.w,
                    ),
                  ),
                ),
              ),

            // Creator Info Overlay (Top)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.pureBlack.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    CustomImageWidget(
                      imageUrl: widget.creatorAvatar,
                      width: 8.w,
                      height: 8.w,
                      fit: BoxFit.cover,
                      semanticLabel: "Profile photo of ${widget.creatorName}",
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.creatorName,
                            style: AppTheme.darkTheme.textTheme.labelLarge
                                ?.copyWith(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            widget.isOriginal
                                ? 'Original Argument'
                                : 'Response',
                            style: AppTheme.darkTheme.textTheme.labelSmall
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Argument Summary & Vote Info (Bottom)
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: AppTheme.pureBlack.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.argumentSummary,
                      style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Votes: ${widget.voteCount}',
                                    style: AppTheme
                                        .darkTheme
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppTheme.textSecondary,
                                        ),
                                  ),
                                  Text(
                                    '${(_votePercentage * 100).toInt()}%',
                                    style: AppTheme
                                        .darkTheme
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppTheme.primaryOrange,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              LinearProgressIndicator(
                                value: _votePercentage,
                                backgroundColor: AppTheme.borderGray,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryOrange,
                                ),
                                minHeight: 0.5.h,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 3.w),
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            widget.onVote?.call();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 3.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryOrange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Vote',
                              style: AppTheme.darkTheme.textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTheme.pureBlack,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Full Screen Indicator
            if (_showControls)
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onFullScreen?.call();
                  },
                  child: Container(
                    padding: EdgeInsets.all(1.w),
                    decoration: BoxDecoration(
                      color: AppTheme.pureBlack.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: CustomIconWidget(
                      iconName: 'fullscreen',
                      color: AppTheme.textPrimary,
                      size: 5.w,
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
