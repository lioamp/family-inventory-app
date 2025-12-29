import 'inventory_item.dart';

class Dashboard {
  String name;
  List<String> categories; // Main categories (Clothing, Grocery, etc.)
  Map<String, List<String>> subCategories; // Sub-categories per category
  List<InventoryItem> items;

  Dashboard({
    required this.name,
    List<String>? categories,
    Map<String, List<String>>? subCategories,
    List<InventoryItem>? items,
  })  : categories = categories ?? [], // mutable list
        subCategories = subCategories ?? {}, // mutable map
        items = items ?? []; // mutable list

  // Add category
  void addCategory(String category) {
    if (!categories.contains(category)) {
      categories.add(category);
      subCategories[category] = [];
    }
  }

  // Add sub-category under a category
  void addSubCategory(String category, String subCategory) {
    if (!subCategories.containsKey(category)) {
      subCategories[category] = [];
    }
    if (!subCategories[category]!.contains(subCategory)) {
      subCategories[category]!.add(subCategory);
    }
  }

  // Add item
  void addItem(InventoryItem item) {
    items.add(item);
  }
}
