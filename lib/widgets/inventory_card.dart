import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../models/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;

  const InventoryCard({super.key, required this.item, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (kIsWeb) {
      imageWidget = item.imageBytes != null
          ? Image.memory(item.imageBytes!, width: double.infinity, height: 120, fit: BoxFit.cover)
          : Container(
              width: double.infinity,
              height: 120,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50),
            );
    } else {
      imageWidget = item.imageFile != null
          ? Image.file(item.imageFile!, width: double.infinity, height: 120, fit: BoxFit.cover)
          : Container(
              width: double.infinity,
              height: 120,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 50),
            );
    }

    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              imageWidget,
              Positioned(
                top: 4,
                right: 4,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepPurple),
                  onPressed: onEdit,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${item.category} > ${item.subCategory}",
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
