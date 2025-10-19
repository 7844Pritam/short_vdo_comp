import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:short_video_comp/presentation/theme/app_theme.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';
import './widgets/competition_card_widget.dart';
import './widgets/competition_filter_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/loading_skeleton_widget.dart';

class CompetitionListScreen extends StatefulWidget {
  const CompetitionListScreen({super.key});

  @override
  State<CompetitionListScreen> createState() => _CompetitionListScreenState();
}

class _CompetitionListScreenState extends State<CompetitionListScreen>
    with TickerProviderStateMixin {
  String _selectedFilter = 'Active';
  bool _isSearchVisible = false;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _isRefreshing = false;

  // Mock data for competitions
  final List<Map<String, dynamic>> _allCompetitions = [
    {
      "id": 1,
      "creatorName": "Sarah Johnson",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1538464251191-da2a77410c02",
      "creatorAvatarLabel":
          "Profile photo of a young woman with blonde hair and blue eyes, wearing a white t-shirt, smiling at the camera.",
      "category": "Dance",
      "status": "active",
      "deadline": "Oct 25, 2025",
      "participantCount": 12,
      "prizePoints": 500,
      "winnerName": "",
      "description":
          "Show off your best dance moves in this freestyle competition!"
    },
    {
      "id": 2,
      "creatorName": "Mike Rodriguez",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1731419192463-5282fa729c48",
      "creatorAvatarLabel":
          "Profile photo of a Hispanic man with short black hair and a beard, wearing a dark blue shirt, looking confident.",
      "category": "Singing",
      "status": "pending",
      "deadline": "Oct 28, 2025",
      "participantCount": 8,
      "prizePoints": 750,
      "winnerName": "",
      "description":
          "Vocal challenge - sing your favorite song and compete for the top spot!"
    },
    {
      "id": 3,
      "creatorName": "Emma Chen",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1680439495896-b67cab871f39",
      "creatorAvatarLabel":
          "Profile photo of an Asian woman with long black hair, wearing glasses and a red sweater, smiling warmly.",
      "category": "Debate",
      "status": "completed",
      "deadline": "Oct 15, 2025",
      "participantCount": 15,
      "prizePoints": 1000,
      "winnerName": "Alex Thompson",
      "description":
          "Climate change debate - present your arguments and convince the audience!"
    },
    {
      "id": 4,
      "creatorName": "David Kim",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1496757046190-b51abfebe205",
      "creatorAvatarLabel":
          "Profile photo of a Korean man with short styled hair, wearing a black hoodie, looking serious and focused.",
      "category": "Dance",
      "status": "active",
      "deadline": "Nov 2, 2025",
      "participantCount": 20,
      "prizePoints": 800,
      "winnerName": "",
      "description": "Hip-hop dance battle - bring your best moves and energy!"
    },
    {
      "id": 5,
      "creatorName": "Lisa Anderson",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1658344070539-7ce8dd222666",
      "creatorAvatarLabel":
          "Profile photo of a blonde woman with curly hair, wearing a green jacket, smiling brightly outdoors.",
      "category": "Singing",
      "status": "completed",
      "deadline": "Oct 10, 2025",
      "participantCount": 25,
      "prizePoints": 1200,
      "winnerName": "Jessica Martinez",
      "description": "Pop song cover competition - showcase your vocal talent!"
    },
    {
      "id": 6,
      "creatorName": "James Wilson",
      "creatorAvatar":
          "https://images.unsplash.com/photo-1695720247431-2790feab65c0",
      "creatorAvatarLabel":
          "Profile photo of a middle-aged man with gray hair and a mustache, wearing a navy suit, looking professional.",
      "category": "Debate",
      "status": "pending",
      "deadline": "Nov 5, 2025",
      "participantCount": 6,
      "prizePoints": 900,
      "winnerName": "",
      "description":
          "Technology ethics debate - discuss the future of AI and society!"
    },
  ];

  List<Map<String, dynamic>> get _filteredCompetitions {
    List<Map<String, dynamic>> filtered = _allCompetitions.where((competition) {
      final status = competition['status'] as String? ?? '';
      final matchesFilter =
          status.toLowerCase() == _selectedFilter.toLowerCase();

      if (_searchQuery.isEmpty) return matchesFilter;

      final creatorName = competition['creatorName'] as String? ?? '';
      final category = competition['category'] as String? ?? '';
      final description = competition['description'] as String? ?? '';

      final matchesSearch =
          creatorName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              category.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              description.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesFilter && matchesSearch;
    }).toList();

    // Sort by deadline for active competitions, by completion date for completed
    filtered.sort((a, b) {
      if (_selectedFilter.toLowerCase() == 'completed') {
        return b['id'].compareTo(a['id']); // Most recent first
      }
      return a['id'].compareTo(b['id']); // Oldest first for active/pending
    });

    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _loadCompetitions();
  }

  Future<void> _loadCompetitions() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refreshCompetitions() async {
    setState(() => _isRefreshing = true);

    // Simulate refresh API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isRefreshing = false);
    }

    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureBlack,
      appBar: CustomAppBar(
        variant: AppBarVariant.solid,
        title: 'Competitions',
        backgroundColor: AppTheme.elevatedSurface,
        showNotificationAction: true,
      ),
      body: Column(
        children: [
          CompetitionFilterWidget(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
                _searchQuery = '';
                _isSearchVisible = false;
              });
              HapticFeedback.lightImpact();
            },
            isSearchVisible: _isSearchVisible,
            onSearchVisibilityChanged: (visible) {
              setState(() => _isSearchVisible = visible);
            },
            searchQuery: _searchQuery,
            onSearchChanged: (query) {
              setState(() => _searchQuery = query);
            },
          ),
          Expanded(
            child: _buildCompetitionsList(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: const CustomBottomBar(
        currentRoute: '/competition-list-screen',
        variant: BottomBarVariant.standard,
      ),
    );
  }

  Widget _buildCompetitionsList() {
    if (_isLoading) {
      return const LoadingSkeletonWidget();
    }

    final competitions = _filteredCompetitions;

    if (competitions.isEmpty) {
      return EmptyStateWidget(
        category: _selectedFilter,
        onCreateChallenge: _navigateToChallenge,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshCompetitions,
      color: AppTheme.primaryOrange,
      backgroundColor: AppTheme.elevatedSurface,
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 1.h),
        itemCount: competitions.length,
        itemBuilder: (context, index) {
          final competition = competitions[index];
          return _buildCompetitionItem(competition);
        },
      ),
    );
  }

  Widget _buildCompetitionItem(Map<String, dynamic> competition) {
    final status = competition['status'] as String? ?? '';

    if (status.toLowerCase() == 'pending') {
      return Slidable(
        key: ValueKey(competition['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.mediumImpact();
                _handleDeclineCompetition(competition);
              },
              backgroundColor: AppTheme.errorRed,
              foregroundColor: AppTheme.textPrimary,
              icon: Icons.close,
              label: 'Decline',
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            SlidableAction(
              onPressed: (context) {
                HapticFeedback.mediumImpact();
                _handleAcceptCompetition(competition);
              },
              backgroundColor: AppTheme.successGreen,
              foregroundColor: AppTheme.pureBlack,
              icon: Icons.check,
              label: 'Accept',
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
          ],
        ),
        child: _buildCompetitionCard(competition),
      );
    }

    return _buildCompetitionCard(competition);
  }

  Widget _buildCompetitionCard(Map<String, dynamic> competition) {
    return CompetitionCardWidget(
      competition: competition,
      onTap: () => _handleCompetitionTap(competition),
      onSubmitResponse: () => _handleSubmitResponse(competition),
      onAccept: () => _handleAcceptCompetition(competition),
      onDecline: () => _handleDeclineCompetition(competition),
      onViewResults: () => _handleViewResults(competition),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        _navigateToChallenge();
      },
      backgroundColor: AppTheme.primaryOrange,
      foregroundColor: AppTheme.pureBlack,
      elevation: 6,
      child: CustomIconWidget(
        iconName: 'add',
        color: AppTheme.pureBlack,
        size: 28,
      ),
    );
  }

  void _handleCompetitionTap(Map<String, dynamic> competition) {
    final status = competition['status'] as String? ?? '';

    if (status.toLowerCase() == 'completed') {
      _handleViewResults(competition);
    } else {
      // Show competition details or navigate to appropriate screen
      _showCompetitionDetails(competition);
    }
  }

  void _handleSubmitResponse(Map<String, dynamic> competition) {
    // Navigate to video recording/upload screen
    Navigator.pushNamed(context, '/challenge-screen');
  }

  void _handleAcceptCompetition(Map<String, dynamic> competition) {
    // Update competition status and navigate to submission
    _showAcceptDialog(competition);
  }

  void _handleDeclineCompetition(Map<String, dynamic> competition) {
    // Update competition status
    _showDeclineDialog(competition);
  }

  void _handleViewResults(Map<String, dynamic> competition) {
    // Navigate to battle results screen
    Navigator.pushNamed(context, '/battle-screen');
  }

  void _navigateToChallenge() {
    Navigator.pushNamed(context, '/challenge-screen');
  }

  void _showCompetitionDetails(Map<String, dynamic> competition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.elevatedSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.borderGray,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Competition Details',
              style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              competition['description'] as String? ?? '',
              style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            SizedBox(height: 3.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _handleSubmitResponse(competition);
                    },
                    child: const Text('Join Competition'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  void _showAcceptDialog(Map<String, dynamic> competition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        title: Text(
          'Accept Challenge',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you ready to accept this ${competition['category']} challenge?',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubmitResponse(competition);
            },
            child: const Text('Accept & Submit'),
          ),
        ],
      ),
    );
  }

  void _showDeclineDialog(Map<String, dynamic> competition) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.elevatedSurface,
        title: Text(
          'Decline Challenge',
          style: AppTheme.darkTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to decline this challenge? This action cannot be undone.',
          style: AppTheme.darkTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Remove from pending list or update status
              HapticFeedback.lightImpact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorRed,
            ),
            child: const Text('Decline'),
          ),
        ],
      ),
    );
  }
}
