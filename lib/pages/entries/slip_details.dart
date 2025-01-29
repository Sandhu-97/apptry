import 'package:apptry/backend/database.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class SlipDetailsPage extends StatefulWidget {
  final String slip;
  const SlipDetailsPage({super.key, required this.slip});

  @override
  State<SlipDetailsPage> createState() => _SlipDetailsPageState();
}

class _SlipDetailsPageState extends State<SlipDetailsPage> {
  List<Document> entries = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadSlipDetails();
  }

  Future<void> loadSlipDetails() async {
    print('Loading slip details for ${widget.slip}');
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      entries = await getEntryBySlip(widget.slip);
      print('Loaded slip details: ${entries.first.data}');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading slip details: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load slip details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRemove = entries.isNotEmpty && entries.first.data['type'] == 'remove';
    
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('Slip Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: isRemove ? Colors.red.shade900 : Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: isLoading 
          ? Center(
              child: CircularProgressIndicator(
                color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isRemove 
                              ? [Colors.white, Colors.red.shade50]
                              : [Colors.white, Colors.green.shade50],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Slip Number: ${widget.slip}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
                            ),
                          ),
                          Divider(color: isRemove ? Colors.red.shade200 : Colors.green.shade200),
                          if (entries.isNotEmpty)
                            ...entries.first.data.entries
                                .where((entry) => !entry.key.startsWith('\$'))
                                .map((entry) => Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            entry.key,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: isRemove ? Colors.red.shade100 : Colors.green.shade100,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              entry.value.toString(),
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
