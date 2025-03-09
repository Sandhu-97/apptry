import 'package:apptry/backend/database.dart';

import 'package:apptry/pages/entries/new_entry_page.dart';
import 'package:apptry/pages/entries/slip_details.dart';
import 'package:flutter/material.dart';

class CustomerEntriesPage extends StatefulWidget {
  final String phone;
  const CustomerEntriesPage({super.key, required this.phone});

  @override
  State<CustomerEntriesPage> createState() => _CustomerEntriesPageState();
}

class _CustomerEntriesPageState extends State<CustomerEntriesPage> {
  List customerEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomerEntries();
  }

  Future<void> loadCustomerEntries() async {
    setState(() => isLoading = true);
    try {
      customerEntries = await fetchSlipHistoryByPhone(widget.phone);

      setState(() => isLoading = false);
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load customer entries')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Customer Entries',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NewEntryPage(
                        phone: widget.phone,
                      )));
        },
        backgroundColor: Colors.green.shade900,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.green.shade900,
          onRefresh: loadCustomerEntries,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade100,
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Entries for ${widget.phone}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade900,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (isLoading)
                  Expanded(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.green.shade900,
                      ),
                    ),
                  )
                else if (customerEntries.isEmpty)
                  Expanded(
                    child: Center(
                      child: Text(
                        'No entries found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: customerEntries.length,
                      itemBuilder: (context, index) {
                        final entry = customerEntries[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SlipDetailsPage(
                                          slip: entry.data['slip'].toString(),
                                          phone: entry.data['phone'].toString(),
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
                                          color: entry.data['type'] == 'remove'
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
