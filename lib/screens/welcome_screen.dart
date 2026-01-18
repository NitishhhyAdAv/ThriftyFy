import 'package:flutter/material.dart';
import '../data/models.dart';
import '../login_page.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
       vsync: this,
       duration: const Duration(seconds: 2),
    );
     _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
     _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
       CurvedAnimation(parent: _controller, curve: Curves.easeOut),
     );
     _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _navigateToLogin(UserRole role) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => LoginPage(targetRole: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              // Animated Logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Thriftfy",
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 3,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Buy & Sell Aesthetics",
                        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(flex: 3),
              // Role Selection
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildRoleCard(
                      title: "I want to BUY",
                      icon: Icons.shopping_basket_outlined,
                      color: Colors.white,
                      textColor: const Color(0xFF6A11CB),
                      onTap: () => _navigateToLogin(UserRole.buyer),
                    ),
                    const SizedBox(height: 16),
                    _buildRoleCard(
                      title: "I want to SELL",
                      icon: Icons.storefront_outlined,
                      color: Colors.transparent,
                      textColor: Colors.white,
                      isOutlined: true,
                      onTap: () => _navigateToLogin(UserRole.seller),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
    bool isOutlined = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: isOutlined ? Border.all(color: Colors.white, width: 2) : null,
          boxShadow: isOutlined ? null : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 32),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, color: textColor, size: 16),
          ],
        ),
      ),
    );
  }
}
