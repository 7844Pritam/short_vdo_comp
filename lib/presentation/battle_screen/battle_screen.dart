import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/battle_bottom_actions.dart';
import './widgets/battle_comment_sheet.dart';
import './widgets/battle_header.dart';
import './widgets/battle_video_player.dart';
import './widgets/battle_vs_divider.dart';

class BattleScreen extends StatefulWidget {
  const BattleScreen({super.key});

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  bool _hasUserVoted = false;
  int _userVoteChoice = -1; // -1: no vote, 0: left video, 1: right video
  bool _showWinner = false;
  String? _winnerName;

  // Mock battle data
  final Map<String, dynamic> _battleData = {
    "id": "battle_001",
    "title": "Ultimate Dance Battle: Hip-Hop Showdown",
    "category": "Dance",
    "status": "Live",
    "timeRemaining": "2h 45m",
    "totalVotes": 15847,
    "endTime": DateTime.now().add(const Duration(hours: 2, minutes: 45)),
    "leftCompetitor": {
      "id": "user_001",
      "username": "DanceMaster_Alex",
      "avatar":
          "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face",
      "videoUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400&h=600&fit=crop",
      "votes": 8234,
      "votePercentage": 52.0,
    },
    "rightCompetitor": {
      "id": "user_002",
      "username": "UrbanGroove_Maya",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face",
      "videoUrl":
          "https://images.unsplash.com/photo-1574391884720-bbc2f1b5b4b4?w=400&h=600&fit=crop",
      "votes": 7613,
      "votePercentage": 48.0,
    },
  };

