import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class NavigationShell extends StatelessWidget {
  final Widget child;

  const NavigationShell({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/menu')) return 1;
    if (location.startsWith('/orders')) return 2;
    if (location.startsWith('/subscription')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/menu'); break;
      case 2: context.go('/orders'); break;
      case 3: context.go('/subscription'); break;
      case 4: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color activeGold = Color(0xFFD9A24F);
    const Color inactiveGrey = Color(0xFF8E8A82);

    // Back press pe app minimize hoga, close nahi
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) SystemNavigator.pop(animated: true);
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF11110F),
            border: Border(top: BorderSide(color: Color(0xFF1E1C18), width: 1.0)),
          ),
          padding: EdgeInsets.symmetric(vertical: 0.5.h),
          child: BottomNavigationBar(
            currentIndex: _calculateSelectedIndex(context),
            onTap: (index) => _onItemTapped(index, context),
            backgroundColor: const Color(0xFF11110F),
            selectedItemColor: activeGold,
            unselectedItemColor: inactiveGrey,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            elevation: 0,
            selectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: activeGold,
            ),
            unselectedLabelStyle: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
              color: inactiveGrey,
            ),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined, size: 20.sp, color: inactiveGrey),
                activeIcon: Icon(Icons.home_outlined, size: 21.sp, color: activeGold),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book_outlined, size: 20.sp, color: inactiveGrey),
                activeIcon: Icon(Icons.menu_book_outlined, size: 21.sp, color: activeGold),
                label: 'Menu',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time, size: 20.sp, color: inactiveGrey),
                activeIcon: Icon(Icons.access_time, size: 21.sp, color: activeGold),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined, size: 20.sp, color: inactiveGrey),
                activeIcon: Icon(Icons.calendar_today_outlined, size: 21.sp, color: activeGold),
                label: 'Subscription',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 20.sp, color: inactiveGrey),
                activeIcon: Icon(Icons.person_outline, size: 21.sp, color: activeGold),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
