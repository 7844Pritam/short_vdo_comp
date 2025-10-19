import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_bar.dart';
import '../widgets/custom_icon_widget.dart';
import '../widgets/custom_tab_bar.dart';
import './widgets/debate_context_menu.dart';
import './widgets/debate_search_bar.dart';
import './widgets/debate_sort_sheet.dart';
import './widgets/debate_topic_card.dart';
import './widgets/new_debate_modal.dart';

class DebateListScreen extends StatefulWidget {
  const DebateListScreen({super.key});

  @override
  State<DebateListScreen> createState() => _DebateListScreenState();
}

class _DebateListScreenState extends State<DebateListScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DebateSortOption _currentSort = DebateSortOption.trending;
  String _searchQuery = '';
  bool _isLoading = false;
  bool _hasNotifications = true;
  List<Map<String, dynamic>> _debates = [];
  List<Map<String, dynamic>> _filteredDebates = [];

  final List<String> _searchSuggestions = [
    'Climate change solutions',
    'Social media impact',
    'Remote work benefits',
    'Electric vehicles future',
    'Artificial intelligence ethics',
    'Space exploration priority',
    'Cryptocurrency adoption',
    'Mental health awareness',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this, initialIndex: 4);
    _loadDebates();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDebates() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final mockDebates = [
        {
          'id': 1,
          'title':
              'Should artificial intelligence replace human teachers in schools?',
          'description':
              'With AI becoming more sophisticated, some argue it could provide personalized education at scale. Others believe human connection is irreplaceable in learning.',
          'category': 'Technology',
          'author': {
            'id': 'user1',
            'name': 'Sarah Chen',
            'avatar':
                'https://images.unsplash.com/photo-1695309972118-9fe68f1728b7',
            'avatarSemanticLabel':
                'Professional headshot of Asian woman with shoulder-length black hair wearing a navy blazer',
          },
          'responseCount': 47,
          'responses': [
            {
              'id': 'resp1',
              'thumbnail':
                  'https://images.unsplash.com/photo-1694532409338-e5dceca0b2e4',
              'thumbnailSemanticLabel':
                  'Student using tablet in modern classroom with digital displays',
              'duration': '1:23',
            },
            {
              'id': 'resp2',
              'thumbnail':
                  'https://images.unsplash.com/photo-1711634190549-b63198d377f7',
              'thumbnailSemanticLabel':
                  'Teacher explaining concept to diverse group of students in classroom',
              'duration': '2:15',
            },
            {
              'id': 'resp3',
              'thumbnail':
                  'https://images.unsplash.com/photo-1731706162918-713c6a26b1d4',
              'thumbnailSemanticLabel':
                  'Robot assistant helping child with homework at desk',
              'duration': '0:58',
            },
          ],
          'isHot': true,
          'timeAgo': '2h ago',
          'endTime': '22h',
          'isFollowing': false,
        },
        {
          'id': 2,
          'title': 'Is remote work better for productivity than office work?',
          'description':
              'The pandemic changed how we work. Some companies are going fully remote while others are calling employees back to the office.',
          'category': 'Politics',
          'author': {
            'id': 'user2',
            'name': 'Marcus Johnson',
            'avatar':
                'https://images.unsplash.com/photo-1696489647375-30cae68481f2',
            'avatarSemanticLabel':
                'Professional headshot of Black man with short beard wearing white dress shirt',
          },
          'responseCount': 23,
          'responses': [
            {
              'id': 'resp4',
              'thumbnail':
                  'https://images.unsplash.com/photo-1724933445057-06e54d6e4d7f',
              'thumbnailSemanticLabel':
                  'Person working on laptop at home office setup with plants',
              'duration': '1:45',
            },
            {
              'id': 'resp5',
              'thumbnail':
                  'https://images.unsplash.com/photo-1681963307268-53aec91743b8',
              'thumbnailSemanticLabel':
                  'Busy open office with people collaborating at desks',
              'duration': '2:03',
            },
          ],
          'isHot': false,
          'timeAgo': '4h ago',
          'endTime': '20h',
          'isFollowing': true,
        },
        {
          'id': 3,
          'title':
              'Should social media platforms be regulated like traditional media?',
          'description': null,
          'category': 'Entertainment',
          'author': {
            'id': 'user3',
            'name': 'Elena Rodriguez',
            'avatar':
                'https://images.unsplash.com/photo-1734521992144-5a4d0ea55952',
            'avatarSemanticLabel':
                'Professional headshot of Hispanic woman with curly hair wearing red blouse',
          },
          'responseCount': 89,
          'responses': [
            {
              'id': 'resp6',
              'thumbnail':
                  'https://images.unsplash.com/photo-1675352161865-27816c76141a',
              'thumbnailSemanticLabel':
                  'Smartphone showing various social media app icons on screen',
              'duration': '1:12',
            },
            {
              'id': 'resp7',
              'thumbnail':
                  'https://images.unsplash.com/photo-1682259689535-d52421aca2c9',
              'thumbnailSemanticLabel':
                  'Person reading newspaper while sitting at cafe table',
              'duration': '1:56',
            },
            {
              'id': 'resp8',
              'thumbnail':
                  'https://images.unsplash.com/photo-1551792588-fe673ede1042',
              'thumbnailSemanticLabel':
                  'Government building with flags representing media regulation',
              'duration': '2:34',
            },
          ],
          'isHot': true,
          'timeAgo': '6h ago',
          'endTime': '18h',
          'isFollowing': false,
        },
        {
          'id': 4,
          'title': 'Are electric vehicles really better for the environment?',
          'description':
              'While EVs produce no direct emissions, the manufacturing process and electricity generation raise questions about their true environmental impact.',
          'category': 'Sports',
          'author': {
            'id': 'user4',
            'name': 'David Kim',
            'avatar':
                'https://images.unsplash.com/photo-1646041805292-fd77781436f9',
            'avatarSemanticLabel':
                'Professional headshot of Asian man with glasses wearing gray sweater',
          },
          'responseCount': 34,
          'responses': [
            {
              'id': 'resp9',
              'thumbnail':
                  'https://images.unsplash.com/photo-1696432373225-a4a5913d0118',
              'thumbnailSemanticLabel':
                  'White electric car charging at modern charging station',
              'duration': '1:38',
            },
            {
              'id': 'resp10',
              'thumbnail':
                  'https://images.unsplash.com/photo-1715632943973-61b6bb8df7cc',
              'thumbnailSemanticLabel':
                  'Solar panels and wind turbines in green field representing clean energy',
              'duration': '2:21',
            },
          ],
          'isHot': false,
          'timeAgo': '8h ago',
          'endTime': '16h',
          'isFollowing': false,
        },
        {
          'id': 5,
          'title': 'Should cryptocurrency be adopted as legal tender globally?',
          'description':
              'Some countries have embraced crypto while others ban it completely. What\'s the right approach for the global economy?',
          'category': 'Technology',
          'author': {
            'id': 'user5',
            'name': 'Priya Patel',
            'avatar':
                'https://images.unsplash.com/photo-1617711084511-5671fc295c50',
            'avatarSemanticLabel':
                'Professional headshot of Indian woman with long dark hair wearing blue blazer',
          },
          'responseCount': 156,
          'responses': [
            {
              'id': 'resp11',
              'thumbnail':
                  'https://images.unsplash.com/photo-1631758346141-0ab4eb23d413',
              'thumbnailSemanticLabel':
                  'Golden Bitcoin coin on computer keyboard with financial charts',
              'duration': '1:47',
            },
            {
              'id': 'resp12',
              'thumbnail':
                  'https://images.unsplash.com/photo-1726066012751-2adfb5485977',
              'thumbnailSemanticLabel':
                  'Person using mobile banking app on smartphone',
              'duration': '2:09',
            },
            {
              'id': 'resp13',
              'thumbnail':
                  'https://images.unsplash.com/photo-1692237098155-0aa291fc2c26',
              'thumbnailSemanticLabel':
                  'Stack of various international currency bills and coins',
              'duration': '1:33',
            },
          ],
          'isHot': true,
          'timeAgo': '12h ago',
          'endTime': '12h',
          'isFollowing': true,
        },
      ];

      setState(() {
        _debates = mockDebates;
        _filteredDebates = mockDebates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterDebates() {
    List<Map<String, dynamic>> filtered = List.from(_debates);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((debate) {
        final title = (debate['title'] as String? ?? '').toLowerCase();
        final description =
            (debate['description'] as String? ?? '').toLowerCase();
        final category = (debate['category'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return title.contains(query) ||
            description.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply sort filter
    switch (_currentSort) {
      case DebateSortOption.trending:
        filtered.sort((a, b) {
          final aHot = a['isHot'] ?? false;
          final bHot = b['isHot'] ?? false;
          if (aHot && !bHot) return -1;
          if (!aHot && bHot) return 1;
          return (b['responseCount'] ?? 0).compareTo(a['responseCount'] ?? 0);
        });
        break;
      case DebateSortOption.recent:
        filtered.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0) * -1);
        break;
      case DebateSortOption.mostResponses:
        filtered.sort((a, b) =>
            (b['responseCount'] ?? 0).compareTo(a['responseCount'] ?? 0));
        break;
      case DebateSortOption.endingSoon:
        filtered.sort((a, b) {
          final aTime = int.tryParse(
                  (a['endTime'] as String? ?? '0h').replaceAll('h', '')) ??
              0;
          final bTime = int.tryParse(
                  (b['endTime'] as String? ?? '0h').replaceAll('h', '')) ??
              0;
          return aTime.compareTo(bTime);
        });
        break;
    }

    setState(() {
      _filteredDebates = filtered;
    });
  }

  Future<void> _onRefresh() async {
    HapticFeedback.lightImpact();
    await _loadDebates();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterDebates();
  }

  void _onSortChanged(DebateSortOption sort) {
    setState(() {
      _currentSort = sort;
    });
    _filterDebates();
  }

  void _onDebateCreated(Map<String, dynamic> newDebate) {
    setState(() {
      _debates.insert(0, newDebate);
    });
    _filterDebates();
  }

  void _showSortOptions() {
    DebateSortSheet.show(
      context,
      currentSort: _currentSort,
      onSortChanged: _onSortChanged,
    );
  }

  void _showContextMenu(Map<String, dynamic> debateData) {
    DebateContextMenu.show(
      context,
      debateData: debateData,
      onFollow: () {
        // Handle follow/unfollow
        HapticFeedback.lightImpact();
      },
      onShare: () {
        // Handle share
        HapticFeedback.lightImpact();
      },
      onReport: () {
        // Handle report
        HapticFeedback.lightImpact();
      },
    );
  }

  void _navigateToDebateDetail(Map<String, dynamic> debateData) {
    Navigator.pushNamed(context, '/debate-detail-screen',
        arguments: debateData);
  }

  void _showNewDebateModal() {
    NewDebateModal.show(
      context,
      onDebateCreated: _onDebateCreated,
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'forum',
            color: theme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            _searchQuery.isNotEmpty ? 'No debates found' : 'No debates yet',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search terms'
                : 'Be the first to start a debate!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton.icon(
            onPressed: _searchQuery.isNotEmpty ? null : _showNewDebateModal,
            icon: CustomIconWidget(
              iconName: 'add',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            label: Text('Start First Debate'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.5.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 30.w,
                          height: 12,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Container(
                          width: 20.w,
                          height: 10,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 15.w,
                    height: 24,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              SizedBox(height: 1.h),
              Container(
                width: 70.w,
                height: 14,
                decoration: BoxDecoration(
                  color:
                      theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        variant: AppBarVariant.solid,
        title: 'ClipBattle',
        showNotificationAction: _hasNotifications,
        actions: [
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          CustomTabBar(
            variant: TabBarVariant.standard,
            controller: _tabController,
            tabs: const [
              CustomTab(text: 'Home', icon: Icons.home),
              CustomTab(text: 'Compete', icon: Icons.emoji_events),
              CustomTab(text: 'Challenge', icon: Icons.add_circle),
              CustomTab(text: 'Battle', icon: Icons.sports_mma),
              CustomTab(text: 'Debates', icon: Icons.forum),
            ],
            onTap: (index) {
              switch (index) {
                case 0:
                  Navigator.pushNamed(context, '/home-feed-screen');
                  break;
                case 1:
                  Navigator.pushNamed(context, '/competition-list-screen');
                  break;
                case 2:
                  Navigator.pushNamed(context, '/challenge-screen');
                  break;
                case 3:
                  Navigator.pushNamed(context, '/battle-screen');
                  break;
                case 4:
                  // Current screen - do nothing
                  break;
              }
            },
          ),
          DebateSearchBar(
            onSearchChanged: _onSearchChanged,
            onFilterTap: _showSortOptions,
            suggestions: _searchSuggestions,
          ),
          Expanded(
            child: _isLoading
                ? _buildLoadingState(theme)
                : _filteredDebates.isEmpty
                    ? _buildEmptyState(theme)
                    : RefreshIndicator(
                        onRefresh: _onRefresh,
                        color: theme.colorScheme.primary,
                        child: ListView.builder(
                          padding: EdgeInsets.only(bottom: 10.h),
                          itemCount: _filteredDebates.length,
                          itemBuilder: (context, index) {
                            final debate = _filteredDebates[index];
                            return DebateTopicCard(
                              debateData: debate,
                              onTap: () => _navigateToDebateDetail(debate),
                              onLongPress: () => _showContextMenu(debate),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewDebateModal,
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        child: CustomIconWidget(
          iconName: 'add',
          color: theme.colorScheme.onPrimary,
          size: 28,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentRoute: '/debate-list-screen',
        onRouteChanged: (route) {
          if (route != '/debate-list-screen') {
            Navigator.pushNamed(context, route);
          }
        },
      ),
    );
  }
}
