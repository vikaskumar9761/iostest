import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iostest/providers/bill_notifier.dart';
import 'package:iostest/screen/bill/ViewBillScreen.dart';
import 'package:provider/provider.dart';

class ConnectionScreen extends StatefulWidget {
  final String operatorName;
  final String operatorId;
  final String category;
  final String selectedCircleName;
  final String number;
  final Map<String, dynamic> billerObject;

  const ConnectionScreen({
    super.key,
    required this.number,
    required this.operatorName,
    required this.operatorId,
    required this.selectedCircleName,
    required this.category,
    required this.billerObject,
  });

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> inputValues = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize input values with default for 'cn' (consumer number)
    for (var field in widget.billerObject['fields']) {
      if (field['id'] == 'cn') {
        inputValues[field['id']] = widget.number;
      } else {
        inputValues[field['id']] = '';
      }
    }
  }

  String? validateField(Map<String, dynamic> field, String? value) {
    if (value == null || value.isEmpty) {
      return '${field['name']} is required';
    }

    if (field['isnumeric'] == true && !RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Please enter only numbers';
    }

    if (field['regex'] != null && !RegExp(field['regex']).hasMatch(value)) {
      return 'Invalid format';
    }

    if (field['minLen'] != null && value.length < field['minLen']) {
      return 'Minimum ${field['minLen']} characters required';
    }

    if (field['maxLen'] != null && value.length > field['maxLen']) {
      return 'Maximum ${field['maxLen']} characters allowed';
    }

    if (field['min'] != null && field['isnumeric'] == true) {
      double numValue = double.tryParse(value) ?? 0;
      if (numValue < field['min']) {
        return 'Minimum value is ${field['min']}';
      }
    }

    if (field['max'] != null && field['isnumeric'] == true) {
      double numValue = double.tryParse(value) ?? 0;
      if (numValue > field['max']) {
        return 'Maximum value is ${field['max']}';
      }
    }

    return null;
  }

 Future<void> onProceed() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      isLoading = true;
    });

    final billNotifier = Provider.of<BillNotifier>(context, listen: false);

    final billData = await billNotifier.fetchBill(
      category: widget.category,
      operatorId: widget.operatorId,
      inputValues: inputValues,
      operatorType: widget.billerObject['operatorType']??'',
    );

    setState(() {
      isLoading = false;
    });

    if (billData != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ViewBillScreen(
            consumerNumber: billData['cellNumber'] ?? '',
            operatorName: widget.operatorName,
            number: widget.number,
            operatorId: widget.operatorId,
            category: widget.category,
            billData: {
              'billAmount': billData['billAmount'] ?? 0.0,
              'userName': billData['userName'] ?? 'N/A',
              'dueDate': billData['billdate'] ?? '',
            },
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(billNotifier.error ?? 'Failed to fetch bill')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.toUpperCase()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/images/bharat_connect.png', height: 32),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${widget.operatorName}-${widget.selectedCircleName}",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 16),

                // Form Fields
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.billerObject['fields'].length,
                    itemBuilder: (context, index) {
                      final field = widget.billerObject['fields'][index];

                      if (field['id'] == 'amt' && !widget.billerObject['isAmountRequired']) {
                        return SizedBox.shrink();
                      }

                      if (field['skipIfConnection'] == true) {
                        return SizedBox.shrink();
                      }

                      if (field['type'] == 'INPUT') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: TextFormField(
                            initialValue: inputValues[field['id']],
                            decoration: InputDecoration(
                              labelText: field['name'],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: field['icon'] != null
                                  ? Icon(Icons.check_circle)
                                  : null,
                            ),
                            keyboardType: field['isnumeric'] == true
                                ? TextInputType.number
                                : TextInputType.text,
                            inputFormatters: field['isnumeric'] == true
                                ? [FilteringTextInputFormatter.digitsOnly]
                                : null,
                            validator: (value) => validateField(field, value),
                            onChanged: (value) {
                              setState(() {
                                inputValues[field['id']] = value;
                              });
                            },
                          ),
                        );
                      } else if (field['type'] == 'TEXT' &&
                          field['id'] != 'cn' &&
                          field['id'] != 'amt') {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Text(field['name']),
                          ),
                        );
                      }

                      return SizedBox.shrink();
                    },
                  ),
                ),

                SizedBox(height: 16),

                ElevatedButton(
                  onPressed: isLoading ? null : onProceed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Proceed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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
