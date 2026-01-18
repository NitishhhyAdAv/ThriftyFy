import 'package:flutter/foundation.dart';
import 'models.dart';
import '../services/auth_service.dart';

class MockService extends ChangeNotifier {
  // Singleton pattern
  static final MockService _instance = MockService._internal();
  factory MockService() => _instance;
  MockService._internal() {
    _seedData();
  }

  // State
  User? _currentUser;
  final List<Product> _products = [];
  final List<User> _users = [];

  // Getters
  User? get currentUser => _currentUser;
  List<Product> get products => List.unmodifiable(_products);

  // Authentication
  Future<bool> login(String email, String password, {UserRole? role}) async {
    // Mock login logic
    try {
      final user = _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
      // For demo: if role is passed, we might want to force update the role or just check
      // But for simplicity, we just log them in.
      // If we wanted to STRICTLY enforce:
      // if (role != null && user.role != role) return false;

      _currentUser = user;
      notifyListeners();
      return true;
    } catch (e) {
      // Create new user with the requested role
      final newRole =
          role ?? (email.contains('seller') ? UserRole.seller : UserRole.buyer);
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: email.split('@')[0],
        email: email,
        role: newRole,
        balance: 1000.0,
      );
      _users.add(newUser);
      _currentUser = newUser;
      notifyListeners();
      return true;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  /// Login with authenticated credentials (Gmail, Phone, etc.)
  Future<bool> loginWithAuth(
    String email,
    String name, {
    required UserRole role,
  }) async {
    try {
      final existingUser = _users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
        orElse: () => throw Exception('User not found'),
      );
      _currentUser = existingUser;
      notifyListeners();
      return true;
    } catch (e) {
      // Create new user with the authenticated credentials
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        role: role,
        balance: 1000.0,
        profileImage: null,
      );
      _users.add(newUser);
      _currentUser = newUser;
      notifyListeners();
      return true;
    }
  }

  /// Enhanced logout that clears Firebase auth
  Future<void> logoutAsync() async {
    await AuthService().signOut();
    _currentUser = null;
    notifyListeners();
  }

  // Product Management
  void addProduct(Product product) {
    _products.insert(0, product);
    notifyListeners();
  }

  List<Product> getProductsBySeller(String sellerId) {
    return _products.where((p) => p.sellerId == sellerId).toList();
  }

  // Seed Data
  void _seedData() {
    // Add some dummy products
    _products.addAll([
      Product(
        id: '1',
        sellerId: 'seller1',
        title: 'Vintage Denim Jacket',
        description:
            'Classic 90s denim jacket, slightly distressed. Perfect condition.',
        price: 45.0,
        imageUrl:
            'https://images.unsplash.com/photo-1576871337632-b9aef4c17ab9?auto=format&fit=crop&q=80&w=800',
        category: 'Outerwear',
        condition: 'Good',
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Product(
        id: '2',
        sellerId: 'seller1',
        title: 'Floral Summer Dress',
        description: 'Light and airy floral dress, never worn with tags.',
        price: 30.0,
        category: 'Dresses',
        condition: 'New',
        imageUrl:
            'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?auto=format&fit=crop&q=80&w=800',
        postedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      Product(
        id: '3',
        sellerId: 'seller2',
        title: 'Leather Boots',
        description: 'Genuine leather boots, size 10. Worn twice.',
        price: 85.0,
        category: 'Shoes',
        condition: 'Like New',
        imageUrl:
            'https://images.unsplash.com/photo-1520639888713-7851133b1ed0?auto=format&fit=crop&q=80&w=800',
        postedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Product(
        id: '4',
        sellerId: 'seller2',
        title: 'Graphic Tee',
        description: 'Rare vintage band tee.',
        price: 25.0,
        category: 'T-Shirts',
        condition: 'Fair',
        imageUrl:
            'https://images.unsplash.com/photo-1503341504253-dff4815485f1?auto=format&fit=crop&q=80&w=800',
        postedAt: DateTime.now(),
      ),
    ]);
  }
}
