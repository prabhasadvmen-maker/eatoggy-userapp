import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class WriteReviewScreen extends StatefulWidget {
  final Order order;

  const WriteReviewScreen({super.key, required this.order});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _overallRating = 0;
  int _foodQualityRating = 0;
  int _deliveryPackagingRating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  int _charCount = 0;
  final List<String> _photos = []; // Holds mock URLs of added photos

  @override
  void initState() {
    super.initState();
    _feedbackController.addListener(() {
      setState(() {
        _charCount = _feedbackController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _addMockPhoto() {
    if (_photos.length < 3) {
      setState(() {
        // Add a mock royal feast photo
        _photos.add(widget.order.items.isNotEmpty
            ? widget.order.items.first.food.imageUrl
            : 'https://images.unsplash.com/photo-1589301760014-d929f3979dbc');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can add up to 3 photos'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  String _formatDate(DateTime dt) {
    const months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.order.items.isNotEmpty ? widget.order.items.first : null;
    final imageUrl = firstItem?.food.imageUrl ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Write a Review',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryText,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Order Info Card ──────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _imgFallback(),
                            )
                          : _imgFallback(),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${widget.order.id}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Delivered on ${_formatDate(widget.order.orderTime)} • ${widget.order.address.name}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Overall Experience ────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      'Overall Experience',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryGold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildStars(
                      rating: _overallRating,
                      size: 32,
                      onRatingChanged: (val) => setState(() => _overallRating = val),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Secondary Rating Metrics ──────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Food Quality',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        _buildStars(
                          rating: _foodQualityRating,
                          size: 22,
                          onRatingChanged: (val) => setState(() => _foodQualityRating = val),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery & Packaging',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.secondaryText,
                          ),
                        ),
                        _buildStars(
                          rating: _deliveryPackagingRating,
                          size: 22,
                          onRatingChanged: (val) => setState(() => _deliveryPackagingRating = val),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Detailed Feedback ─────────────────────────────────────────
              Text(
                'Detailed Feedback',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _feedbackController,
                maxLines: 4,
                maxLength: 500,
                buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                style: TextStyle(fontSize: 14.sp, color: AppColors.primaryText),
                decoration: InputDecoration(
                  hintText: 'Share your royal culinary experience with detail...',
                  hintStyle: TextStyle(color: AppColors.muted, fontSize: 14.sp),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1E1C18)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryGold, width: 1.2),
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Min 20 characters',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.muted),
                  ),
                  Text(
                    '$_charCount / 500',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: _charCount >= 20 ? AppColors.success : AppColors.muted,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Add Photos (Optional) ─────────────────────────────────────
              Text(
                'Add Photos (Optional)',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Dotted Add Button
                  GestureDetector(
                    onTap: _addMockPhoto,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primaryGold,
                          style: BorderStyle.solid,
                          width: 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: AppColors.primaryGold, size: 24),
                          const SizedBox(height: 4),
                          Text(
                            'Add Photo',
                            style: TextStyle(fontSize: 14.sp, color: AppColors.primaryGold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Display selected photos
                  Expanded(
                    child: SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _photos.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF1E1C18)),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    _photos[index],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => _imgFallback(),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () => _removePhoto(index),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: const Icon(Icons.close, color: Colors.white, size: 16),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // ── Submit Review Button ──────────────────────────────────────
              GestureDetector(
                onTap: () {
                  if (_overallRating == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select an overall rating'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }
                  if (_charCount < 20) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Detailed feedback must be at least 20 characters'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                    return;
                  }

                  // Successful submission feedback
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Thank you! Your royal review has been submitted.'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  context.pop();
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryGold.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Submit Review',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A0E00),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgFallback() => Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.restaurant, color: AppColors.muted, size: 24),
      );

  Widget _buildStars({
    required int rating,
    required double size,
    required ValueChanged<int> onRatingChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(
              isFilled ? Icons.star : Icons.star_border,
              color: isFilled ? AppColors.primaryGold : AppColors.muted,
              size: size,
            ),
          ),
        );
      }),
    );
  }
}
