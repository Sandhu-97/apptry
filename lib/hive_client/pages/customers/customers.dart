import 'package:apptry/backend/database.dart';
import 'package:apptry/pages/customers/view_customer.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class CustomerPage extends StatefulWidget {
  const CustomerPage({super.key});

  @override
  State<CustomerPage> createState() => _CustomerPageState();
}

class _CustomerPageState extends State<CustomerPage> {
  bool isLoading = true;
  List<Document> allCustomers = [];

  @override
  void initState() {
    super.initState();
    loadCustomers();
  }

  Future<void> loadCustomers() async {
    try {
      final customers = await getAllCustomers();
      setState(() {
        allCustomers = customers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Customers',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: Colors.green.shade900,
          onRefresh: loadCustomers,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                if (isLoading)
                  Center(
                    child: CircularProgressIndicator(
                      color: Colors.green.shade900,
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: allCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = allCustomers[index];
                        return Card(
                          elevation: 3,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.green.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(4),
                              title: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ViewCustomerPage(
                                        phone: customer.data['phone'],
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  customer.data['name'] ?? "No name",
                                  style: TextStyle(
                                    color: Colors.green.shade900,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Align(
                                alignment: Alignment.centerLeft,
                                child: SelectableText(
                                  customer.data['phone'] ?? "No phone",
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 16,
                                  ),
                                ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'new-customer');
        },
        backgroundColor: Colors.green.shade800,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
