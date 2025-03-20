import 'package:apptry/backend/database.dart';
import 'package:apptry/components/dialog_box.dart';
import 'package:apptry/constants.dart';
import 'package:apptry/models/variety_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEntryPage extends StatefulWidget {
  final String phone;
  const NewEntryPage({super.key, this.phone = ''});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _slipController = TextEditingController();

  bool _isNameLoading = false;
  bool _isFormSubmitting = false;
  String type = 'add';
  String name = '';

  final _varietyControllers = {
    'Pukhraj': TextEditingController(),
    'Jyoti': TextEditingController(),
    'Diamant': TextEditingController(),
    'Cardinal': TextEditingController(),
    'Himalini': TextEditingController(),
    'Badshah': TextEditingController(),
    'Others': TextEditingController(),
  };

  Future<void> getLoadedName() async {
    name = getName(_phoneController.text);
    setState(() {
      _nameController.text = name;
      _isNameLoading = false;
    });
  }

  void _showDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) => DialogBox(
              title: title,
              content: content,
            ));
  }

  @override
  void initState() {
    super.initState();
    _phoneController.text = widget.phone;
    _nameController.text = "Loading...";
    _isNameLoading = true;
    getLoadedName();
  }

  @override
  Widget build(BuildContext context) {
    final varietyModel = Provider.of<VarietyModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: Text('New Entry',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
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
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Customer Information Card
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          prefixIcon:
                              Icon(Icons.phone, color: Colors.green.shade900),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                                BorderSide(color: Colors.green.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.green.shade900, width: 2),
                          ),
                        ),
                        onChanged: (value) async {
                          if (value.length == 10) {
                            setState(() {
                              _isNameLoading = true;
                              _nameController.text = "Loading...";
                            });
                            try {
                              final String name = getName(value);
                              setState(() {
                                _nameController.text = name;
                              });
                            } catch (e) {
                              setState(() {
                                _nameController.text = "Customer not found";
                              });
                            } finally {
                              setState(() {
                                _isNameLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Customer Name",
                          prefixIcon:
                              Icon(Icons.person, color: Colors.green.shade900),
                          suffixIcon: _isNameLoading
                              ? Container(
                                  padding: const EdgeInsets.all(12),
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.green.shade900,
                                    strokeWidth: 2,
                                  ),
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _slipController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Slip Number",
                          prefixIcon:
                              Icon(Icons.receipt, color: Colors.green.shade900),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: "add",
                        decoration: InputDecoration(
                          labelText: "Add/Remove",
                          prefixIcon: Icon(Icons.compare_arrows,
                              color: Colors.green.shade900),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(value: "add", child: Text("Add")),
                          DropdownMenuItem(
                              value: "remove", child: Text("Remove")),
                        ],
                        onChanged: (value) => setState(() => type = value!),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Varieties Card
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
                        'Varieties',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...varietyNames.map((variety) => Container(
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.green.shade50],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.green.shade200),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              leading: Icon(
                                Icons.inventory_2_outlined,
                                color: Colors.green.shade900,
                              ),
                              title: Text(
                                variety,
                                style: TextStyle(
                                  color: Colors.green.shade900,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _varietyControllers[variety]?.text ?? "0",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.green.shade900,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.green.shade50
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 25),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Quantity for $variety",
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green.shade900,
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                children: [
                                                  for (var subVariety
                                                      in subVarietyNames) ...[
                                                    TextFormField(
                                                      keyboardType:
                                                          TextInputType.number,
                                                      initialValue: (varietyModel
                                                                  .getValue(
                                                                      "${variety}_$subVariety")) ==
                                                              0
                                                          ? ""
                                                          : (varietyModel.getValue(
                                                                  "${variety}_$subVariety"))
                                                              .toString(),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return null;
                                                        }
                                                        if (int.tryParse(
                                                                value) ==
                                                            null) {
                                                          return "Value must be number";
                                                        }
                                                        if (int.parse(value) <
                                                            0) {
                                                          return "Value cannot be negative";
                                                        }
                                                        if (int.parse(value) >
                                                            2000) {
                                                          return "Value cannot be greater than 2000";
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: subVariety,
                                                        labelStyle: TextStyle(
                                                            color: Colors.green
                                                                .shade900),
                                                        hintText:
                                                            "Enter quantity for $subVariety",
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .green
                                                                  .shade300),
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .green
                                                                  .shade300),
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .green
                                                                      .shade900,
                                                                  width: 2),
                                                        ),
                                                        filled: true,
                                                        fillColor: Colors.white,
                                                      ),
                                                      onChanged: (value) {
                                                        varietyModel.updateValue(
                                                            "${variety}_$subVariety",
                                                            int.tryParse(
                                                                    value) ??
                                                                0);
                                                      },
                                                    ),
                                                    const SizedBox(height: 12),
                                                  ],
                                                  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .green
                                                                  .shade900),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          if (_formKey
                                                                  .currentState
                                                                  ?.validate() ==
                                                              false) {
                                                            return;
                                                          }
                                                          int totalVariety = 0;
                                                          for (var subVariety
                                                              in subVarietyNames) {
                                                            totalVariety +=
                                                                varietyModel
                                                                    .getValue(
                                                                        "${variety}_$subVariety");
                                                          }
                                                          setState(() {
                                                            _varietyControllers[
                                                                        variety]
                                                                    ?.text =
                                                                totalVariety
                                                                    .toString();
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              Colors.green
                                                                  .shade900,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      16,
                                                                  vertical: 12),
                                                        ),
                                                        child: Text(
                                                          "Done",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          )),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: _isFormSubmitting
                    ? null
                    : () async {
                        setState(() {
                          _isFormSubmitting = true;
                        });
                        try {
                          final phone = _phoneController.text;
                          final slip = int.tryParse(_slipController.text) ?? -1;
                          final varietyMap = varietyModel.getMap();

                          if (varietyMap.isEmpty) {
                            throw Exception("Fields cannot be empty");
                          }
                          if (phone.length != 10) {
                            throw Exception("Phone number must be 10 digits");
                          }
                          if (slip < 0) {
                            throw Exception("Invalid slip number");
                          }

                          await addNewLog(phone, slip, type, varietyMap);
                          varietyModel.deleteMap();
                          setState(() {
                            for (var controller in _varietyControllers.values) {
                              controller.text = "";
                            }
                          });

                          _showDialog(
                              "Success", "Entry added to the log book!");
                        } catch (e) {
                          _showDialog("Error", e.toString());
                        } finally {
                          _isFormSubmitting = false;
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade900,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isFormSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
