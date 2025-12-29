import 'package:flutter/material.dart';
import '../models/dashboard.dart';
import 'dashboard_page.dart';

class DashboardsPage extends StatefulWidget {
  const DashboardsPage({super.key});

  @override
  State<DashboardsPage> createState() => _DashboardsPageState();
}

class _DashboardsPageState extends State<DashboardsPage> {
  final List<Dashboard> dashboards = [
    Dashboard(name: "Clothing"),
    Dashboard(name: "Grocery"),
  ];

  void _addDashboard(String name) {
    setState(() {
      dashboards.add(Dashboard(name: name));
    });
  }

  Future<void> _showAddDashboardDialog() async {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("New Dashboard"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter dashboard name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addDashboard(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _openDashboard(Dashboard dashboard) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DashboardPage(dashboard: dashboard),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NestTrack Dashboards"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
        ),
        itemCount: dashboards.length,
        itemBuilder: (context, index) {
          final dashboard = dashboards[index];
          return GestureDetector(
            onTap: () => _openDashboard(dashboard),
            child: Card(
              color: Colors.deepPurple[100],
              child: Center(
                child: Text(
                  dashboard.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDashboardDialog,
        tooltip: "Add Dashboard",
        child: const Icon(Icons.dashboard),
      ),
    );
  }
}
