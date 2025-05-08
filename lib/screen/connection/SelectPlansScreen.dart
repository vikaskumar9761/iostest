import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/models/plans_model.dart';
import 'package:iostest/providers/bill_notifier.dart';
import 'package:iostest/providers/plans_provider.dart';
import 'package:iostest/screen/bill/ViewBillScreen.dart';
import 'package:iostest/utils/config_util.dart';
import 'package:provider/provider.dart';

class SelectPlansScreen extends StatefulWidget {
  final String selectedCircleName;
  final String selectedCircleId;
  final String number;
  final String operatorName;
  final String operatorId;
  final String category;
  final String operatorType;
  final Map<String, dynamic> billerObject;

  const SelectPlansScreen({
    super.key,
    required this.operatorType,
    required this.selectedCircleName,
    required this.selectedCircleId,
    required this.number,
    required this.operatorName,
    required this.operatorId,
    required this.category,
    required this.billerObject,
  });

  @override
  _SelectPlansScreenState createState() => _SelectPlansScreenState();
}

class _SelectPlansScreenState extends State<SelectPlansScreen> {
  List<Plan> plans = [];
  List<BrowsePlan> browsePlans = [];
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> inputValues = {};
  String query = ""; // Search query
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlans();
    fetchBrowsePlans();
  }

  /// Fetch Browse Plans from ConfigUtil
  Future<void> fetchBrowsePlans() async {
    final fetchedBrowsePlans = await ConfigUtil.getBrowsePlans();
    if (fetchedBrowsePlans.isNotEmpty) {
      setState(() {
        browsePlans = fetchedBrowsePlans;
      });
    } else {
      print("No browse plans found.");
    }
  }

  /// Fetch Plans from API
  Future<void> fetchPlans() async {
    try {
      final plansModel = await PlansProvider().fetchPlans(
        widget.operatorId,
        widget.selectedCircleId,
      );
      if (plansModel != null && plansModel.plans.isNotEmpty) {
        setState(() {
          plans = plansModel.plans;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Filter plans based on the search query
  List<Plan> filterPlans(List<Plan> plans, String query) {
    if (query.isEmpty) {
      return plans;
    }
    return plans.where((plan) {
      final lowerQuery = query.toLowerCase();
      return plan.planName.toLowerCase().contains(lowerQuery) ||
          plan.planDescription.toLowerCase().contains(lowerQuery) ||
          plan.amount.toString().contains(lowerQuery) ||
          plan.validity.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  /// Proceed to the next screen
  Future<void> onProceed(Plan selectedPlan) async {
    setState(() {
      isLoading = true;
    });

    final billNotifier = Provider.of<BillNotifier>(context, listen: false);

    final billData = await billNotifier.fetchBill(
      category: widget.category,
      operatorId: widget.operatorId,
      inputValues: inputValues,
      operatorType: widget.billerObject['operatorType'] ?? '',
    );

    setState(() {
      isLoading = false;
    });

     if (billData != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ViewBillScreen(
            consumerNumber: widget.number ?? '',/// 2255313738 
            operatorName: widget.operatorName,
            number: widget.number,
            operatorId: widget.operatorId,
            category: widget.category,
            billData: {
              'billAmount':selectedPlan.amount?? 0.0,
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

    // if (billData != null) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => PaymentScreen(
    //         operatorType: widget.operatorType,
    //         selectedCircleName: widget.selectedCircleName,
    //         selectedCircleId: widget.selectedCircleId,
    //         number: widget.number,
    //         operatorName: widget.operatorName,
    //         operatorId: widget.operatorId,
    //         category: widget.category,
    //         billerObject: widget.billerObject,
    //         planName: selectedPlan.planName,
    //         amount: selectedPlan.amount,
    //         validity: selectedPlan.validity,
    //       ),
    //     ),
    //   );
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(billNotifier.error ?? 'Failed to fetch bill')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: browsePlans.length, // Number of tabs
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.number,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.operatorType,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        query = value; // Update the search query
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Search plans...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.blue,
                  tabs: browsePlans.map((browsePlan) => Tab(text: browsePlan.planName)).toList(),
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: browsePlans.map((browsePlan) {
                  final filteredPlans = browsePlan.planId == "1"
                      ? filterPlans(plans, query)
                      : filterPlans(
                          plans.where((plan) => plan.planType.toString() == browsePlan.planId).toList(),
                          query,
                        );

                  return buildPlansList(filteredPlans);
                }).toList(),
              ),
      ),
    );
  }

  /// Builds the list of plans
  Widget buildPlansList(List<Plan> plans) {
    if (plans.isEmpty) {
      return const Center(child: Text("No plans found"));
    }

    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onTap: () => onProceed(plan),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "₹ ${plan.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Validity",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  plan.validity,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  plan.dataBenefit,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (plan.planDescription.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              plan.planDescription,
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}