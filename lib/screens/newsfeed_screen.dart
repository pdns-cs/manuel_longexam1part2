import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:manuel_advmobprog/models/post.dart';
import 'package:manuel_advmobprog/services/post_service.dart';
import 'package:manuel_advmobprog/widgets/api_post_card.dart';
import 'package:manuel_advmobprog/widgets/post_card.dart';
import '../constants.dart';

class NewsfeedScreen extends StatelessWidget {
  NewsfeedScreen({super.key});

  final PostService _postService = PostService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Post>>(
      future: _postService.getPosts(limit: 20),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Could not load posts.',
              style: TextStyle(color: LOOP_TEXT),
            ),
          );
        }

        final posts = snapshot.data ?? [];

        return ListView(
          children: [
            buildAdvertisementCarousel(),
            const SizedBox(height: 8),
            ...posts.map(
              (post) => ApiPostCard(
                post: post,
                authorName: 'User ${post.userId}',
                authorImage: kGenericAvatar,
                currentUserId: post.userId,
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> carouselItems() {
    return [
      PostCard(
        userName: 'Brew & Bytes Café',
        postContent: 'Buy one, get one on every hand-brewed coffee — weekdays 2–5PM.',
        imagePath: 'assets/images/ad_cafe.png',
        date: DateTime.now(),
        adsMarket: 'Find a branch',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Loop Pay',
        postContent: 'Send money to any bank in seconds. Zero fees for your first 10 transfers.',
        imagePath: 'assets/images/ad_pay.png',
        date: DateTime.now(),
        adsMarket: 'Get the app',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'NorthPeak Outfitters',
        postContent: 'Rainy season sale — up to 40% off jackets, packs, and trail shoes.',
        imagePath: 'assets/images/ad_outfitters.png',
        date: DateTime.now(),
        adsMarket: 'Shop the sale',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'SkillForge Academy',
        postContent: 'Become a full-stack developer in 16 weeks. Next cohort starts soon.',
        imagePath: 'assets/images/ad_academy.png',
        date: DateTime.now(),
        adsMarket: 'Reserve a slot',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Verdant Greens',
        postContent: 'Fresh salads and grain bowls delivered to your desk before noon.',
        imagePath: 'assets/images/ad_greens.png',
        date: DateTime.now(),
        adsMarket: 'Order lunch',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'TaskNest',
        postContent: 'One board for your whole team. Plan, track, and ship without the chaos.',
        imagePath: 'assets/images/ad_tasknest.png',
        date: DateTime.now(),
        adsMarket: 'Try it free',
        userImage: kGenericAvatar,
      ),
      PostCard(
        userName: 'Aurora Mobile',
        postContent: 'Unlimited 5G data at half the price. Switch your number in 5 minutes.',
        imagePath: 'assets/images/ad_mobile.png',
        date: DateTime.now(),
        adsMarket: 'See plans',
        userImage: kGenericAvatar,
      ),
    ];
  }

  Widget buildAdvertisementCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
          child: Row(
            children: [
              Text(
                'SPONSORED',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w700,
                  color: LOOP_MUTED,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: Divider(color: LOOP_BORDER)),
            ],
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            height: 340.h,
            padEnds: false,
          ),
          items: carouselItems(),
        ),
      ],
    );
  }
}
