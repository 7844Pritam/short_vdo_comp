import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';
import './widgets/debate_topic_header_widget.dart';
import './widgets/debate_video_player_widget.dart';
import './widgets/response_thumbnails_widget.dart';
import './widgets/voting_buttons_widget.dart';

class DebateDetailScreen extends StatefulWidget {
  const DebateDetailScreen({super.key});

  @override
  State<DebateDetailScreen> createState() => _DebateDetailScreenState();
}

class _DebateDetailScreenState extends State<DebateDetailScreen>
    with TickerProviderStateMixin {
  int _selectedResponseIndex = 0;
  bool _hasVoted = false;
  bool? _votedForOriginal;
  bool _showComments = false;

  // Mock data for debate
  final Map<String, dynamic> _debateData = {
    "id": 1,
    "topic":
        "Should artificial intelligence replace human teachers in schools?",
    "participantCount": 47,
    "responseCount": 23,
    "votingDeadline": DateTime.now().add(const Duration(days: 2, hours: 5)),
    "originalVideo": {
      "id": 1,
      "videoUrl":
          "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      "creatorName": "Dr. Sarah Chen",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1654727169791-7f46d0dfc1a3",
      "creatorAvatarSemanticLabel":
          "Professional headshot of Asian woman with short black hair wearing glasses and navy blazer",
      "argumentSummary":
          "AI can provide personalized learning experiences and 24/7 availability, making education more accessible and efficient for all students.",
      "voteCount": 156,
      "totalVotes": 289,
    },
    "responses": [
      {
        "id": 2,
        "videoUrl":
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",
        "creatorName": "Prof. Michael Rodriguez",
        "creatorAvatar":
            "https://images.unsplash.com/photo-1714974528889-d51109fb6ae9",
        "creatorAvatarSemanticLabel":
            "Professional headshot of Hispanic man with beard wearing dark suit and tie",
        "argumentSummary":
            "Human teachers provide emotional intelligence, creativity, and social skills that AI cannot replicate in educational environments.",
        "voteCount": 133,
        "totalVotes": 289,
        "thumbnail":
            "https://images.unsplash.com/photo-1716544940666-a72a38e1bb07",
        "thumbnailSemanticLabel":
            "Male teacher in classroom pointing at whiteboard with mathematical equations",
        "duration": "2:45",
      },
      {
        "id": 3,
        "videoUrl":
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4",
        "creatorName": "Emma Thompson",
        "creatorAvatar":
            "https://images.unsplash.com/photo-1666256068603-8c7ece868b00",
        "creatorAvatarSemanticLabel":
            "Young woman with blonde hair in casual blue shirt smiling at camera",
        "argumentSummary":
            "A hybrid approach combining AI efficiency with human mentorship creates the best learning environment for students.",
        "voteCount": 98,
        "totalVotes": 289,
        "thumbnail":
            "https://images.unsplash.com/photo-1694532409273-b26e2ce266ea",
        "thumbnailSemanticLabel":
            "Female teacher using tablet device while teaching young students in modern classroom",
        "duration": "3:12",
      },
      {
        "id": 4,
        "videoUrl":
            "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4",
        "creatorName": "James Wilson",
        "creatorAvatar":
            "https://images.unsplash.com/photo-1723607528434-21cde67167c4",
        "creatorAvatarSemanticLabel":
            "Middle-aged man with brown hair in professional white shirt",
        "argumentSummary":
            "Technology should enhance education, not replace the irreplaceable human connection between teacher and student.",
        "voteCount": 87,
        "totalVotes": 289,
        "thumbnail":
            "https://images.unsplash.com/photo-1653565685072-adcf967db6b7",
        "thumbnailSemanticLabel":
            "Teacher helping student with laptop computer in bright classroom setting",
        "duration": "2:28",
      },
    ],
  };

  final List<Map<String, dynamic>> _comments = [
    {
      "id": 1,
      "userName": "Alex Johnson",
      "userAvatar":
          "https://images.unsplash.com/photo-1586233520239-56a30d0b714e",
      "userAvatarSemanticLabel":
          "Young man with short brown hair wearing casual t-shirt",
      "comment":
          "Great points on both sides! I think the hybrid approach makes the most sense.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "likes": 12,
    },
    {
      "id": 2,
      "userName": "Maria Garcia",
      "userAvatar":
          "https://images.unsplash.com/photo-1735653103823-a993da5a2cf7",
      "userAvatarSemanticLabel":
          "Hispanic woman with long dark hair wearing professional attire",
      "comment":
          "As a teacher myself, I can confirm that emotional intelligence is crucial in education.",
      "timestamp": DateTime.now().subtract(const Duration(hours: 4)),
      "likes": 8,
    },
  ];

  Map<String, dynamic> get _currentResponse {
    return (_debateData["responses"] as List)[_selectedResponseIndex];
  }

  void _handleVote(bool isOriginal) {
    HapticFeedback.mediumImpact();
    setState(() {
      _hasVoted = true;
      _votedForOriginal = isOriginal;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Vote recorded! Thank you for participating.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleResponseSelection(int index) {
    setState(() {
      _selectedResponseIndex = index;
    });
  }

  void _handleFullScreen() {
    HapticFeedback.lightImpact();
    // Navigate to full screen video player
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.pureBlack,
          body: Center(
            child: Text(
              'Full Screen Video Player\n(Implementation pending)',
              style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  void _showCommentsBottomSheet() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCommentsBottomSheet(),
    );
  }

  void _handleAddResponse() {
    HapticFeedback.lightImpact();
    // Navigate to video recording screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening video recorder...',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _handleShare() {
    HapticFeedback.lightImpact();
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Creating debate highlight reel...',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textPrimary,
          ),
        ),
        backgroundColor: AppTheme.primaryOrange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      appBar: CustomAppBar(
        variant: AppBarVariant.transparent,
        title: 'Debate',
        centerTitle: true,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
            onPressed: _handleShare,
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'comment',
              color: AppTheme.textPrimary,
              size: 6.w,
            ),
            onPressed: _showCommentsBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Debate topic header
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: DebateTopicHeaderWidget(
                      topicTitle: _debateData["topic"] as String,
                      participantCount: _debateData["participantCount"] as int,
                      responseCount: _debateData["responseCount"] as int,
                      votingDeadline: _debateData["votingDeadline"] as DateTime,
                    ),
                  ),

                  // Original video player
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: DebateVideoPlayerWidget(
                      videoUrl: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["videoUrl"] as String,
                      creatorName: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["creatorName"] as String,
                      creatorAvatar: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["creatorAvatar"] as String,
                      argumentSummary: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["argumentSummary"] as String,
                      voteCount: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["voteCount"] as int,
                      totalVotes: (_debateData["originalVideo"]
                          as Map<String, dynamic>)["totalVotes"] as int,
                      isOriginal: true,
                      onFullScreen: _handleFullScreen,
                      onVote: () => _handleVote(true),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Central divider with VS indicator
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 1.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.elevatedSurface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.primaryOrange,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      'VS',
                      style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Response video player
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: DebateVideoPlayerWidget(
                      videoUrl: _currentResponse["videoUrl"] as String,
                      creatorName: _currentResponse["creatorName"] as String,
                      creatorAvatar:
                          _currentResponse["creatorAvatar"] as String,
                      argumentSummary:
                          _currentResponse["argumentSummary"] as String,
                      voteCount: _currentResponse["voteCount"] as int,
                      totalVotes: _currentResponse["totalVotes"] as int,
                      isOriginal: false,
                      onFullScreen: _handleFullScreen,
                      onVote: () => _handleVote(false),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Response thumbnails
                  ResponseThumbnailsWidget(
                    responses:
                        _debateData["responses"] as List<Map<String, dynamic>>,
                    selectedIndex: _selectedResponseIndex,
                    onResponseSelected: _handleResponseSelection,
                  ),

                  SizedBox(height: 3.h),

                  // Add Response button
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handleAddResponse,
                        icon: CustomIconWidget(
                          iconName: 'add_circle',
                          color: AppTheme.pureBlack,
                          size: 5.w,
                        ),
                        label: Text(
                          'Add Your Response',
                          style:
                              AppTheme.darkTheme.textTheme.labelLarge?.copyWith(
                            color: AppTheme.pureBlack,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryOrange,
                          foregroundColor: AppTheme.pureBlack,
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h), // Space for bottom voting buttons
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VotingButtonsWidget(
            onVote: _handleVote,
            hasVoted: _hasVoted,
            votedForOriginal: _votedForOriginal,
            votingEnded: DateTime.now()
                .isAfter(_debateData["votingDeadline"] as DateTime),
          ),
          CustomBottomBar(
            currentRoute: '/debate-detail-screen',
            onRouteChanged: (route) {
              if (route != '/debate-detail-screen') {
                Navigator.pushReplacementNamed(context, route);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsBottomSheet() {
    return Container(
      height: 70.h,
      decoration: const BoxDecoration(
        color: AppTheme.elevatedSurface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: AppTheme.borderGray,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Comments',
                  style: AppTheme.darkTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_comments.length} comments',
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: AppTheme.borderGray,
            height: 1,
          ),

          // Comments list
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(4.w),
              itemCount: _comments.length,
              separatorBuilder: (context, index) => SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return _buildCommentItem(comment);
              },
            ),
          ),

          // Comment input
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.deepCharcoal,
              border: Border(
                top: BorderSide(
                  color: AppTheme.borderGray,
                  width: 1,
                ),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        hintStyle:
                            AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: AppTheme.borderGray,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                      ),
                      style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      // Handle comment submission
                    },
                    icon: CustomIconWidget(
                      iconName: 'send',
                      color: AppTheme.primaryOrange,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomImageWidget(
          imageUrl: comment["userAvatar"] as String,
          width: 10.w,
          height: 10.w,
          fit: BoxFit.cover,
          semanticLabel: comment["userAvatarSemanticLabel"] as String,
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment["userName"] as String,
                    style: AppTheme.darkTheme.textTheme.labelMedium?.copyWith(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatTimestamp(comment["timestamp"] as DateTime),
                    style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                comment["comment"] as String,
                style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Handle like
                    },
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'thumb_up_outlined',
                          color: AppTheme.textSecondary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          comment["likes"].toString(),
                          style:
                              AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 4.w),
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // Handle reply
                    },
                    child: Text(
                      'Reply',
                      style: AppTheme.darkTheme.textTheme.labelSmall?.copyWith(
                        color: AppTheme.primaryOrange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}
