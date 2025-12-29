import 'dart:io';
import 'dart:typed_data';

class InventoryItem {
  String name;
  String category;
  String subCategory;
  int quantity;
  File? imageFile;
  Uint8List? imageBytes;

  InventoryItem({
    required this.name,
    required this.category,
    this.subCategory = "General",
    this.quantity = 1,
    this.imageFile,
    this.imageBytes,
  });
}
