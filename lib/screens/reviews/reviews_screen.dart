import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/responsive_center.dart';
import '../../core/widgets/space_scaffold.dart';
import '../../models/review.dart';
import '../../providers/auth_provider.dart';
import '../../services/firestore_service.dart';
import '../auth/login_screen.dart';

const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

String _formatDate(DateTime date) {
  return '${_months[date.month - 1]} ${date.day}, ${date.year}';
}

String _ratingEmoji(int rating, String faction) {
  if (rating <= 2) {
    return faction == 'sith' ? '⚡' : '\u{1F480}';
  }
  return faction == 'sith' ? '⚔️' : '⭐';
}

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _text = TextEditingController();
  int _rating = 5;
  String _faction = 'jedi';
  bool _submitting = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final auth = context.read<AuthProvider>();
    if (auth.user == null || _text.text.trim().isEmpty) return;

    setState(() => _submitting = true);
    try {
      await _firestore.addReview(
        review: _text.text.trim(),
        rating: _rating,
        faction: _faction,
        userName: auth.user!.name,
        userId: auth.user!.uid,
      );
      _text.clear();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transmission sent')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not send review: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return SpaceScaffold(
      appBar: AppBar(title: Text('GALACTIC REVIEWS', style: AppTheme.title(18))),
      body: StreamBuilder<List<Review>>(
        stream: _firestore.reviewsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Could not load reviews.\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.red),
              ),
            );
          }
          final reviews = snapshot.data ?? [];
          final hasReviewed =
              auth.user != null &&
              reviews.any((r) => r.userId == auth.user!.uid);

          return ResponsiveCenter(
            child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('TRANSMISSION LOG', style: AppTheme.title(18)),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'NO TRANSMISSIONS FOUND',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                )
              else
                ...reviews.map((r) => _ReviewCard(review: r)),
              const SizedBox(height: 24),
              _buildForm(auth, hasReviewed),
            ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm(AuthProvider auth, bool hasReviewed) {
    if (!auth.isLoggedIn) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.panel,
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'Log in to leave a review.',
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              child: const Text('LOGIN'),
            ),
          ],
        ),
      );
    }

    if (hasReviewed) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.1),
          border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'You have already submitted your review.',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.gold),
        ),
      );
    }

    final color = _faction == 'sith' ? AppColors.sith : AppColors.jedi;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.panel,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('NEW TRANSMISSION', style: AppTheme.title(16, color: color)),
          const SizedBox(height: 12),
          const Text('ALLEGIANCE', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(child: _factionButton('jedi', 'JEDI', AppColors.jedi)),
              const SizedBox(width: 8),
              Expanded(child: _factionButton('sith', 'SITH', AppColors.sith)),
            ],
          ),
          const SizedBox(height: 16),
          const Text('RATING', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Row(
            children: List.generate(5, (index) {
              final value = index + 1;
              final active = value <= _rating;
              return GestureDetector(
                onTap: () => setState(() => _rating = value),
                child: Opacity(
                  opacity: active ? 1 : 0.3,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      _ratingEmoji(_rating, _faction),
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          const Text('MESSAGE', style: TextStyle(color: AppColors.textMuted)),
          const SizedBox(height: 6),
          TextField(
            controller: _text,
            maxLines: 4,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Share your experience...',
              hintStyle: const TextStyle(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.black.withValues(alpha: 0.6),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade700),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: color, width: 2),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('SEND TRANSMISSION'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _factionButton(String value, String label, Color color) {
    final selected = _faction == value;
    return GestureDetector(
      onTap: () => setState(() => _faction = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.2) : AppColors.panelLight,
          border: Border.all(
            color: selected ? color : Colors.grey.shade700,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? color : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    final isJedi = review.faction == 'jedi';
    final color = isJedi ? AppColors.jedi : AppColors.sith;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color,
                child: Text(isJedi ? '⚔️' : '⚡'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  final active = index < review.rating;
                  return Opacity(
                    opacity: active ? 1 : 0.3,
                    child: Text(
                      _ratingEmoji(review.rating, review.faction),
                      style: const TextStyle(fontSize: 16),
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            '"${review.review}"',
            style: const TextStyle(color: AppColors.textLight, height: 1.4),
          ),
        ],
      ),
    );
  }
}
