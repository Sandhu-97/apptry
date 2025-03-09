import 'package:apptry/backend/database.dart';
import 'package:apptry/pages/entries/slip_details.dart';
import 'package:flutter/material.dart';

class EntryHomePage extends StatefulWidget {
  const EntryHomePage({super.key});

  @override
  State<EntryHomePage> createState() => _EntryHomePageState();
}

class _EntryHomePageState extends State<EntryHomePage> {
  List entries = [];
  List test = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    loadEntries();
    print('EntryHomePage initialized');
  }

  Future<void> loadEntries() async {
    print('Loading entries...');
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      entries = await fetchSlipHistory();
      print('Loaded ${entries.length} entries');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading entries: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load entries: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Recent Entries',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.green.shade900,
          onRefresh: loadEntries,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: Colors.green.shade900,
                    ),
                  )
                : entries.isEmpty
                    ? Center(
                        child: Text(
                          'No entries found',
                          style: TextStyle(
                            color: Colors.green.shade900,
                            fontSize: 18,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SlipDetailsPage(
                                            slip: entry.data['slip'].toString(),
                                            phone:
                                                entry.data['phone'].toString(),
                                            type: entry.data['type'],
                                          )));
                            },
                            child: Card(
                              elevation: 4,
                              margin: EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: entry.data['type'] == 'remove'
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Slip: ${entry.data['slip']}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                entry.data['type'] == 'remove'
                                                    ? Colors.red.shade900
                                                    : Colors.green.shade900,
                                          ),
                                        ),
                                        Text(
                                          entry.data['\$createdAt']
                                                  ?.toString()
                                                  .substring(0, 10) ??
                                              '',
                                          style: TextStyle(
                                              color:
                                                  entry.data['type'] == 'remove'
                                                      ? Colors.red.shade700
                                                      : Colors.green.shade700),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                        color: entry.data['type'] == 'remove'
                                            ? Colors.red.shade200
                                            : Colors.green.shade200),
                                    Text(
                                      'Phone: ${entry.data['phone']}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: entry.data['type'] == 'remove'
                                            ? Colors.red.shade800
                                            : Colors.green.shade800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'new-entry');
        },
        backgroundColor: Colors.green.shade900,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
