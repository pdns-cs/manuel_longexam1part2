import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/screens/newsfeed_screen.dart';
import 'package:tuazon_mobprog/screens/notification_screen.dart';
import 'package:tuazon_mobprog/screens/profile_screen.dart';
import 'package:tuazon_mobprog/services/user_service.dart';
import 'package:tuazon_mobprog/widgets/loop_brand.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  final UserService _userService = UserService();
  String _userName = 'Profile';
  String _userImage = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await _userService.getSavedUser();
      if (user != null && mounted) {
        setState(() {
          if (user.fullName.isNotEmpty) _userName = user.fullName;
          _userImage = user.image;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titles = [kAppName, 'Activity', _userName];

    return PopScope(
      canPop: _selectedIndex == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          // From another tab, back returns to the Home tab instead of exiting
          // or falling back to the auth screens.
          setState(() => _selectedIndex = 0);
          _pageController.jumpToPage(0);
        }
      },
      child: _buildScaffold(titles),
    );
  }

  Widget _buildScaffold(List<String> titles) {
    return Scaffold(
      backgroundColor: LOOP_BG,
      appBar: AppBar(
        titleSpacing: 20,
        backgroundColor: LOOP_TEAL,
        foregroundColor: LOOP_ON_BRAND,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: LOOP_ON_BRAND),
        title: _selectedIndex == 0
            ? const LoopLogo(size: 26, color: LOOP_ON_BRAND)
            : Text(
                titles[_selectedIndex],
                style: const TextStyle(color: LOOP_ON_BRAND),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: LOOP_ON_BRAND),
            tooltip: 'Settings',
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: PageView(
        controller: _pageController,
        children: const [
          NewsfeedScreen(),
          NotificationScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (page) => setState(() => _selectedIndex = page),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: LOOP_SURFACE,
          border: Border(top: BorderSide(color: LOOP_BORDER)),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            backgroundColor: Colors.transparent,
            indicatorColor: LOOP_ACCENT.withValues(alpha: 0.14),
            labelTextStyle: WidgetStatePropertyAll(
              TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: LOOP_MUTED),
            ),
          ),
          child: NavigationBar(
            height: 64,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) {
              setState(() => _selectedIndex = i);
              _pageController.jumpToPage(i);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              const NavigationDestination(
                icon: Icon(Icons.notifications_none_rounded),
                selectedIcon: Icon(Icons.notifications_rounded),
                label: 'Activity',
              ),
              NavigationDestination(
                icon: _avatarIcon(false),
                selectedIcon: _avatarIcon(true),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatarIcon(bool selected) {
    return Container(
      padding: const EdgeInsets.all(1.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? LOOP_ACCENT : Colors.transparent,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: LOOP_SUBTLE,
        backgroundImage:
            _userImage.startsWith('http') ? NetworkImage(_userImage) : null,
        child: _userImage.startsWith('http')
            ? null
            : Icon(Icons.person, size: 14, color: LOOP_MUTED),
      ),
    );
  }
}
