import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  // Use Rx variable for theme change reactivity
  final RxBool _isDarkMode = Get.isDarkMode.obs;

  // Make theme colors reactive with computed properties
  Color get _primaryColor => _isDarkMode.value ? Colors.indigo : Colors.black;
  Color get _backgroundColor =>
      _isDarkMode.value ? Colors.grey[900]! : Colors.white;
  Color get _cardColor => _isDarkMode.value ? Colors.grey[850]! : Colors.white;
  Color get _textColor => _isDarkMode.value ? Colors.white : Colors.black87;
  Color get _subtitleColor =>
      _isDarkMode.value ? Colors.grey[400]! : Colors.grey[600]!;
  Color get _accentColor =>
      _isDarkMode.value ? Colors.indigoAccent : Colors.black;
  Color get _buttonTextColor => Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });

    // Listen to system theme changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final newBrightness = WidgetsBinding.instance.window.platformBrightness;
      final newIsDark = newBrightness == Brightness.dark;
      if (_isDarkMode.value != newIsDark) {
        _isDarkMode.value = newIsDark;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleTheme() {
    Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
    _isDarkMode.value = !_isDarkMode.value;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          backgroundColor: _backgroundColor,
          appBar: _buildAppBar(),
          body: TabBarView(
            controller: _tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildHomeTab(),
              _buildCoursesTab(),
              _buildScheduleTab(),
              _buildMessagesTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _primaryColor,
            foregroundColor: _buttonTextColor,
            child: const Icon(Icons.add),
            onPressed: () {
              // Show options for adding new content
              Get.bottomSheet(
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Add New',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildOptionTile(Icons.book, 'Join New Course'),
                      _buildOptionTile(Icons.event, 'Schedule Session'),
                      _buildOptionTile(Icons.message, 'Start Chat'),
                    ],
                  ),
                ),
              );
            },
          ),
          drawer: _buildDrawer(),
        ));
  }

  Widget _buildOptionTile(IconData icon, String label) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(label, style: TextStyle(color: _textColor)),
      onTap: () {
        Get.back();
        Get.snackbar(
          'Action',
          'You selected: $label',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: _primaryColor,
          colorText: Colors.white,
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            "assets/splash image.png",
            width: 30,
            height: 30,
          ),
          const SizedBox(width: 8),
          Text(
            'Next Learn',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: _buttonTextColor,
            ),
          ),
        ],
      ),
      backgroundColor: _primaryColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: _buttonTextColor,
          onPressed: () {
            Get.snackbar(
              'Notifications',
              'You have no new notifications',
              snackPosition: SnackPosition.TOP,
              backgroundColor:
                  _isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
              colorText: _textColor,
            );
          },
        ),
        IconButton(
          icon: Icon(_isDarkMode.value ? Icons.light_mode : Icons.dark_mode),
          color: _buttonTextColor,
          onPressed: _toggleTheme,
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: _backgroundColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: _primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/42.jpg',
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Isuru',
                  style: TextStyle(
                    color: _buttonTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'isuru@example.com',
                  style: TextStyle(
                    color: _buttonTextColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, 'My Profile'),
          _buildDrawerItem(Icons.settings, 'Settings'),
          _buildDrawerItem(Icons.help_outline, 'Help & Support'),
          _buildDrawerItem(Icons.star_border, 'Rate Us'),
          Divider(
              color: _isDarkMode.value ? Colors.grey[700] : Colors.grey[300]),
          _buildDrawerItem(Icons.logout, 'Logout'),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Dark Mode', style: TextStyle(color: _textColor)),
                Switch(
                  value: _isDarkMode.value,
                  onChanged: (value) => _toggleTheme(),
                  activeColor: _accentColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: _primaryColor),
      title: Text(
        title,
        style: TextStyle(color: _textColor),
      ),
      onTap: () {
        Get.back();
        Get.snackbar(
          'Action',
          'You selected: $title',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: _isDarkMode.value ? 2 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: _isDarkMode.value
                    ? BorderSide(color: Colors.grey[800]!, width: 1)
                    : BorderSide.none,
              ),
              color: _cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                        'https://randomuser.me/api/portraits/men/42.jpg',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontSize: 14,
                              color: _subtitleColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Isuru',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: _textColor),
                      onPressed: () {
                        Get.snackbar(
                          'Search',
                          'Search functionality coming soon!',
                          snackPosition: SnackPosition.TOP,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isDarkMode.value
                      ? [Colors.indigo, Colors.indigo.shade700]
                      : [_primaryColor, _primaryColor.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _isDarkMode.value
                        ? Colors.black.withOpacity(0.5)
                        : _primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Your Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'This Week',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(
                    value: 0.7,
                    backgroundColor: Colors.white30,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '70% Completed',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '14/20 hours',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'My Courses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(1);
                  },
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: _primaryColor),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 190,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCourseCard(
                    title: 'Flutter Development',
                    instructor: 'Ravidu',
                    progress: 0.8,
                    color: Colors.blue.shade700,
                    icon: Icons.code,
                    lessons: 24,
                  ),
                  _buildCourseCard(
                    title: 'UI/UX Design',
                    instructor: 'Chamath',
                    progress: 0.5,
                    color: Colors.purple.shade700,
                    icon: Icons.design_services,
                    lessons: 18,
                  ),
                  _buildCourseCard(
                    title: 'Web Development',
                    instructor: 'Tharushi',
                    progress: 0.3,
                    color: Colors.orange.shade700,
                    icon: Icons.web,
                    lessons: 32,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Upcoming Sessions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _tabController.animateTo(2);
                  },
                  child: Row(
                    children: [
                      Text(
                        'View All',
                        style: TextStyle(
                          color: _primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_forward, size: 16, color: _primaryColor),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildSessionCard(
              title: 'Flutter Widgets Deep Dive',
              time: 'Today, 3:00 PM',
              duration: '60 min',
              isLive: true,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              title: 'State Management in Flutter',
              time: 'Tomorrow, 2:00 PM',
              duration: '90 min',
              isLive: false,
            ),
            const SizedBox(height: 16),
            Text(
              'Recently Added',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: _cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade700,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.data_object,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.green.shade700.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Data Structures & Algorithms',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: _textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'By Sarah Johnson',
                            style: TextStyle(
                              color: _subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.bookmark_border, color: _textColor),
                      onPressed: () {
                        Get.snackbar(
                          'Bookmarked',
                          'Course saved to your bookmarks',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Center(
      child: Text(
        'Courses Tab',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildScheduleTab() {
    return Center(
      child: Text(
        'Schedule Tab',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildMessagesTab() {
    return Center(
      child: Text(
        'Messages Tab',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildCourseCard({
    required String title,
    required String instructor,
    required double progress,
    required Color color,
    required IconData icon,
    required int lessons,
  }) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  Text(
                    '$lessons lessons',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'By $instructor',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white30,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(progress * 100).toInt()}% Completed',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const Icon(
                    Icons.play_circle_fill,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required String title,
    required String time,
    required String duration,
    required bool isLive,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isLive ? Colors.red : _primaryColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        (isLive ? Colors.red : _primaryColor).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                isLive ? Icons.videocam : Icons.calendar_today_outlined,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: _textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: _subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        time,
                        style: TextStyle(
                          color: _subtitleColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isDarkMode.value ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                duration,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _textColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: _cardColor,
        boxShadow: [
          BoxShadow(
            color: _isDarkMode.value
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: _isDarkMode.value
            ? Border(top: BorderSide(color: Colors.grey[800]!, width: 0.5))
            : null,
      ),
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: _accentColor, width: 3),
          insets: const EdgeInsets.fromLTRB(40, 0, 40, 0),
        ),
        labelColor: _accentColor,
        unselectedLabelColor: _subtitleColor,
        tabs: const [
          Tab(
            icon: Icon(Icons.home),
            text: 'Home',
          ),
          Tab(
            icon: Icon(Icons.book),
            text: 'Courses',
          ),
          Tab(
            icon: Icon(Icons.calendar_today),
            text: 'Schedule',
          ),
          Tab(
            icon: Icon(Icons.message),
            text: 'Messages',
          ),
        ],
      ),
    );
  }
}
