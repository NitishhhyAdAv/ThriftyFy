import 'package:flutter/material.dart';
import '../../data/mock_service.dart';
import '../main_layout.dart'; // Import to switch tabs if needed, but setState is local to MainLayout.
// Actually, MainLayout controls the index. To switch tabs from here, we might need a callback or just navigate.
// For simplicity, "Buy a Product" can just push the MarketplaceScreen on top, or we can use a GlobalKey for MainLayout.
// Let's just push the MarketplaceScreen for now, it's easier.
import '../buyer/marketplace_screen.dart';
import 'add_listing_screen.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockService().currentUser;
    // Mock user products
    final products = MockService().products
        .where((p) => p.sellerId == user?.id)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Greeting & Balance
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  "Total Earnings",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  "\$${user?.balance.toStringAsFixed(2) ?? '0.00'}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  title: "Sell Product",
                  icon: Icons.add_a_photo_outlined,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AddListingScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton(
                  context,
                  title: "Buy Products",
                  icon: Icons.shopping_bag_outlined,
                  color: const Color(0xFF6A11CB),
                  onTap: () {
                    // Since we are in a nested navigator or MainLayout, pushing MarketplaceScreen works.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MarketplaceScreen(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
          const Text(
            "Your Active Listings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (products.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No active listings",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ...products.map(
            (p) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: Image.network(
                  p.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                title: Text(p.title),
                subtitle: Text("\$${p.price} • ${p.category}"),
                trailing: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
