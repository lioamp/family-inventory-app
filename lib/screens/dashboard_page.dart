import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/dashboard.dart';
import '../models/inventory_item.dart';
import '../widgets/inventory_card.dart';
import 'dashboard_management_page.dart'; // make sure this import exists

class DashboardPage extends StatefulWidget {
  final Dashboard dashboard;
  const DashboardPage({super.key, required this.dashboard});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final ImagePicker _picker = ImagePicker();
  String? filterCategory;
  String? filterSubCategory;

  @override
  void initState() {
    super.initState();
    filterCategory = null;
    filterSubCategory = null;
  }

  List<InventoryItem> get filteredItems {
    return widget.dashboard.items.where((item) {
      final matchCategory = filterCategory == null || item.category == filterCategory;
      final matchSub = filterSubCategory == null || item.subCategory == filterSubCategory;
      return matchCategory && matchSub;
    }).toList();
  }

  void _addItem(InventoryItem item) {
    setState(() {
      widget.dashboard.addItem(item);
    });
  }

  void _editItem(InventoryItem item, String newName, String newCategory, String newSubCategory,
      File? newFile, Uint8List? newBytes) {
    setState(() {
      item.name = newName;
      item.category = newCategory;
      item.subCategory = newSubCategory;
      item.imageFile = newFile;
      item.imageBytes = newBytes;
    });
  }

  Future<void> _showAddOrEditItemDialog({InventoryItem? editItem}) async {
    final TextEditingController nameController =
        TextEditingController(text: editItem?.name ?? "");
    File? pickedImageFile = editItem?.imageFile;
    Uint8List? pickedImageBytes = editItem?.imageBytes;

    String? selectedCategory = editItem?.category ??
        (widget.dashboard.categories.isNotEmpty ? widget.dashboard.categories[0] : null);
    String? selectedSubCategory = editItem?.subCategory ??
        (selectedCategory != null &&
                (widget.dashboard.subCategories[selectedCategory]?.isNotEmpty ?? false)
            ? widget.dashboard.subCategories[selectedCategory]![0]
            : null);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(editItem == null ? "Add New Item" : "Edit Item"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: "Enter item name"),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedCategory,
                        items: widget.dashboard.categories
                            .map((cat) => DropdownMenuItem(
                                  value: cat,
                                  child: Text(cat),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedCategory = value;
                            selectedSubCategory = selectedCategory != null &&
                                    (widget.dashboard.subCategories[selectedCategory]?.isNotEmpty ??
                                        false)
                                ? widget.dashboard.subCategories[selectedCategory]![0]
                                : null;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: "Add Category",
                      onPressed: () {
                        final TextEditingController newCatController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("New Category"),
                            content: TextField(
                              controller: newCatController,
                              decoration:
                                  const InputDecoration(hintText: "Enter category name"),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel")),
                              ElevatedButton(
                                onPressed: () {
                                  if (newCatController.text.isNotEmpty) {
                                    setStateDialog(() {
                                      widget.dashboard.addCategory(newCatController.text);
                                      selectedCategory = newCatController.text;
                                      selectedSubCategory = null;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: selectedSubCategory,
                        items: selectedCategory != null
                            ? widget.dashboard.subCategories[selectedCategory]!
                                .map((sub) => DropdownMenuItem<String>(
                                      value: sub,
                                      child: Text(sub),
                                    ))
                                .toList()
                            : [],
                        onChanged: (value) {
                          setStateDialog(() {
                            selectedSubCategory = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Sub-category',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      tooltip: "Add Sub-category",
                      onPressed: () {
                        if (selectedCategory == null) return;
                        final TextEditingController newSubController = TextEditingController();
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("New Sub-category"),
                            content: TextField(
                              controller: newSubController,
                              decoration: const InputDecoration(
                                  hintText: "Enter sub-category name"),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Cancel"),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (newSubController.text.isNotEmpty) {
                                    setStateDialog(() {
                                      widget.dashboard.addSubCategory(
                                          selectedCategory!, newSubController.text);
                                      selectedSubCategory = newSubController.text;
                                    });
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text("Add"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                kIsWeb
                    ? (pickedImageBytes != null
                        ? Image.memory(pickedImageBytes!,
                            width: 100, height: 100, fit: BoxFit.cover)
                        : const SizedBox(height: 100, child: Icon(Icons.image, size: 50)))
                    : (pickedImageFile != null
                        ? Image.file(pickedImageFile!,
                            width: 100, height: 100, fit: BoxFit.cover)
                        : const SizedBox(height: 100, child: Icon(Icons.image, size: 50))),
                TextButton.icon(
                  onPressed: () async {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      if (kIsWeb) {
                        final bytes = await image.readAsBytes();
                        setStateDialog(() => pickedImageBytes = bytes);
                      } else {
                        setStateDialog(() => pickedImageFile = File(image.path));
                      }
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text("Pick Image"),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  selectedCategory != null &&
                  selectedSubCategory != null &&
                  ((kIsWeb && pickedImageBytes != null) || (!kIsWeb && pickedImageFile != null))) {
                if (editItem == null) {
                  _addItem(InventoryItem(
                    name: nameController.text,
                    category: selectedCategory!,
                    subCategory: selectedSubCategory!,
                    imageFile: pickedImageFile,
                    imageBytes: pickedImageBytes,
                  ));
                } else {
                  _editItem(editItem, nameController.text, selectedCategory!,
                      selectedSubCategory!, pickedImageFile, pickedImageBytes);
                }
                Navigator.pop(context);
              }
            },
            child: Text(editItem == null ? "Add" : "Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.dashboard.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: "Manage Dashboard",
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DashboardManagementPage(dashboard: widget.dashboard),
                ),
              );
              setState(() {}); // <-- rebuild after returning
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                DropdownButton<String>(
                  hint: const Text("Filter by Category"),
                  value: filterCategory,
                  items: [null, ...widget.dashboard.categories]
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat ?? "All"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      filterCategory = value;
                      filterSubCategory = null;
                    });
                  },
                ),
                const SizedBox(width: 10),
                if (filterCategory != null)
                  DropdownButton<String>(
                    hint: const Text("Filter by Sub-category"),
                    value: filterSubCategory,
                    items: [null, ...?widget.dashboard.subCategories[filterCategory]]
                        .map((sub) => DropdownMenuItem(
                              value: sub,
                              child: Text(sub ?? "All"),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        filterSubCategory = value;
                      });
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: widget.dashboard.items.isEmpty
                ? const Center(child: Text("No items yet. Tap + to add one!"))
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filteredItems.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return InventoryCard(
                        item: item,
                        onEdit: () => _showAddOrEditItemDialog(editItem: item),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditItemDialog(),
        tooltip: "Add Item",
        child: const Icon(Icons.add),
      ),
    );
  }
}
