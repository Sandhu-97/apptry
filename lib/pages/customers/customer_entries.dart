import 'package:apptry/backend/database.dart';
import 'package:apptry/pages/entries/new_entry.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class CustomerEntriesPage extends StatefulWidget {
  final String phone;
  const CustomerEntriesPage({super.key, required this.phone});

  @override
  State<CustomerEntriesPage> createState() => _CustomerEntriesPageState();
}

class _CustomerEntriesPageState extends State<CustomerEntriesPage> {
  List<Document> customerEntries = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadCustomerEntries();
  }

  Future<void> loadCustomerEntries() async {
    setState(() => isLoading = true);
    try {
      customerEntries = await getCustomerEntries(widget.phone);
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
                  builder: (context) => EntryPage(
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
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 8),
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
                                      ),
                                    ),
                                    Text(
                                      entry.data['\$createdAt']
                                              ?.toString()
                                              .substring(0, 10) ??
                                          '',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Divider(height: 20),
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  childAspectRatio: 3,
                                  children: [
                                    if ((entry.data['pukhraj'] ?? 0) > 0)
                                      _buildProductTile('Kufri Pukhraj',
                                          entry.data['pukhraj'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['jyoti'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Kufri Jyoti', entry.data['jyoti'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['diamant'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Diamant', entry.data['diamant'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['cardinal'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Cardinal', entry.data['cardinal'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['himalini'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Himalini', entry.data['himalini'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['badshah'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Badshah', entry.data['badshah'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                    if ((entry.data['others'] ?? 0) > 0)
                                      _buildProductTile(
                                          'Others', entry.data['others'],
                                          isRemove:
                                              entry.data['type'] == 'remove'),
                                  ],
                                ),
                              ],
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

  Widget _buildProductTile(String name, dynamic value,
      {bool isRemove = false}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isRemove
                ? [Colors.red.shade50, Colors.white]
                : [Colors.green.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
                fontSize: 16,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isRemove ? Colors.red.shade100 : Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isRemove ? Colors.red.shade900 : Colors.green.shade900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
