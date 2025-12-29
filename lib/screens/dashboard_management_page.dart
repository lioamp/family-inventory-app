import 'package:flutter/material.dart';
import '../models/dashboard.dart';

class DashboardManagementPage extends StatefulWidget {
  final Dashboard dashboard;
  const DashboardManagementPage({super.key, required this.dashboard});

  @override
  State<DashboardManagementPage> createState() => _DashboardManagementPageState();
}

class _DashboardManagementPageState extends State<DashboardManagementPage> {
  void _addCategory() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.dashboard.addCategory(controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editCategory(String oldCategory) {
    final TextEditingController controller = TextEditingController(text: oldCategory);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new category name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newCategory = controller.text;
              if (newCategory.isNotEmpty) {
                setState(() {
                  // Rename category
                  final index = widget.dashboard.categories.indexOf(oldCategory);
                  if (index != -1) {
                    widget.dashboard.categories[index] = newCategory;

                    // Update subCategories map
                    final subs = widget.dashboard.subCategories.remove(oldCategory) ?? [];
                    widget.dashboard.subCategories[newCategory] = subs;

                    // Update items category
                    for (var item in widget.dashboard.items) {
                      if (item.category == oldCategory) {
                        item.category = newCategory;
                      }
                    }
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteCategory(String category) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Category"),
        content: Text("Are you sure you want to delete '$category'? All sub-categories and related items will be removed."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.dashboard.categories.remove(category);
                widget.dashboard.subCategories.remove(category);
                widget.dashboard.items.removeWhere((item) => item.category == category);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  void _addSubCategory(String category) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Sub-category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter sub-category name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.dashboard.addSubCategory(category, controller.text);
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _editSubCategory(String category, String oldSub) {
    final TextEditingController controller = TextEditingController(text: oldSub);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Sub-category"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new sub-category name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              final newSub = controller.text;
              if (newSub.isNotEmpty) {
                setState(() {
                  final subs = widget.dashboard.subCategories[category];
                  if (subs != null) {
                    final index = subs.indexOf(oldSub);
                    if (index != -1) {
                      subs[index] = newSub;

                      // Update items sub-category
                      for (var item in widget.dashboard.items) {
                        if (item.category == category && item.subCategory == oldSub) {
                          item.subCategory = newSub;
                        }
                      }
                    }
                  }
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _deleteSubCategory(String category, String sub) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Sub-category"),
        content: Text("Are you sure you want to delete '$sub'? All related items will be removed."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.dashboard.subCategories[category]?.remove(sub);
                widget.dashboard.items.removeWhere((item) =>
                    item.category == category && item.subCategory == sub);
              });
              Navigator.pop(context);
            },
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Dashboard"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Add Category Button
          ElevatedButton.icon(
            onPressed: _addCategory,
            icon: const Icon(Icons.add),
            label: const Text("Add Category"),
          ),
          const SizedBox(height: 10),
          // List categories
          ...widget.dashboard.categories.map((cat) {
            final subs = widget.dashboard.subCategories[cat] ?? [];
            return Card(
              child: ExpansionTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cat, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editCategory(cat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(cat),
                        ),
                      ],
                    ),
                  ],
                ),
                children: [
                  // Sub-categories
                  ...subs.map((sub) => ListTile(
                        title: Text(sub),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editSubCategory(cat, sub),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteSubCategory(cat, sub),
                            ),
                          ],
                        ),
                      )),
                  ListTile(
                    leading: const Icon(Icons.add),
                    title: const Text("Add Sub-category"),
                    onTap: () => _addSubCategory(cat),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
