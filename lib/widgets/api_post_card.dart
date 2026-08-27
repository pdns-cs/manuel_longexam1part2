import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/comment.dart';
import '../models/post.dart';
import '../services/comment_service.dart';

/// Renders a single dummyjson [Post] together with its comments.
///
/// - the Like button is clickable (optimistic local toggle)
/// - comments for the post are loaded from GET /comments/post/{id}
/// - a new comment can be added via POST /comments/add
class ApiPostCard extends StatefulWidget {
  final Post post;
  final String authorName;
  final String authorImage;
  final int currentUserId;

  const ApiPostCard({
    super.key,
    required this.post,
    required this.authorName,
    required this.authorImage,
    required this.currentUserId,
  });

  @override
  State<ApiPostCard> createState() => _ApiPostCardState();
}

class _ApiPostCardState extends State<ApiPostCard> {
  final CommentService _commentService = CommentService();
  final TextEditingController _commentController = TextEditingController();

  late int _likes;
  bool _isLiked = false;

  bool _showComments = false;
  bool _loadingComments = false;
  bool _posting = false;
  String? _commentsError;
  List<Comment> _comments = [];

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likes += _isLiked ? 1 : -1;
      if (_likes < 0) _likes = 0;
    });
  }

  Future<void> _toggleComments() async {
    setState(() => _showComments = !_showComments);
    if (_showComments && _comments.isEmpty && !_loadingComments) {
      await _loadComments();
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _loadingComments = true;
      _commentsError = null;
    });
    try {
      final comments = await _commentService.getCommentsByPost(widget.post.id);
      if (!mounted) return;
      setState(() => _comments = comments);
    } catch (e) {
      if (!mounted) return;
      setState(() => _commentsError =
          'Could not load comments. Check your connection and retry.');
    } finally {
      if (mounted) setState(() => _loadingComments = false);
    }
  }

  Future<void> _addComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty || _posting) return;
    setState(() => _posting = true);
    try {
      final created = await _commentService.addComment(
        postId: widget.post.id,
        body: text,
        userId: widget.currentUserId,
      );
      if (!mounted) return;
      setState(() {
        _comments = [created, ..._comments];
        _commentController.clear();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add comment.')),
        );
      }
    } finally {
      if (mounted) setState(() => _posting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 6),
      decoration: BoxDecoration(
        color: LOOP_SURFACE,
        borderRadius: BorderRadius.circular(kRadiusMd),
        border: Border.all(color: LOOP_BORDER),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: LOOP_SUBTLE,
                  backgroundImage: widget.authorImage.startsWith('http')
                      ? NetworkImage(widget.authorImage)
                      : null,
                  child: widget.authorImage.startsWith('http')
                      ? null
                      : Icon(Icons.person, size: 18, color: LOOP_MUTED),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.authorName,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: LOOP_TEXT,
                        ),
                      ),
                      Text(
                        'Post #${widget.post.id}',
                        style: TextStyle(fontSize: 12, color: LOOP_MUTED),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz, color: LOOP_MUTED),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              widget.post.body,
              style: TextStyle(fontSize: 14, height: 1.45, color: LOOP_TEXT),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('$_likes likes',
                    style: TextStyle(fontSize: 12, color: LOOP_MUTED)),
                const Spacer(),
                Text('${_comments.length} comments',
                    style: TextStyle(fontSize: 12, color: LOOP_MUTED)),
              ],
            ),
            Divider(height: 20, color: LOOP_BORDER),
            Row(
              children: [
                Expanded(
                  child: _pillAction(
                    icon: _isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: 'Like',
                    active: _isLiked,
                    onTap: _toggleLike,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _pillAction(
                    icon: Icons.mode_comment_outlined,
                    label: 'Comment',
                    active: _showComments,
                    onTap: _toggleComments,
                  ),
                ),
              ],
            ),
            if (_showComments) ...[
              const SizedBox(height: 12),
              _buildCommentsSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _pillAction({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    final color = active ? LOOP_ACCENT : LOOP_MUTED;
    return Material(
      color: active ? LOOP_ACCENT.withValues(alpha: 0.1) : LOOP_SUBTLE,
      borderRadius: BorderRadius.circular(kRadiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(kRadiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 17, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_loadingComments)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else if (_commentsError != null)
          Row(
            children: [
              Expanded(
                child: Text(_commentsError!,
                    style: const TextStyle(color: LOOP_DANGER, fontSize: 13)),
              ),
              TextButton(onPressed: _loadComments, child: const Text('Retry')),
            ],
          )
        else if (_comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Be the first to comment.',
                style: TextStyle(color: LOOP_MUTED, fontSize: 13)),
          )
        else
          ..._comments.map(_buildCommentTile),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                style: TextStyle(color: LOOP_TEXT, fontSize: 13),
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'Add a comment…',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _posting
                ? const Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: LOOP_TEAL),
                    onPressed: _addComment,
                    icon: const Icon(Icons.arrow_upward, size: 18),
                  ),
          ],
        ),
      ],
    );
  }

  Widget _buildCommentTile(Comment c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: LOOP_SUBTLE,
            child: Text(
              c.fullName.isNotEmpty ? c.fullName[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: LOOP_MUTED,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: LOOP_SUBTLE,
                borderRadius: BorderRadius.circular(kRadiusSm),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: LOOP_TEXT,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(c.body,
                      style: TextStyle(fontSize: 13, color: LOOP_TEXT)),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () => setState(() {
                      c.likedByMe = !c.likedByMe;
                      c.likes += c.likedByMe ? 1 : -1;
                      if (c.likes < 0) c.likes = 0;
                    }),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          c.likedByMe
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 14,
                          color: c.likedByMe ? LOOP_DANGER : LOOP_MUTED,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${c.likes}',
                          style: TextStyle(fontSize: 11, color: LOOP_MUTED),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
