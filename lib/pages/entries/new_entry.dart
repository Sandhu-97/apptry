import 'package:flutter/material.dart';
import 'package:apptry/backend/database.dart';

class EntryPage extends StatefulWidget {
  final String phone;
  const EntryPage({super.key, this.phone = ''});

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  // Controllers for form fields
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController slipController = TextEditingController();
  final TextEditingController pukhrajController = TextEditingController();
  final TextEditingController jyotiController = TextEditingController();
  final TextEditingController diamantController = TextEditingController();
  final TextEditingController cardinalController = TextEditingController();
  final TextEditingController himaliniController = TextEditingController();
  final TextEditingController badshahController = TextEditingController();
  final TextEditingController othersController = TextEditingController();
  String type = 'add';
  bool isNameLoading = false;
  final _formKey = GlobalKey<FormState>(); // Add form key for validation

  // Method to clear all form fields
  void _clearForm() {
    phoneController.clear();
    nameController.clear();
    slipController.clear();
    pukhrajController.clear();
    jyotiController.clear();
    diamantController.clear();
    cardinalController.clear();
    himaliniController.clear();
    badshahController.clear();
    othersController.clear();
  }

  Future<void> getNameHere(String phone) async {
    try {
      String name = await getName(phone);
      setState(() {
        nameController.text = name;
      });
    } catch (e) {
      nameController.text = "Not Found";
    } finally {
      setState(() {
        isNameLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.phone != '') {
      phoneController.text = widget.phone;
      nameController.text = 'Loading...';
      getNameHere(phoneController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text('Cold Storage Entry',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section with updated styling
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
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
                  child: Column(
                    children: [
                      Text(
                        "Shri Guru Har Rai Ji Cold Store",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                const SizedBox(height: 10),
                Divider(color: Colors.green.shade200, thickness: 2),
                const SizedBox(height: 10),

                // Update TextFormField decoration theme
                Theme(
                  data: Theme.of(context).copyWith(
                    inputDecorationTheme: InputDecorationTheme(
                      labelStyle: TextStyle(color: Colors.green.shade900),
                      prefixIconColor: Colors.green.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            BorderSide(color: Colors.green.shade900, width: 2),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Customer Information Section
                      Card(
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
                                'Customer Information',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: phoneController,
                                decoration: InputDecoration(
                                  labelText: "Phone Number",
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  suffixIcon: isNameLoading
                                      ? Container(
                                          padding: const EdgeInsets.all(12),
                                          child:
                                              const CircularProgressIndicator(),
                                        )
                                      : null,
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter a phone number';
                                  }
                                  if (value!.length != 10) {
                                    return 'Phone number must be 10 digits';
                                  }
                                  return null;
                                },
                                onChanged: (value) async {
                                  if (value.length == 10) {
                                    setState(() {
                                      isNameLoading = true;
                                    });
                                    try {
                                      String name = await getName(value);
                                      setState(() {
                                        nameController.text = name;
                                      });
                                    } catch (e) {
                                      nameController.text = "Not Found";
                                    } finally {
                                      setState(() {
                                        isNameLoading = false;
                                      });
                                    }
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  labelText: "Customer Name",
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                readOnly: true,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: slipController,
                                decoration: InputDecoration(
                                  labelText: "Slip Number",
                                  prefixIcon: const Icon(Icons.receipt),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Please enter a slip number';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: "Add/Remove",
                                  labelStyle:
                                      TextStyle(color: Colors.green.shade900),
                                  prefixIcon: Icon(Icons.info_rounded,
                                      color: Colors.green.shade900),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade300),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade300),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                        color: Colors.green.shade900, width: 2),
                                  ),
                                ),
                                value: "add", // Default value
                                items: [
                                  DropdownMenuItem(
                                    value: "add",
                                    child: Text("Add",
                                        style: TextStyle(
                                            color: Colors.green.shade900)),
                                  ),
                                  DropdownMenuItem(
                                    value: "remove",
                                    child: Text("Remove",
                                        style: TextStyle(
                                            color: Colors.green.shade900)),
                                  ),
                                ],
                                onChanged: (value) {
                                  // Handle value change
                                  if (value == 'remove') {
                                    type = 'remove';
                                  } else {
                                    type = 'add';
                                  }
                                  print(type);
                                },
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Storage Items Section
                      Card(
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
                                'Storage Items',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              for (var item in [
                                {
                                  'controller': pukhrajController,
                                  'label': 'Kufri Pukhraj'
                                },
                                {
                                  'controller': jyotiController,
                                  'label': 'Kufri Jyoti'
                                },
                                {
                                  'controller': diamantController,
                                  'label': 'Diamant'
                                },
                                {
                                  'controller': cardinalController,
                                  'label': 'Cardinal'
                                },
                                {
                                  'controller': himaliniController,
                                  'label': 'Himalini'
                                },
                                {
                                  'controller': badshahController,
                                  'label': 'Badshah'
                                },
                                {
                                  'controller': othersController,
                                  'label': 'Others'
                                },
                              ]) ...[
                                TextFormField(
                                  validator: (value) {
                                    if (int.tryParse(value!)! > 1000) {
                                      return 'Number of bags can\'t be more than 1000';
                                    }
                                    return null;
                                  },
                                  controller: item['controller']
                                      as TextEditingController,
                                  decoration: InputDecoration(
                                    labelText: item['label'] as String,
                                    prefixIcon:
                                        const Icon(Icons.inventory_2_sharp),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    suffixText: 'bags',
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                              ],
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Submit Button
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              await insertNewEntry(
                                phoneController.text,
                                int.tryParse(slipController.text) ?? 0,
                                type,
                                int.tryParse(pukhrajController.text) ?? 0,
                                int.tryParse(jyotiController.text) ?? 0,
                                int.tryParse(diamantController.text) ?? 0,
                                int.tryParse(cardinalController.text) ?? 0,
                                int.tryParse(himaliniController.text) ?? 0,
                                int.tryParse(badshahController.text) ?? 0,
                                int.tryParse(othersController.text) ?? 0,
                              );

                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Entry added successfully'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                              _clearForm();
                            } catch (e) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Entry',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    phoneController.dispose();
    nameController.dispose();
    slipController.dispose();
    pukhrajController.dispose();
    jyotiController.dispose();
    diamantController.dispose();
    cardinalController.dispose();
    himaliniController.dispose();
    badshahController.dispose();
    othersController.dispose();
    super.dispose();
  }
}
