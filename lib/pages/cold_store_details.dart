import 'package:apptry/backend/database.dart';
import 'package:flutter/material.dart';

class ColdStoreDetails extends StatefulWidget {
  const ColdStoreDetails({super.key});

  @override
  State<ColdStoreDetails> createState() => _ColdStoreDetailsState();
}

class _ColdStoreDetailsState extends State<ColdStoreDetails> {
  bool _isLoading = true;
  Map varietyWiseMap = {};
  num totalBags = 0;
  num totalCustomers = 0;
  num pukhraj = 0;
  num jyoti = 0;
  num diamant = 0;
  num cardinal = 0;
  num himalini = 0;
  num badshah = 0;
  num others = 0;

  num ration = 0;
  num seed12 = 0;
  num seed = 0;
  num goli = 0;
  num cut = 0;
  Stopwatch stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    stopwatch.start();
    loadAllDetails();
  }

  void loadAllDetails() {
    try {
      pukhraj = 0;
      jyoti = 0;
      diamant = 0;
      cardinal = 0;
      himalini = 0;
      badshah = 0;
      others = 0;

      ration = 0;
      seed12 = 0;
      seed = 0;
      goli = 0;
      cut = 0;

      num totalCustomersApiCall = getCachedCustomers().length;

      varietyWiseMap = coldStoreBagsDetails();
      pukhraj = varietyWiseMap['pukhraj_ration'] +
          varietyWiseMap['pukhraj_goli'] +
          varietyWiseMap['pukhraj_seed'] +
          varietyWiseMap['pukhraj_seed12'] +
          varietyWiseMap['pukhraj_cut'];
      jyoti = varietyWiseMap['jyoti_ration'] +
          varietyWiseMap['jyoti_goli'] +
          varietyWiseMap['jyoti_seed'] +
          varietyWiseMap['jyoti_seed12'] +
          varietyWiseMap['jyoti_cut'];
      diamant = varietyWiseMap['diamant_ration'] +
          varietyWiseMap['diamant_goli'] +
          varietyWiseMap['diamant_seed'] +
          varietyWiseMap['diamant_seed12'] +
          varietyWiseMap['diamant_cut'];
      cardinal = varietyWiseMap['cardinal_ration'] +
          varietyWiseMap['cardinal_goli'] +
          varietyWiseMap['cardinal_seed'] +
          varietyWiseMap['cardinal_seed12'] +
          varietyWiseMap['cardinal_cut'];
      himalini = varietyWiseMap['himalini_ration'] +
          varietyWiseMap['himalini_goli'] +
          varietyWiseMap['himalini_seed'] +
          varietyWiseMap['himalini_seed12'] +
          varietyWiseMap['himalini_cut'];
      badshah = varietyWiseMap['badshah_ration'] +
          varietyWiseMap['badshah_goli'] +
          varietyWiseMap['badshah_seed'] +
          varietyWiseMap['badshah_seed12'] +
          varietyWiseMap['badshah_cut'];
      others = varietyWiseMap['others_ration'] +
          varietyWiseMap['others_goli'] +
          varietyWiseMap['others_seed'] +
          varietyWiseMap['others_seed12'] +
          varietyWiseMap['others_cut'];

      ration = varietyWiseMap['pukhraj_ration'] +
          varietyWiseMap['jyoti_ration'] +
          varietyWiseMap['diamant_ration'] +
          varietyWiseMap['cardinal_ration'] +
          varietyWiseMap['himalini_ration'] +
          varietyWiseMap['badshah_ration'] +
          varietyWiseMap['others_ration'];
      goli = varietyWiseMap['pukhraj_goli'] +
          varietyWiseMap['jyoti_goli'] +
          varietyWiseMap['diamant_goli'] +
          varietyWiseMap['cardinal_goli'] +
          varietyWiseMap['himalini_goli'] +
          varietyWiseMap['badshah_goli'] +
          varietyWiseMap['others_goli'];
      seed = varietyWiseMap['pukhraj_seed'] +
          varietyWiseMap['jyoti_seed'] +
          varietyWiseMap['diamant_seed'] +
          varietyWiseMap['cardinal_seed'] +
          varietyWiseMap['himalini_seed'] +
          varietyWiseMap['badshah_seed'] +
          varietyWiseMap['others_seed'];
      seed12 = varietyWiseMap['pukhraj_seed12'] +
          varietyWiseMap['jyoti_seed12'] +
          varietyWiseMap['diamant_seed12'] +
          varietyWiseMap['cardinal_seed12'] +
          varietyWiseMap['himalini_seed12'] +
          varietyWiseMap['badshah_seed12'] +
          varietyWiseMap['others_seed12'];

      cut = varietyWiseMap['pukhraj_cut'] +
          varietyWiseMap['jyoti_cut'] +
          varietyWiseMap['diamant_cut'] +
          varietyWiseMap['cardinal_cut'] +
          varietyWiseMap['himalini_cut'] +
          varietyWiseMap['badshah_cut'] +
          varietyWiseMap['others_cut'];
      setState(() {
        totalCustomers = totalCustomersApiCall;
        totalBags =
            pukhraj + jyoti + diamant + cardinal + himalini + badshah + others;
        _isLoading = false;
        stopwatch.stop();
        // ignore: avoid_print
        print('Cold Store Details Page: ${stopwatch.elapsedMilliseconds}ms');
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
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
                    _buildVarietyBreakdown('Variety Breakdown'),
                    const SizedBox(height: 20),
                    _buildVarietyBreakdown('Sub Variety Breakdown'),
                  ],
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

  Widget _buildVarietyBreakdown(String title) {
    bool isSub = title == 'Sub Variety Breakdown';
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
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade900,
              ),
            ),
            Divider(color: Colors.green.shade200),
            isSub
                ? _buildInfoRow('Ration', ration.toString())
                : _buildVarietyRow('Pukhraj', pukhraj.toString()),
            isSub
                ? _buildInfoRow('Goli', goli.toString())
                : _buildVarietyRow('Jyoti', jyoti.toString()),
            isSub
                ? _buildInfoRow('Seed', seed.toString())
                : _buildVarietyRow('Diamant', diamant.toString()),
            isSub
                ? _buildInfoRow('Seed12', seed12.toString())
                : _buildVarietyRow('Cardinal', cardinal.toString()),
            isSub
                ? _buildInfoRow("Cut", cut.toString())
                : _buildVarietyRow('Himalini', himalini.toString()),
            isSub
                ? Container()
                : _buildVarietyRow('Badshah', badshah.toString()),
            isSub ? Container() : _buildVarietyRow('Others', others.toString()),
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

  Widget _buildVarietyRow(String label, String value) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(label),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildInfoRow(
                          'Ration',
                          varietyWiseMap['${label.toLowerCase()}_ration']
                              .toString()),
                      _buildInfoRow(
                          'Goli',
                          varietyWiseMap['${label.toLowerCase()}_goli']
                              .toString()),
                      _buildInfoRow(
                          'Seed',
                          varietyWiseMap['${label.toLowerCase()}_seed']
                              .toString()),
                      _buildInfoRow(
                          'Seed12',
                          varietyWiseMap['${label.toLowerCase()}_seed12']
                              .toString()),
                      _buildInfoRow(
                          'Cut',
                          varietyWiseMap['${label.toLowerCase()}_cut']
                              .toString()),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Close'),
                    ),
                  ],
                ));
      },
      child: Container(
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
      ),
    );
  }
}
