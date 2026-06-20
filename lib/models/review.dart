import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  const Review({
    required this.id,
    required this.review,
    required this.rating,
    required this.faction,
    required this.userName,
    required this.userId,
    required this.createdAt,
  });

  final String id;
  final String review;
  final int rating;
  final String faction; // jedi or sith
  final String userName;
  final String userId;
  final DateTime createdAt;

  factory Review.fromMap(String id, Map<String, dynamic> map) {
    return Review(
      id: id,
      review: map['review'] ?? '',
      rating: (map['rating'] as num?)?.toInt() ?? 0,
      faction: map['faction'] ?? 'jedi',
      userName: map['userName'] ?? 'Unknown',
      userId: map['userId'] ?? '',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static Map<String, dynamic> toCreateMap({
    required String review,
    required int rating,
    required String faction,
    required String userName,
    required String userId,
  }) {
    return {
      'review': review,
      'rating': rating,
      'faction': faction,
      'userName': userName,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
