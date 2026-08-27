import 'package:flutter/material.dart';
import 'package:tuazon_mobprog/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailScreen extends StatefulWidget {
  final String userName;
  final String postContent;
  final String date;
  final int numOfLikes;
  final String imageUrl;
  final String profileImageUrl;

  const DetailScreen({
    super.key,
    required this.userName,
    required this.postContent,
    this.numOfLikes = 0,
    required this.date,
    this.imageUrl = '',
    this.profileImageUrl = '',
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late int _currentLikes;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _currentLikes = widget.numOfLikes;
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _currentLikes += _isLiked ? 1 : -1;
      if (_currentLikes < 0) _currentLikes = 0;
    });
  }

  void _pop() =>
      Navigator.pop(context, {'likes': _currentLikes, 'isLiked': _isLiked});

  ImageProvider? _avatar() {
    if (widget.profileImageUrl.isEmpty) return null;
    return widget.profileImageUrl.startsWith('http')
        ? CachedNetworkImageProvider(widget.profileImageUrl)
        : AssetImage(widget.profileImageUrl) as ImageProvider;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _pop();
      },
      child: Scaffold(
        backgroundColor: LOOP_BG,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _pop,
          ),
          title: const Text('Post'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: LOOP_SURFACE,
                  borderRadius: BorderRadius.circular(kRadiusMd),
                  border: Border.all(color: LOOP_BORDER),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: LOOP_SUBTLE,
                            backgroundImage: _avatar(),
                            child: _avatar() == null
                                ? Icon(Icons.person, color: LOOP_MUTED)
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: LOOP_TEXT,
                                ),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: LOOP_MUTED,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.postContent.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                        child: Text(
                          widget.postContent,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.45,
                            color: LOOP_TEXT,
                          ),
                        ),
                      ),
                    if (widget.imageUrl.isNotEmpty)
                      widget.imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: widget.imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (c, u) => Container(
                                height: 200,
                                color: LOOP_SUBTLE,
                              ),
                              errorWidget: (c, u, e) => Container(
                                height: 180,
                                color: LOOP_SUBTLE,
                                child: Icon(Icons.broken_image_outlined,
                                    color: LOOP_MUTED),
                              ),
                            )
                          : Image.asset(widget.imageUrl,
                              width: double.infinity, fit: BoxFit.cover),
                    Divider(height: 1, color: LOOP_BORDER),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _action(
                            _isLiked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            _currentLikes == 0
                                ? 'Like'
                                : '$_currentLikes',
                            _isLiked ? LOOP_DANGER : LOOP_MUTED,
                            _toggleLike,
                          ),
                          _action(Icons.mode_comment_outlined, 'Comment',
                              LOOP_MUTED, () {}),
                          _action(Icons.share_outlined, 'Share', LOOP_MUTED,
                              () {}),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _action(IconData icon, String label, Color color, VoidCallback onTap) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: color),
      icon: Icon(icon, size: 18, color: color),
      label: Text(label,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: color)),
    );
  }
}
