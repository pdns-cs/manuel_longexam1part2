import 'package:flutter/material.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:tuazon_mobprog/screens/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// A single activity/notification row in the Loop minimal style.
class CustomInformation extends StatelessWidget {
  const CustomInformation({
    super.key,
    required this.name,
    required this.post,
    required this.description,
    this.icon = const Icon(Icons.person),
    this.profileImageUrl = '',
    this.notifProfile = '',
    this.atProfile = false,
    required this.date,
    this.imageUrl = '',
    required this.numOfLikes,
  });

  final String name;
  final String post;
  final String description;
  final Icon icon;
  final String profileImageUrl;
  final String date;
  final int numOfLikes;
  final bool atProfile;
  final String imageUrl;
  final String notifProfile;

  ImageProvider? _avatar() {
    final src = notifProfile.isNotEmpty ? notifProfile : profileImageUrl;
    if (src.isEmpty) return null;
    return src.startsWith('http')
        ? CachedNetworkImageProvider(src)
        : AssetImage(src) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: atProfile
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(
                    userName: name,
                    postContent: post,
                    date: date,
                    numOfLikes: numOfLikes,
                    imageUrl: imageUrl,
                    profileImageUrl: profileImageUrl,
                  ),
                ),
              ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: LOOP_SUBTLE,
              backgroundImage: _avatar(),
              child: _avatar() == null
                  ? Icon(Icons.person, color: LOOP_MUTED)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 14, color: LOOP_TEXT),
                      children: [
                        TextSpan(
                          text: '$name ',
                          style:
                              const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: description,
                          style: TextStyle(color: LOOP_MUTED),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(date,
                      style: TextStyle(fontSize: 12, color: LOOP_MUTED)),
                ],
              ),
            ),
            if (imageUrl.isNotEmpty) ...[
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(kRadiusSm),
                child: imageUrl.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(imageUrl,
                        width: 44, height: 44, fit: BoxFit.cover),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
