class Comment {
  final int id;
  final String body;
  final int postId;
  final int userId;
  final String username;
  final String fullName;
  int likes;
  bool likedByMe;

  Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.userId,
    required this.username,
    required this.fullName,
    this.likes = 0,
    this.likedByMe = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    return Comment(
      id: (json['id'] as num?)?.toInt() ?? 0,
      body: json['body']?.toString() ?? '',
      postId: (json['postId'] as num?)?.toInt() ?? 0,
      userId: (user?['id'] as num?)?.toInt() ?? 0,
      username: user?['username']?.toString() ?? 'user',
      fullName: user?['fullName']?.toString() ??
          user?['username']?.toString() ??
          'User',
      likes: (json['likes'] as num?)?.toInt() ?? 0,
    );
  }
}