  final List<Map<String, dynamic>> _comments = [
    {
      "id": "comment_001",
      "username": "HipHopFan23",
      "avatar": "https://images.unsplash.com/photo-1619394441486-c9392cc696b2",
      "text":
          "Alex's moves are absolutely insane! That backflip combo was perfect 🔥",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 15)),
      "likes": 42,
    },
    {
      "id": "comment_002",
      "username": "DanceQueen_Sophia",
      "avatar": "https://images.unsplash.com/photo-1673447042805-7a3b1096f3a7",
      "text":
          "Maya's flow is unmatched! The way she transitions between moves is so smooth",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 8)),
      "likes": 38,
    },
    {
      "id": "comment_003",
      "username": "BreakdanceKing",
      "avatar": "https://images.unsplash.com/photo-1656004494173-308da4c9cf84",
      "text":
          "This is the closest battle I've seen all month! Both are bringing their A-game 💯",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 3)),
      "likes": 67,
    },
    {
      "id": "comment_004",
      "username": "UrbanVibes_Jake",
      "avatar": "https://images.unsplash.com/photo-1604250929878-84cf006e0d75",
      "text":
          "The energy in both videos is incredible! Can't decide who to vote for 😅",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 1)),
      "likes": 23,
    },
  ];

  @override
  void initState() {
    super.initState();
    _checkBattleStatus();
  }

  void _checkBattleStatus() {
    // Simulate battle ending and winner announcement
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final leftVotes =
            (_battleData['leftCompetitor'] as Map<String, dynamic>)['votes']
                as int;
        final rightVotes =
            (_battleData['rightCompetitor'] as Map<String, dynamic>)['votes']
                as int;

        if (leftVotes > rightVotes) {
          setState(() {
            _showWinner = true;
            _winnerName =
                (_battleData['leftCompetitor']
                        as Map<String, dynamic>)['username']
                    as String;
          });
        } else {
          setState(() {
            _showWinner = true;
            _winnerName =
                (_battleData['rightCompetitor']
                        as Map<String, dynamic>)['username']
                    as String;
          });
        }
      }
    });
  }

  void _handleVote(int choice) {
    if (_hasUserVoted) return;

    setState(() {
      _hasUserVoted = true;
      _userVoteChoice = choice;

      // Update vote counts
      final leftCompetitor =
          _battleData['leftCompetitor'] as Map<String, dynamic>;
      final rightCompetitor =
          _battleData['rightCompetitor'] as Map<String, dynamic>;

      if (choice == 0) {
        leftCompetitor['votes'] = (leftCompetitor['votes'] as int) + 1;
      } else {
        rightCompetitor['votes'] = (rightCompetitor['votes'] as int) + 1;
      }

      // Recalculate percentages
      final totalVotes =
          (leftCompetitor['votes'] as int) + (rightCompetitor['votes'] as int);
      leftCompetitor['votePercentage'] =
          ((leftCompetitor['votes'] as int) / totalVotes * 100);
      rightCompetitor['votePercentage'] =
          ((rightCompetitor['votes'] as int) / totalVotes * 100);
      _battleData['totalVotes'] = totalVotes;
    });

    HapticFeedback.mediumImpact();
  }

  void _handleShare() {
    // Simulate native sharing
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Battle shared successfully!'),
        backgroundColor: AppTheme.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BattleCommentSheet(
        comments: _comments,
        onAddComment: (comment) {
          setState(() {
            _comments.insert(0, {
              "id": "comment_${DateTime.now().millisecondsSinceEpoch}",
              "username": "You",
              "avatar":
                  "https://images.unsplash.com/photo-1633332755192-727a05c4013d?w=150&h=150&fit=crop&crop=face",
              "text": comment,
              "timestamp": DateTime.now(),
              "likes": 0,
            });
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _handleReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        title: Text(
          'Report Battle',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to report this battle for inappropriate content?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Battle reported successfully'),
                  backgroundColor: AppTheme.warningOrange,
                ),
              );
            },
            child: Text('Report', style: TextStyle(color: AppTheme.errorRed)),
          ),
        ],
      ),
    );
  }

  void _handleVideoLike(int videoIndex) {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          videoIndex == 0 ? 'Liked Alex\'s video!' : 'Liked Maya\'s video!',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleFullScreen(int videoIndex) {
    final competitor = videoIndex == 0
        ? _battleData['leftCompetitor'] as Map<String, dynamic>
        : _battleData['rightCompetitor'] as Map<String, dynamic>;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.pureBlack,
          body: Stack(
            children: [
              Center(
                child: CustomImageWidget(
                  imageUrl: competitor['videoUrl'] as String,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                  semanticLabel:
                      "Full screen view of ${competitor['username']}'s battle video",
                ),
              ),
              Positioned(
                top: 8.h,
                left: 4.w,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.pureBlack.withValues(alpha: 0.7),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.textPrimary,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leftCompetitor =
        _battleData['leftCompetitor'] as Map<String, dynamic>;
    final rightCompetitor =
        _battleData['rightCompetitor'] as Map<String, dynamic>;

    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      body: Stack(
        children: [
          // Main battle content
          Column(
            children: [
              // Video players section
              Expanded(
                child: Row(
                  children: [
                    // Left competitor video
                    BattleVideoPlayer(
                      videoUrl: leftCompetitor['videoUrl'] as String,
                      creatorName: leftCompetitor['username'] as String,
                      creatorAvatar: leftCompetitor['avatar'] as String,
                      votes: leftCompetitor['votes'] as int,
                      votePercentage:
                          leftCompetitor['votePercentage'] as double,
                      isLeftSide: true,
                      hasUserVoted: _hasUserVoted,
                      isUserChoice: _userVoteChoice == 0,
                      onVote: () => _handleVote(0),
                      onLike: () => _handleVideoLike(0),
                      onFullScreen: () => _handleFullScreen(0),
                    ),

                    // VS divider
                    BattleVsDivider(
                      battleStatus: _battleData['status'] as String,
                      isActive: !_hasUserVoted,
                    ),

                    // Right competitor video
                    BattleVideoPlayer(
                      videoUrl: rightCompetitor['videoUrl'] as String,
                      creatorName: rightCompetitor['username'] as String,
                      creatorAvatar: rightCompetitor['avatar'] as String,
                      votes: rightCompetitor['votes'] as int,
                      votePercentage:
                          rightCompetitor['votePercentage'] as double,
                      isLeftSide: false,
                      hasUserVoted: _hasUserVoted,
                      isUserChoice: _userVoteChoice == 1,
                      onVote: () => _handleVote(1),
                      onLike: () => _handleVideoLike(1),
                      onFullScreen: () => _handleFullScreen(1),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Header overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BattleHeader(
              competitionTitle: _battleData['title'] as String,
              category: _battleData['category'] as String,
              timeRemaining: _battleData['timeRemaining'] as String,
              totalVotes: _battleData['totalVotes'] as int,
              onBack: () => Navigator.pop(context),
            ),
          ),

          // Bottom actions overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BattleBottomActions(
              onShare: _handleShare,
              onComment: _showCommentSheet,
              onReport: _handleReport,
              commentCount: _comments.length,
              hasWinner: _showWinner,
              winnerName: _winnerName,
            ),
          ),
        ],
      ),
    );
  }
}
