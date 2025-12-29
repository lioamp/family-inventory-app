import 'package:flutter/material.dart';
import '../models/dashboard.dart';
import 'dashboard_page.dart';

class DashboardsManagementPage extends StatefulWidget {
  final List<Dashboard> dashboards;
  const DashboardsManagementPage({super.key, required this.dashboards});

  @override
  State<DashboardsManagementPage> createState() => _DashboardsManagementPageState();
}

class _DashboardsManagementPageState extends State<DashboardsManagementPage> {
  void _addDashboard() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("New Dashboard"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter dashboard name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  widget.dashboards.add(Dashboard(name: controller.text));
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

  void _editDashboard(Dashboard dashboard) {
    final controller = TextEditingController(text: dashboard.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Dashboard"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter new dashboard name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                setState(() {
                  dashboard.name = controller.text;
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

  void _deleteDashboard(Dashboard dashboard) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Dashboard"),
        content: Text("Are you sure you want to delete '${dashboard.name}'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.dashboards.remove(dashboard);
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
        title: const Text("Manage Dashboards"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "Add Dashboard",
            onPressed: _addDashboard,
          ),
        ],
      ),
      body: ReorderableListView(
        padding: const EdgeInsets.all(8),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = widget.dashboards.removeAt(oldIndex);
            widget.dashboards.insert(newIndex, item);
          });
        },
        children: [
          for (final dashboard in widget.dashboards)
            ListTile(
              key: ValueKey(dashboard),
              title: Text(dashboard.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _editDashboard(dashboard),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteDashboard(dashboard),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DashboardPage(dashboard: dashboard),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}