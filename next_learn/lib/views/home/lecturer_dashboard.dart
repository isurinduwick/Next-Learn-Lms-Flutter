import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:next_learn/services/auth_service.dart';
import 'package:next_learn/views/welcome_screen.dart';

class LecturerDashboard extends StatefulWidget {
  const LecturerDashboard({super.key});

  @override
  _LecturerDashboardState createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  // Use Rx variable for theme change reactivity
  final RxBool _isDarkMode = Get.isDarkMode.obs;

  // Make theme colors reactive with computed properties
  Color get _primaryColor => _isDarkMode.value ? Colors.indigo : Colors.blue;
  Color get _backgroundColor =>
      _isDarkMode.value ? Colors.grey[900]! : Colors.white;
  Color get _cardColor => _isDarkMode.value ? Colors.grey[850]! : Colors.white;
  Color get _textColor => _isDarkMode.value ? Colors.white : Colors.black87;
  Color get _subtitleColor =>
      _isDarkMode.value ? Colors.grey[400]! : Colors.grey[600]!;
  Color get _accentColor =>
      _isDarkMode.value ? Colors.indigoAccent : Colors.blue;
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

  Future<void> _logout() async {
    await AuthService.logout();
    Get.offAll(() => WelcomeScreen());
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
              _buildDashboardTab(),
              _buildCoursesTab(),
              _buildStudentsTab(),
              _buildResourcesTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: _primaryColor,
            foregroundColor: _buttonTextColor,
            child: const Icon(Icons.add),
            onPressed: () {
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
                        'Create New',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _textColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildOptionTile(
                          Icons.video_library, 'Create New Course'),
                      _buildOptionTile(Icons.assignment, 'Create Assignment'),
                      _buildOptionTile(Icons.event, 'Schedule Class'),
                      _buildOptionTile(Icons.announcement, 'Make Announcement'),
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
          Flexible(
            child: Text(
              'Lecturer Dashboard',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: _buttonTextColor,
                overflow: TextOverflow.ellipsis,
              ),
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
              'You have 3 new student submissions',
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
                  'Dr. Isuru',
                  style: TextStyle(
                    color: _buttonTextColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Senior Lecturer',
                  style: TextStyle(
                    color: _buttonTextColor.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.person, 'My Profile'),
          _buildDrawerItem(Icons.class_, 'My Courses'),
          _buildDrawerItem(Icons.people, 'My Students'),
          _buildDrawerItem(Icons.analytics, 'Analytics'),
          _buildDrawerItem(Icons.settings, 'Settings'),
          Divider(
              color: _isDarkMode.value ? Colors.grey[700] : Colors.grey[300]),
          ListTile(
            leading: Icon(Icons.logout, color: _primaryColor),
            title: Text(
              'Logout',
              style: TextStyle(color: _textColor),
            ),
            onTap: _logout,
          ),
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

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome card
            Card(
              elevation: _isDarkMode.value ? 2 : 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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
                            'Dr. Isuru',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _textColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Statistics cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Courses',
                    value: '5',
                    icon: Icons.book,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Students',
                    value: '138',
                    icon: Icons.people,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    title: 'Assignments',
                    value: '12',
                    icon: Icons.assignment,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    title: 'Reviews',
                    value: '4.8',
                    icon: Icons.star,
                    color: Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Today's schedule
            Text(
              'Today\'s Schedule',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildScheduleCard(
              title: 'Flutter Development - Advanced',
              time: '09:00 AM - 11:00 AM',
              location: 'Room 302',
              students: 35,
              isActive: true,
            ),
            const SizedBox(height: 12),
            _buildScheduleCard(
              title: 'Mobile App Architecture',
              time: '01:00 PM - 03:00 PM',
              location: 'Room 405',
              students: 42,
              isActive: false,
            ),
            const SizedBox(height: 24),

            // Pending Assignments
            Text(
              'Pending Assignments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildAssignmentCard(
              title: 'State Management in Flutter',
              dueDate: 'Due: Tomorrow',
              submissions: '28/35',
              course: 'Flutter Development',
            ),
            const SizedBox(height: 12),
            _buildAssignmentCard(
              title: 'UI Design Principles',
              dueDate: 'Due: April 12',
              submissions: '15/42',
              course: 'Mobile App Architecture',
            ),
            const SizedBox(height: 24),

            // Student Activity
            Text(
              'Recent Student Activity',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityCard(
              name: 'John Smith',
              action: 'submitted assignment',
              time: '2 hours ago',
              course: 'Flutter Development',
            ),
            const SizedBox(height: 12),
            _buildActivityCard(
              name: 'Sarah Johnson',
              action: 'asked a question',
              time: '5 hours ago',
              course: 'Mobile App Architecture',
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCoursesTab() {
    return Center(
      child: Text(
        'My Courses',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildStudentsTab() {
    return Center(
      child: Text(
        'Students',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildResourcesTab() {
    return Center(
      child: Text(
        'Resources',
        style: TextStyle(color: _textColor, fontSize: 24),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 14,
                  ),
                ),
                Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                color: _textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard({
    required String title,
    required String time,
    required String location,
    required int students,
    required bool isActive,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: _textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isActive ? 'Active' : 'Upcoming',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: _subtitleColor),
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
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: _subtitleColor),
                const SizedBox(width: 4),
                Text(
                  location,
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(Icons.people, size: 16, color: _subtitleColor),
                const SizedBox(width: 4),
                Text(
                  '$students students',
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
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String dueDate,
    required String submissions,
    required String course,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: _textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  course,
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dueDate,
                  style: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Submissions:',
                  style: TextStyle(
                    color: _subtitleColor,
                    fontSize: 14,
                  ),
                ),
                Text(
                  submissions,
                  style: TextStyle(
                    color: _textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: double.parse(submissions.split('/')[0]) /
                  double.parse(submissions.split('/')[1]),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required String name,
    required String action,
    required String time,
    required String course,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: _cardColor,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Text(
                name[0],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _textColor,
                            fontSize: 14,
                          ),
                        ),
                        TextSpan(
                          text: ' $action',
                          style: TextStyle(
                            color: _textColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course,
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(
                      color: _subtitleColor,
                      fontSize: 12,
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
            icon: Icon(Icons.dashboard),
            text: 'Dashboard',
          ),
          Tab(
            icon: Icon(Icons.book),
            text: 'Courses',
          ),
          Tab(
            icon: Icon(Icons.people),
            text: 'Students',
          ),
          Tab(
            icon: Icon(Icons.folder),
            text: 'Resources',
          ),
        ],
      ),
    );
  }
}
