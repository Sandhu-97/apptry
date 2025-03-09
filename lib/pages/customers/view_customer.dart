import 'package:apptry/backend/database.dart';
import 'package:apptry/extensions/string_extension.dart';
import 'package:apptry/pages/customers/customer_entries.dart';
import 'package:flutter/material.dart';

class ViewCustomerPage extends StatefulWidget {
  final String phone;
  const ViewCustomerPage({super.key, required this.phone});

  @override
  State<ViewCustomerPage> createState() => _ViewCustomerPageState();
}

class _ViewCustomerPageState extends State<ViewCustomerPage> {
  String name = '';
  Map<dynamic, dynamic> customerDetails = {};
  bool isLoading = false;
  num total = 0;

  @override
  void initState() {
    super.initState();
    loadCustomerDetails();
  }

  Future<void> loadCustomerDetails() async {
    setState(() {
      isLoading = true;
      customerDetails = {};
      name = '';
    });

    try {
      customerDetails = await getCustomerData(widget.phone);
      name = await getName(widget.phone);
      for (var field in customerDetails.keys) {
        total += customerDetails[field];
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load customer details')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('Customer Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.white, Colors.green.shade50],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.shade100,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      CircularProgressIndicator()
                    else if (customerDetails.isEmpty)
                      Text(
                        'No data found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green.shade900,
                        ),
                      )
                    else
                      _buildDetailRow("Total", total.toString()),
                    ...customerDetails.entries.map((entry) =>
                        _buildDetailRow(entry.key, entry.value.toString())),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerEntriesPage(phone: widget.phone),
            ),
          );
        },
        backgroundColor: Colors.green.shade900,
        child: Icon(
          Icons.list,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    label = label.replaceAll("_", " - ").toTitleCase;

    if (int.parse(value) == 0) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade900,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
