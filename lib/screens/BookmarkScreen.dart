import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatCompactNumber(double number) {
  final formatter = NumberFormat.compact(locale: "en_US");
  return formatter.format(number);
}

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF50E0F10),
      appBar: AppBar(
        title: const Text('Bookmarked Reports'),
        backgroundColor: Color(0xFF18181B),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookmarks')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final bookmarks = snapshot.data!.docs;

          if (bookmarks.isEmpty) {
            return const Center(child: Text('No bookmarks yet.'));
          }

          return ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final doc = bookmarks[index];
              final data = doc.data() as Map<String, dynamic>;

              return Dismissible(
                key: Key(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Color(0xFF18181B),
                      title: const Text('Delete Bookmark'),
                      content: const Text('Are you sure you want to delete this report?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (direction) {
                  FirebaseFirestore.instance.collection('bookmarks').doc(doc.id).delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bookmark deleted')),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Carbon Emissions: ${formatCompactNumber(data['carbonEmission'] as double)} kg CO₂",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Energy: ${formatCompactNumber(data['energyConsumed'] as double)} Wh",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),

                        const SizedBox(height: 12),
                        if (data['comparisonText'] != null && data['comparisonText'].toString().isNotEmpty)
                          Text(
                            data['comparisonText'],
                            style: const TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        const SizedBox(height: 12),
                        if (data['timestamp'] != null)
                          Text(
                            "Saved on: ${DateFormat.yMMMEd().add_jm().format((data['timestamp'] as Timestamp).toDate())}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showEditDialog(BuildContext context, String docId, Map<String, dynamic> data) {
    final controller = TextEditingController(text: data['comparisonText']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Comparison'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'Comparison Text'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection('bookmarks').doc(docId).update({
                  'comparisonText': controller.text,
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
