import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/models/models.dart';

class TrackingScreen extends StatefulWidget {
  final Order order;

  const TrackingScreen({super.key, required this.order});

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Map Layer (Mock graphic styled map background) ─────────────────
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1524661135-423995f22d0b?q=80&w=1200&auto=format&fit=crop',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.dstATop,
              errorBuilder: (_, __, ___) => Container(color: Colors.grey[900]),
            ),
          ),

          // Stylized map grids and landmarks
          Positioned.fill(
            child: CustomPaint(
              painter: MapRoadsPainter(),
            ),
          ),

          // Mock Map Pins & Tooltip
          Positioned(
            left: 35.w,
            top: 30.h,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Text(
                    'CURRENT LOCATION - Ashok Vihar',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                // Target Circle indicator + pin
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Floating Action Buttons (Back & Live Tracking Badge) ───────────
          Positioned(
            top: 6.h,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    final router = GoRouter.of(context);
                    if (router.canPop()) {
                      router.pop();
                    } else {
                      router.go('/orders');
                    }
                  },
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xCC11110F),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      color: AppColors.primaryText,
                      size: 28,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xCC11110F),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF1E1C18), width: 1.0),
                  ),
                  child: Text(
                    'Live Tracking',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Bottom Sheet Details ──────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: Color(0xFF1E1C18), width: 1.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rider is on the way',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.secondaryText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Arriving in 14 Mins',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryGold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F2618),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.green.withOpacity(0.6), width: 1.0),
                        ),
                        child: Text(
                          'Hot-case Insulated',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Color(0xFF1E1C18), height: 32, thickness: 1),

                  // Rider details row
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 26,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=150&auto=format&fit=crop&q=60',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ramesh Kumar',
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '4.9 Star Valet Partner',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.secondaryText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Action buttons: Call & Chat
                      _buildRoundActionBtn(Icons.call_outlined, () {}),
                      const SizedBox(width: 10),
                      _buildRoundActionBtn(Icons.chat_bubble_outline, () {}),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // View Delivery Instructions Button
                  GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Delivery Instructions: Ring bell and leave at door.'),
                          backgroundColor: AppColors.primaryGold,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          'View Delivery Instructions',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1A0E00),
                          ),
                        ),
                      ),
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

  Widget _buildRoundActionBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.background,
          border: Border.all(color: const Color(0xFF1E1C18), width: 1.2),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryGold,
          size: 20,
        ),
      ),
    );
  }
}

// ── Custom painter to draw clean background road networks for map feel ────
class MapRoadsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.06)
      ..style = PaintingStyle.fill;

    // Draw some park circles
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.15), 50, paint);
    canvas.drawCircle(Offset(size.width * 0.75, size.height * 0.4), 80, paint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.1), 60, paint);

    // Draw some road paths
    final roadPaint = Paint()
      ..color = const Color(0xFF1E1C18).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    final path1 = Path();
    path1.moveTo(0, size.height * 0.2);
    path1.quadraticBezierTo(size.width * 0.4, size.height * 0.25, size.width * 0.5, size.height * 0.45);
    path1.lineTo(size.width * 0.65, size.height * 0.9);
    canvas.drawPath(path1, roadPaint);

    final path2 = Path();
    path2.moveTo(size.width, size.height * 0.15);
    path2.lineTo(size.width * 0.5, size.height * 0.45);
    path2.lineTo(0, size.height * 0.5);
    canvas.drawPath(path2, roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
