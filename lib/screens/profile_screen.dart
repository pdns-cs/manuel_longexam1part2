import 'package:flutter/material.dart';
import 'package:manuel_advmobprog/constants.dart';
import 'package:manuel_advmobprog/models/post.dart';
import 'package:manuel_advmobprog/models/user.dart';
import 'package:manuel_advmobprog/services/post_service.dart';
import 'package:manuel_advmobprog/services/user_service.dart';
import 'package:manuel_advmobprog/widgets/api_post_card.dart';
import 'package:manuel_advmobprog/widgets/loop_brand.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();

  User? _user;
  bool _loadingUser = true;
  Future<List<Post>>? _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _userService.getSavedUser();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loadingUser = false;
      if (user != null) {
        _postsFuture = _postService.getPostsByUser(user.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingUser) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_user == null) {
      return Center(
        child: Text('Not signed in.', style: TextStyle(color: LOOP_TEXT)),
      );
    }
    final user = _user!;

    return Container(
      color: LOOP_BG,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _header(user),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
            child: Row(
              children: [
                Text(
                  'Posts',
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: LOOP_TEXT,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Divider(color: LOOP_BORDER)),
              ],
            ),
          ),
          FutureBuilder<List<Post>>(
            future: _postsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(28),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return _retry(
                  'Could not load posts.',
                  () => setState(() {
                    _postsFuture = _postService.getPostsByUser(user.id);
                  }),
                );
              }
              final posts = snapshot.data ?? [];
              if (posts.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Text('No posts yet.',
                        style: TextStyle(color: LOOP_MUTED)),
                  ),
                );
              }
              return Column(
                children: posts
                    .map((p) => ApiPostCard(
                          post: p,
                          authorName: user.fullName,
                          authorImage: user.image,
                          currentUserId: user.id,
                        ))
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _header(User user) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [LOOP_TEAL, LOOP_EMERALD],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 78),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: LOOP_SURFACE,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(kRadiusLg)),
              border: Border.all(color: LOOP_BORDER),
            ),
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 18),
            child: Column(
              children: [
                Text(
                  user.fullName,
                  style: TextStyle(
                    fontFamily: 'Klavika',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                    color: LOOP_TEXT,
                  ),
                ),
                const SizedBox(height: 2),
                Text('@${user.username}',
                    style: TextStyle(color: LOOP_MUTED, fontSize: 13)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    LoopChip(label: user.email, icon: Icons.mail_outline),
                    if (user.phone.isNotEmpty)
                      LoopChip(label: user.phone, icon: Icons.call_outlined),
                    if (user.gender.isNotEmpty)
                      LoopChip(
                        label: user.gender,
                        icon: Icons.person_outline,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {},
                        style: FilledButton.styleFrom(
                          backgroundColor: LOOP_TEAL,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kRadiusSm),
                          ),
                        ),
                        icon: const Icon(Icons.edit_outlined, size: 16),
                        label: const Text('Edit profile'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/settings'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: LOOP_BORDER),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kRadiusSm),
                        ),
                        foregroundColor: LOOP_TEXT,
                      ),
                      child: const Icon(Icons.settings_outlined, size: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 78 - 40,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: LOOP_SURFACE,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: LOOP_SUBTLE,
                backgroundImage: user.image.startsWith('http')
                    ? NetworkImage(user.image)
                    : null,
                child: user.image.startsWith('http')
                    ? null
                    : Icon(Icons.person, size: 36, color: LOOP_MUTED),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _retry(String message, VoidCallback onRetry) => Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Text(message, style: TextStyle(color: LOOP_MUTED)),
        const SizedBox(height: 8),
        OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
      ],
    ),
  );
}
