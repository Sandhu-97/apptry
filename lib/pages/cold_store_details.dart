import 'package:apptry/backend/database.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';

class ColdStoreDetails extends StatefulWidget {
  const ColdStoreDetails({super.key});

  @override
  State<ColdStoreDetails> createState() => _ColdStoreDetailsState();
}

class _ColdStoreDetailsState extends State<ColdStoreDetails> {
  List<Document> allBagsDetails = [];
  bool _isLoading = true;
  num totalBags = 0;
  num totalCustomers = 0;
  num pukhraj = 0;
  num jyoti = 0;
  num diamant = 0;
  num cardinal = 0;
  num himalini = 0;
  num badshah = 0;
  num others = 0;

  @override
  void initState() {
    super.initState();
    loadAllDetails();
  }

  Future<void> loadAllDetails() async {
    try {
      allBagsDetails = await getColdStorageBagsDetails();
      setState(() {
        totalCustomers = allBagsDetails.length;
        for (Document doc in allBagsDetails) {
          totalBags += doc.data['total'];
          pukhraj += doc.data['pukhraj'];
          jyoti += doc.data['jyoti'];
          diamant += doc.data['diamant'];
          cardinal += doc.data['cardinal'];
          himalini += doc.data['himalini'];
          badshah += doc.data['badshah'];
          others += doc.data['others'];
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load bags')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Cold Store Details',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: RefreshIndicator(
        color: Colors.green.shade900,
        onRefresh: loadAllDetails,
        child: _isLoading
            ? Center(child: CircularProgressIndicator(
                color: Colors.green.shade900,
              ))
            : SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(),
                      const SizedBox(height: 20),
                      _buildVarietyBreakdown(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 4,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            Divider(color: Colors.green.shade200),
            _buildInfoRow('Total Customers', totalCustomers.toString()),
            _buildInfoRow('Total Bags', totalBags.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildVarietyBreakdown() {
    return Card(
      elevation: 4,
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Variety Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            Divider(color: Colors.green.shade200),
            _buildInfoRow('Pukhraj', pukhraj.toString()),
            _buildInfoRow('Jyoti', jyoti.toString()),
            _buildInfoRow('Diamant', diamant.toString()),
            _buildInfoRow('Cardinal', cardinal.toString()),
            _buildInfoRow('Himalini', himalini.toString()),
            _buildInfoRow('Badshah', badshah.toString()),
            _buildInfoRow('Others', others.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.green.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.green.shade900,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(8),
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
