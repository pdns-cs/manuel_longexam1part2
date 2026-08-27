import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

/// Wraps https://dummyjson.com/docs/comments
class CommentService {
  /// GET /comments/post/{postId} — all comments for a post.
  Future<List<Comment>> getCommentsByPost(int postId) async {
    final response = await http
        .get(
          Uri.parse('$host/comments/post/$postId'),
          headers: {'Content-Type': 'application/json'},
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception('Failed to load comments: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final List list = data['comments'] ?? [];
    return list.map((c) => Comment.fromJson(c)).toList();
  }

  /// POST /comments/add — dummyjson simulates the creation and echoes it back.
  Future<Comment> addComment({
    required int postId,
    required String body,
    required int userId,
  }) async {
    final response = await http
        .post(
          Uri.parse('$host/comments/add'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'body': body, 'postId': postId, 'userId': userId}),
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to add comment: ${response.statusCode}');
    }

    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
