import 'package:apptry/backend/database.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:apptry/extensions/string_extension.dart';

class SlipDetailsPage extends StatefulWidget {
  final String slip;
  final String phone;
  final String type;
  const SlipDetailsPage(
      {super.key, required this.slip, required this.phone, required this.type});

  @override
  State<SlipDetailsPage> createState() => _SlipDetailsPageState();
}

class _SlipDetailsPageState extends State<SlipDetailsPage> {
  List<Document> entries = [];
  bool isLoading = true;
  String? error;
  String name = "Loading...";

  @override
  void initState() {
    super.initState();
    loadSlipDetails();
  }

  Future<void> loadSlipDetails() async {
    name = await getName(widget.phone);
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      entries = await getEntryBySlip(widget.slip);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
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
    final isRemove = widget.type == 'remove';

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
                                color: isRemove
                                    ? Colors.red.shade900
                                    : Colors.green.shade900,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isRemove
                                    ? Colors.red.shade900
                                    : Colors.green.shade900,
                              ),
                            ),
                            Divider(
                                color: isRemove
                                    ? Colors.red.shade200
                                    : Colors.green.shade200),
                            if (entries.isNotEmpty)
                              ...entries.first.data.entries
                                  .where(
                                    (element) => element.value > 0,
                                  )
                                  .map((entry) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              entry.key
                                                  .replaceAll("_", " ")
                                                  .toTitleCase,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: isRemove
                                                    ? Colors.red.shade900
                                                    : Colors.green.shade900,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 12, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isRemove
                                                    ? Colors.red.shade100
                                                    : Colors.green.shade100,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                entry.value.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: isRemove
                                                      ? Colors.red.shade900
                                                      : Colors.green.shade900,
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
