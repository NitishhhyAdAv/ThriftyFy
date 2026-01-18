import 'package:flutter/material.dart';
import '../data/models.dart';
import '../data/mock_service.dart';
import 'buyer/marketplace_screen.dart';
import 'seller/seller_dashboard.dart';
import 'seller/add_listing_screen.dart';
import 'buyer/cart_screen.dart';
import 'buyer/search_delegate.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  final _service = MockService();

  List<NavigationDestination> _getDestinations(UserRole role) {
    if (role == UserRole.buyer) {
      return const [
        NavigationDestination(icon: Icon(Icons.storefront), label: 'Market'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(
          icon: Icon(Icons.shopping_cart_outlined),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ];
    } else {
      return const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Dashboard',
        ),
        NavigationDestination(
          icon: Icon(Icons.storefront),
          label: 'Market',
        ), // Seller can view market
        NavigationDestination(
          icon: Icon(Icons.add_circle_outline),
          label: 'Sell',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ];
    }
  }

  Widget _getBody(UserRole role) {
    if (role == UserRole.buyer) {
      switch (_selectedIndex) {
        case 0:
          return const MarketplaceScreen();
        case 1:
          return Scaffold(
            body: Center(
              child: FilledButton(
                onPressed: () => showSearch(
                  context: context,
                  delegate: ProductSearchDelegate(),
                ),
                child: const Text("Tap to Search"),
              ),
            ),
          );
        case 2:
          return const CartScreen();
        case 3:
          return _buildProfile();
        default:
          return const MarketplaceScreen();
      }
    } else {
      switch (_selectedIndex) {
        case 0:
          return const SellerDashboard();
        case 1:
          return const MarketplaceScreen(); // View market as seller
        case 2:
          return const AddListingScreen();
        case 3:
          return _buildProfile();
        default:
          return const SellerDashboard();
      }
    }
  }

  Widget _buildProfile() {
    final user = _service.currentUser;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[200],
            child: Text(
              user?.name[0].toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 40),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            user?.name ?? 'User',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            user?.email ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
          const SizedBox(height: 10),
          Text(
            user?.role.toString().split('.').last.toUpperCase() ?? '',
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: () async {
              await _service.logoutAsync();
              if (mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              }
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _service.currentUser;
    if (user == null) {
      // Fallback or loading
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: _getBody(user.role),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: _getDestinations(user.role),
      ),
    );
  }
}
