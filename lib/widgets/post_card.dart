import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants.dart';
import 'package:manuel_advmobprog/screens/detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Minimal Loop-style feed card. Keeps the original public API so the newsfeed
/// (mock data) keeps working unchanged.
class PostCard extends StatefulWidget {
  final String userName;
  final String postContent;
  final DateTime date;
  final String likesCount;
  final int commentsCount;
  final int sharesCount;
  final String userImage;
  final String? imagePath;
  final bool showPlaceholder;
  final String adsMarket;

  const PostCard({
    super.key,
    required this.userName,
    required this.postContent,
    required this.date,
    required this.userImage,
    this.likesCount = "0",
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.imagePath,
    this.showPlaceholder = false,
    this.adsMarket = '',
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late int _likes;
  bool _isLiked = false;

  // Local, in-memory comment thread for this mock post.
  bool _showComments = false;
  final List<String> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _likes = int.tryParse(widget.likesCount) ?? 0;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(text);
      _commentController.clear();
    });
  }

  String formatDate(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
      'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[d.month]} ${d.day}';
  }

  ImageProvider _avatar() => widget.userImage.startsWith('http')
      ? CachedNetworkImageProvider(widget.userImage)
      : AssetImage(widget.userImage) as ImageProvider;

  @override
  Widget build(BuildContext context) {
    final bool isAd = widget.adsMarket.isNotEmpty;

    return Container(
      margin: EdgeInsets.fromLTRB(12.w, 6.h, 12.w, 6.h),
      decoration: BoxDecoration(
        color: LOOP_SURFACE,
        borderRadius: BorderRadius.circular(kRadiusMd),
        border: Border.all(color: LOOP_BORDER),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailScreen(
                userName: widget.userName,
                postContent: widget.postContent,
                date: formatDate(widget.date),
                numOfLikes: _likes,
                imageUrl: widget.imagePath ?? '',
                profileImageUrl: widget.userImage,
              ),
            ),
          );
          if (result is Map && result['likes'] != null) {
            setState(() {
              _likes = result['likes'] as int;
              if (result['isLiked'] != null) {
                _isLiked = result['isLiked'] as bool;
              }
            });
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 8, 10),
              child: Row(
                children: [
                  CircleAvatar(radius: 18, backgroundImage: _avatar()),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: LOOP_TEXT,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              isAd ? 'Sponsored' : formatDate(widget.date),
                              style: TextStyle(fontSize: 12, color: LOOP_MUTED),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              isAd ? Icons.campaign_outlined : Icons.public,
                              size: 12,
                              color: LOOP_MUTED,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.more_horiz, color: LOOP_MUTED),
                ],
              ),
            ),
            if (widget.postContent.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Text(
                  widget.postContent,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.4,
                    color: LOOP_TEXT,
                  ),
                ),
              ),
            _buildImage(isAd),
            if (isAd)
              _buildAdCta()
            else
              _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(bool isAd) {
    final path = widget.imagePath;
    if (path == null) {
      if (!widget.showPlaceholder) return const SizedBox.shrink();
      return Container(
        height: 150,
        color: LOOP_SUBTLE,
        child: Icon(Icons.image_outlined, color: LOOP_MUTED, size: 36),
      );
    }
    final Widget img = path.startsWith('http')
        ? Image.network(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: isAd ? 160 : null,
            loadingBuilder: (c, child, p) => p == null
                ? child
                : Container(
                    height: isAd ? 160 : 200,
                    color: LOOP_SUBTLE,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
            errorBuilder: (c, e, s) => Container(
              height: isAd ? 160 : 180,
              color: LOOP_SUBTLE,
              child: Icon(Icons.broken_image_outlined, color: LOOP_MUTED),
            ),
          )
        : Image.asset(
            path,
            fit: BoxFit.cover,
            width: double.infinity,
            height: isAd ? 160 : null,
          );
    return img;
  }

  Widget _buildActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(6, 4, 6, 4),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
            child: Row(
              children: [
                Text(
                  '$_likes likes',
                  style: TextStyle(fontSize: 12, color: LOOP_MUTED),
                ),
                const Spacer(),
                Text(
                  '${widget.commentsCount} comments · ${widget.sharesCount} shares',
                  style: TextStyle(fontSize: 12, color: LOOP_MUTED),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: LOOP_BORDER),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _actionButton(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                'Like',
                _isLiked ? LOOP_DANGER : LOOP_MUTED,
                () => setState(() {
                  _isLiked = !_isLiked;
                  _likes += _isLiked ? 1 : -1;
                  if (_likes < 0) _likes = 0;
                }),
              ),
              _actionButton(
                Icons.mode_comment_outlined,
                'Comment',
                _showComments ? LOOP_ACCENT : LOOP_MUTED,
                () => setState(() => _showComments = !_showComments),
              ),
              _actionButton(Icons.share_outlined, 'Share', LOOP_MUTED, () {}),
            ],
          ),
          if (_showComments) _buildCommentsSection(),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 12, color: LOOP_BORDER),
          if (_comments.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                'Be the first to comment.',
                style: TextStyle(fontSize: 12, color: LOOP_MUTED),
              ),
            )
          else
            ..._comments.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: LOOP_SUBTLE,
                      child: Icon(Icons.person, size: 14, color: LOOP_MUTED),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: LOOP_SUBTLE,
                          borderRadius: BorderRadius.circular(kRadiusSm),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: LOOP_TEXT,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c,
                              style:
                                  TextStyle(fontSize: 13, color: LOOP_TEXT),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  style: TextStyle(fontSize: 13, color: LOOP_TEXT),
                  minLines: 1,
                  maxLines: 3,
                  onSubmitted: (_) => _addComment(),
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Write a comment…',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton.filled(
                style: IconButton.styleFrom(backgroundColor: LOOP_TEAL),
                onPressed: _addComment,
                icon: const Icon(Icons.arrow_upward, size: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: color),
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAdCta() {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LEARN MORE',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1,
                    color: LOOP_MUTED,
                  ),
                ),
                Text(
                  widget.adsMarket,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: LOOP_TEXT,
                  ),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: LOOP_TEAL,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kRadiusSm),
              ),
            ),
            child: const Icon(Icons.arrow_forward, size: 18),
          ),
        ],
      ),
    );
  }
}
