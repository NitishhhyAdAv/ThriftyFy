
enum UserRole { buyer, seller }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final double balance; // For sellers (earnings) or buyers (wallet)
  final String? profileImage;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.balance = 0.0,
    this.profileImage,
  });
}

class Product {
  final String id;
  final String sellerId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String condition; // e.g., "New", "Like New", "Good", "Fair"
  final DateTime postedAt;
  bool isLabor; // if true, it's a "First Hand" / "Handmade" item? Or just keep it generic

  Product({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.condition,
    required this.postedAt,
    this.isLabor = false,
  });
}
