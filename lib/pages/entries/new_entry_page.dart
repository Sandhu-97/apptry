import 'package:apptry/backend/database.dart';
import 'package:apptry/constants.dart';
import 'package:apptry/pages/entries/variety_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewEntryPage extends StatefulWidget {
  const NewEntryPage({super.key});

  @override
  State<NewEntryPage> createState() => _NewEntryPageState();
}

class _NewEntryPageState extends State<NewEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _slipController = TextEditingController();

  final _varietyControllers = {
    'Pukhraj': TextEditingController(),
    'Jyoti': TextEditingController(),
    'Diamant': TextEditingController(),
    'Cardinal': TextEditingController(),
    'Himalini': TextEditingController(),
    'Badshah': TextEditingController(),
    'Others': TextEditingController(),
  };

  String type = 'add';
  @override
  Widget build(BuildContext context) {
    final varietyModel = Provider.of<VarietyModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Entry"),
      ),
      body: ListView(
        children: [
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: "Phone",
              hintText: "Enter customer's phone number",
            ),
            onChanged: (value) async {
              if (value.length == 10) {
                // fetch name from phone number
                try {
                  final String name = await getName(value);
                  setState(() {
                    _nameController.text = name;
                  });
                } catch (e) {
                  _nameController.text = "Customer not found";
                }
              }
            },
          ),
          TextField(
            controller: _nameController,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Name",
              hintText: "Enter customer's name",
            ),
          ),
          TextField(
            controller: _slipController,
            decoration: InputDecoration(
              labelText: "Slip",
              hintText: "Enter slip number",
            ),
          ),
          DropdownButtonFormField(
              value: "add",
              hint: Text("Add/Remove"),
              items: [
                DropdownMenuItem(value: "add", child: Text("Add")),
                DropdownMenuItem(value: "remove", child: Text("Remove")),
              ],
              onChanged: (value) {
                type = value.toString();
              }),
          for (var variety in varietyNames)
            ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Quantity for $variety"),
                          content: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                for (var subVariety in subVarietyNames)
                                  TextFormField(
                                    initialValue: (varietyModel.getValue(
                                                "${variety}_$subVariety")) ==
                                            0
                                        ? ""
                                        : (varietyModel.getValue(
                                                "${variety}_$subVariety"))
                                            .toString(),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      }
                                      if (int.tryParse(value) == null) {
                                        return "Value must be number";
                                      }
                                      if (int.parse(value) < 0) {
                                        return "Value cannot be negative";
                                      }
                                      if (int.parse(value) > 1000) {
                                        return "Value cannot be greater than 1000";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: subVariety,
                                      hintText:
                                          "Enter quantity for $subVariety",
                                    ),
                                    onChanged: (value) {
                                      varietyModel.updateValue(
                                          "${variety}_$subVariety",
                                          int.tryParse(value) ?? 0);
                                    },
                                  ),
                                ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ==
                                          false) {
                                        return;
                                      }
                                      int totalVariety = 0;
                                      for (var subVariety in subVarietyNames) {
                                        totalVariety += varietyModel
                                            .getValue("${variety}_$subVariety");
                                      }
                                      setState(() {
                                        _varietyControllers[variety]?.text =
                                            totalVariety.toString();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Done")),
                              ],
                            ),
                          ),
                        );
                      });
                },
                child: Row(
                  children: [
                    Text(variety),
                    Spacer(),
                    Text("${_varietyControllers[variety]?.text}"),
                  ],
                )),
          ElevatedButton(
              onPressed: () async {
                final phone = _phoneController.text;
                final slip = int.tryParse(_slipController.text) ?? -1;
                final varietyMap = varietyModel.getMap();
                //await addNewLog(phone, slip, type, varietyMap);
                // print(varietyMap);
                varietyModel.deleteMap();
                setState(() {
                  for (var controller in _varietyControllers.values) {
                    controller.text = "";
                  }
                });
              },
              child: Text("Submit")),
        ],
      ),
    );
  }
}
