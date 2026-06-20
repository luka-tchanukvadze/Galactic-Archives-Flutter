import 'package:cloud_firestore/cloud_firestore.dart' hide Order;

import '../models/order.dart';
import '../models/review.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Orders live under each user.
  CollectionReference<Map<String, dynamic>> _ordersRef(String uid) {
    return _db.collection('users').doc(uid).collection('orders');
  }

  Future<void> placeOrder(String uid, Order order) async {
    await _ordersRef(uid).add(order.toMap());
  }

  Stream<List<Order>> ordersStream(String uid) {
    return _ordersRef(uid)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Order.fromMap(d.data())).toList());
  }

  // Reviews are shared across all users.
  CollectionReference<Map<String, dynamic>> get _reviewsRef =>
      _db.collection('reviews');

  Future<void> addReview({
    required String review,
    required int rating,
    required String faction,
    required String userName,
    required String userId,
  }) async {
    await _reviewsRef.add(
      Review.toCreateMap(
        review: review,
        rating: rating,
        faction: faction,
        userName: userName,
        userId: userId,
      ),
    );
  }

  Stream<List<Review>> reviewsStream() {
    return _reviewsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => Review.fromMap(d.id, d.data())).toList(),
        );
  }
}
