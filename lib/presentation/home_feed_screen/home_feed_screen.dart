import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/custom_tab_bar.dart';
import './widgets/comment_bottom_sheet_widget.dart';
import './widgets/context_menu_widget.dart';
import './widgets/video_overlay_widget.dart';
import './widgets/video_player_widget.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController _tabController;
  int _currentVideoIndex = 0;
  int _currentTabIndex = 0;
  bool _isRefreshing = false;
  bool _showContextMenu = false;
  Set<int> _likedVideos = {};
  bool _isMuted = false;

  final List<Map<String, dynamic>> _feedVideos = [
    {
      "id": 1,
      "videoUrl": "https://images.unsplash.com/photo-1548517640-5f2618184d5e",
      "caption":
          "Amazing dance moves! Check out this incredible choreography 🔥",
      "hashtags": ["dance", "viral", "trending", "moves"],
      "likes": 12500,
      "comments": 890,
      "shares": 234,
      "creator": {
        "id": 1,
        "username": "dancemaster_alex",
        "avatar":
            "https://images.unsplash.com/photo-1727510488556-bc3d8dcdeeb6",
        "avatarSemanticLabel":
            "Young man with curly hair wearing a black t-shirt, smiling at camera in studio lighting",
      },
      "comments_list": [
        {
          "id": 1,
          "username": "sarah_moves",
          "userAvatar":
              "https://images.unsplash.com/photo-1609512236252-f2abe56cfd2f",
          "userAvatarSemanticLabel":
              "Woman with long brown hair wearing white top, professional headshot",
          "text":
              "This is absolutely incredible! How long did it take you to learn this routine?",
          "timeAgo": "2h",
          "likes": 45,
        },
        {
          "id": 2,
          "username": "mike_dancer",
          "userAvatar":
              "https://images.unsplash.com/photo-1632822778841-1f725244f233",
          "userAvatarSemanticLabel":
              "Athletic man with short hair in gray shirt, outdoor portrait",
          "text": "The footwork at 0:15 is insane! Tutorial please? 🙏",
          "timeAgo": "4h",
          "likes": 23,
        },
      ],
    },
    {
      "id": 2,
      "videoUrl":
          "https://images.unsplash.com/photo-1578686925518-0781064fee63",
      "caption":
          "Cooking hack that will blow your mind! Who else is trying this tonight? 👨‍🍳",
      "hashtags": ["cooking", "foodhack", "recipe", "viral"],
      "likes": 8900,
      "comments": 567,
      "shares": 189,
      "creator": {
        "id": 2,
        "username": "chef_maria",
        "avatar":
            "https://images.unsplash.com/photo-1659354219212-b9ec7231ec6a",
        "avatarSemanticLabel":
            "Professional chef woman with dark hair in white chef coat, kitchen background",
      },
      "comments_list": [
        {
          "id": 3,
          "username": "foodie_jenny",
          "userAvatar":
              "https://images.unsplash.com/photo-1717454396563-a8e605c98a86",
          "userAvatarSemanticLabel":
              "Young woman with blonde hair wearing casual blue top, bright smile",
          "text":
              "Just tried this and it actually works! My family was amazed 😍",
          "timeAgo": "1h",
          "likes": 78,
        },
      ],
    },
    {
      "id": 3,
      "videoUrl":
          "https://images.unsplash.com/photo-1472725485116-45d54945b877",
      "caption":
          "Street art in progress! Watch this masterpiece come to life ✨",
      "hashtags": ["art", "streetart", "creative", "painting"],
      "likes": 15600,
      "comments": 1200,
      "shares": 445,
      "creator": {
        "id": 3,
        "username": "urban_artist",
        "avatar":
            "https://images.unsplash.com/photo-1602806272640-d9d521628b2c",
        "avatarSemanticLabel":
            "Artist with paint-stained hands holding brush, wearing denim jacket with creative patches",
      },
      "comments_list": [
        {
          "id": 4,
          "username": "art_lover_sam",
          "userAvatar":
              "https://images.unsplash.com/photo-1711987003255-2c3f351e1048",
          "userAvatarSemanticLabel":
              "Man with glasses and beard wearing black sweater, artistic background",
          "text":
              "The detail work is phenomenal! How many hours did this take?",
          "timeAgo": "3h",
          "likes": 156,
        },
        {
          "id": 5,
          "username": "creative_soul",
          "userAvatar":
              "https://images.unsplash.com/photo-1708789353477-794bd17363ab",
          "userAvatarSemanticLabel":
              "Creative woman with colorful hair wearing artistic jewelry, studio portrait",
          "text": "This is why I love street art! Pure talent and passion 🎨",
          "timeAgo": "5h",
          "likes": 89,
        },
      ],
    },
    {
      "id": 4,
      "videoUrl":
          "https://images.unsplash.com/photo-1569929233923-6882f8ef2ac1",
      "caption":
          "Fitness motivation Monday! Who's ready to crush their goals? 💪",
      "hashtags": ["fitness", "motivation", "workout", "health"],
      "likes": 9800,
      "comments": 445,
      "shares": 167,
      "creator": {
        "id": 4,
        "username": "fit_coach_ryan",
        "avatar":
            "https://images.unsplash.com/photo-1699258341039-d76ffedb6501",
        "avatarSemanticLabel":
            "Muscular fitness trainer in athletic wear, gym environment with equipment visible",
      },
      "comments_list": [
        {
          "id": 6,
          "username": "gym_enthusiast",
          "userAvatar":
              "https://images.unsplash.com/photo-1581460464579-910115ff807c",
          "userAvatarSemanticLabel":
              "Athletic woman in workout clothes with towel around neck, gym setting",
          "text": "Just what I needed to see today! Time to hit the gym 🔥",
          "timeAgo": "30m",
          "likes": 34,
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 4, vsync: this);
    _preloadVideos();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _preloadVideos() {
    // Simulate video preloading
    for (int i = 0; i < _feedVideos.length; i++) {
      // In a real app, this would preload video data
    }
  }

  Future<void> _refreshFeed() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    HapticFeedback.lightImpact();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    Fluttertoast.showToast(
      msg: "Feed refreshed!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.elevatedSurface,
      textColor: AppTheme.textPrimary,
    );
  }

  void _handleVideoLike(int videoId) {
    setState(() {
      if (_likedVideos.contains(videoId)) {
        _likedVideos.remove(videoId);
        _feedVideos[_currentVideoIndex]["likes"] =
            (_feedVideos[_currentVideoIndex]["likes"] as int) - 1;
      } else {
        _likedVideos.add(videoId);
        _feedVideos[_currentVideoIndex]["likes"] =
            (_feedVideos[_currentVideoIndex]["likes"] as int) + 1;
      }
    });
  }

  void _handleComment() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheetWidget(
        comments: (_feedVideos[_currentVideoIndex]["comments_list"] as List)
            .cast<Map<String, dynamic>>(),
        onAddComment: (comment) {
          setState(() {
            final newComment = {
              "id": DateTime.now().millisecondsSinceEpoch,
              "username": "you",
              "userAvatar":
                  "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg",
              "userAvatarSemanticLabel":
                  "Your profile avatar showing a friendly face",
              "text": comment,
              "timeAgo": "now",
              "likes": 0,
            };
            (_feedVideos[_currentVideoIndex]["comments_list"] as List).insert(
              0,
              newComment,
            );
            _feedVideos[_currentVideoIndex]["comments"] =
                (_feedVideos[_currentVideoIndex]["comments"] as int) + 1;
          });
        },
      ),
    );
  }

  void _handleShare() {
    HapticFeedback.mediumImpact();
    setState(() {
      _feedVideos[_currentVideoIndex]["shares"] =
          (_feedVideos[_currentVideoIndex]["shares"] as int) + 1;
    });

    Fluttertoast.showToast(
      msg: "Video shared!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.elevatedSurface,
      textColor: AppTheme.textPrimary,
    );
  }

  void _handleChallenge() {
    Navigator.pushNamed(context, '/challenge-screen');
  }

  void _handleProfileTap() {
    Navigator.pushNamed(context, '/profile-screen');
  }

  void _handleLongPress() {
    HapticFeedback.mediumImpact();
    setState(() {
      _showContextMenu = true;
    });
  }

  void _handleNotInterested() {
    Fluttertoast.showToast(
      msg: "We'll show you fewer videos like this",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.elevatedSurface,
      textColor: AppTheme.textPrimary,
    );
  }

  void _handleReport() {
    Fluttertoast.showToast(
      msg: "Content reported. Thank you for your feedback.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.elevatedSurface,
      textColor: AppTheme.textPrimary,
    );
  }

  void _handleSave() {
    Fluttertoast.showToast(
      msg: "Video saved to your collection",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppTheme.elevatedSurface,
      textColor: AppTheme.textPrimary,
    );
  }

  void _handleTabChange(int index) {
    setState(() {
      _currentTabIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/competition-list-screen');
        break;
      case 2:
        Navigator.pushNamed(context, '/debate-list-screen');
        break;
      case 3:
        Navigator.pushNamed(context, '/profile-screen');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      body: Stack(
        children: [
          // Main video feed
          RefreshIndicator(
            onRefresh: _refreshFeed,
            color: AppTheme.primaryOrange,
            backgroundColor: AppTheme.elevatedSurface,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  _currentVideoIndex = index;
                });
              },
              itemCount: _feedVideos.length,
              itemBuilder: (context, index) {
                final video = _feedVideos[index];
                return Stack(
                  children: [
                    // Video player
                    VideoPlayerWidget(
                      videoUrl: video["videoUrl"] as String,
                      isPlaying: index == _currentVideoIndex,
                      isMuted: _isMuted,
                      onDoubleTap: () => _handleVideoLike(video["id"] as int),
                      onLongPress: _handleLongPress,
                      onPlayingChanged: (isPlaying) {
                        // Handle play/pause state
                      },
                    ),
                    // Video overlay
                    VideoOverlayWidget(
                      videoData: video,
                      onLike: () => _handleVideoLike(video["id"] as int),
                      onComment: _handleComment,
                      onShare: _handleShare,
                      onChallenge: _handleChallenge,
                      onProfileTap: _handleProfileTap,
                      isLiked: _likedVideos.contains(video["id"] as int),
                      isMuted: _isMuted,
                      onMuteToggle: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          // Tab bar
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: CustomTabBar(
                variant: TabBarVariant.minimal,
                controller: _tabController,
                tabs: const [
                  CustomTab(text: 'Home', icon: Icons.home),
                  CustomTab(text: 'Compete', icon: Icons.emoji_events),
                  CustomTab(text: 'Debates', icon: Icons.forum),
                  CustomTab(text: 'Profile', icon: Icons.person),
                ],
                onTap: _handleTabChange,
                backgroundColor: Colors.transparent,
                height: 6.h,
              ),
            ),
          ),
          // Context menu overlay
          if (_showContextMenu)
            ContextMenuWidget(
              onNotInterested: _handleNotInterested,
              onReport: _handleReport,
              onSave: _handleSave,
              onClose: () {
                setState(() {
                  _showContextMenu = false;
                });
              },
            ),
          // Loading indicator
          if (_isRefreshing)
            Positioned(
              top: 15.h,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppTheme.elevatedSurface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 5.w,
                        height: 5.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppTheme.primaryOrange,
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        'Refreshing feed...',
                        style: AppTheme.darkTheme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(
        variant: BottomBarVariant.standard,
        currentRoute: '/home-feed-screen',
        onRouteChanged: (route) {
          if (route != '/home-feed-screen') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
