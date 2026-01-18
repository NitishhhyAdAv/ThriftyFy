import 'package:flutter/material.dart';
import '../../data/mock_service.dart';
import '../../data/models.dart';
import 'product_detail_screen.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildList(context);
  }

  Widget _buildList(BuildContext context) {
    final products = MockService().products;
    final results = products.where((p) => p.title.toLowerCase().contains(query.toLowerCase())).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        return ListTile(
          leading: Image.network(product.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(product.title),
          subtitle: Text("\$${product.price}"),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
          },
        );
      },
    );
  }
}
