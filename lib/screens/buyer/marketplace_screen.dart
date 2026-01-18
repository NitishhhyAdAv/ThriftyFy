import 'package:flutter/material.dart';
import '../../data/mock_service.dart';
import 'product_detail_screen.dart';

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final products = MockService().products;
      return Scaffold(
        appBar: AppBar(title: const Text("Marketplace"), centerTitle: true),
        body: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)));
              },
              child: Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Expanded(
                       child: Hero(
                         tag: 'product_${product.id}',
                         child: Image.network(
                           product.imageUrl,
                           fit: BoxFit.cover,
                           width: double.infinity,
                           errorBuilder: (c,e,s) => Container(color: Colors.grey[300], child: const Icon(Icons.image)),
                         ),
                       ),
                     ),
                     Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                           Text("\$${product.price}", style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                         ],
                       ),
                     )
                  ],
                ),
              ),
            );
          },
        ),
      );
  }
}
