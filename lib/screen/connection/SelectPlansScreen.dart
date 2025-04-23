import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/models/plans_model.dart';
import 'package:iostest/providers/plans_provider.dart';
import 'package:iostest/screen/PaymentScreen/payment_screen.dart';
import 'package:iostest/utils/config_util.dart';

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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
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
                  // Enable scrolling for tabs
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black,
                  indicatorColor: Colors.blue,
                  tabs: browsePlans.map((browsePlan) =>
                      Tab(text: browsePlan.planName)).toList(),
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
          children: browsePlans.map((browsePlan) {
            // Show all plans if planId is 1, otherwise filter by planId
            final filteredPlans = browsePlan.planId == "1"
                ? filterPlans(plans, query) // Show all plans for planId = 1
                : filterPlans(
              plans.where((plan) {
                return plan.planType.toString() ==
                    browsePlan.planId; // Match planType with planId
              }).toList(),
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PaymentScreen(
                      operatorType: widget.operatorType,
                      selectedCircleName: widget.selectedCircleName,
                      selectedCircleId: widget.selectedCircleId,
                      number: widget.number,
                      operatorName: widget.operatorName,
                      operatorId: widget.operatorId,
                      category: widget.category,
                      billerObject: widget.billerObject,
                      planName: plan.planName,
                      amount: plan.amount,
                      validity: plan.validity,
                    ),
              ),
            );
          },
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
                  // Amount
                  Text(
                    "₹ ${plan.amount.toStringAsFixed(0)}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 12), // Space between Amount and content

                  // Expanded content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Validity & Data Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Validity
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Validity",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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

                            // Data
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Data",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Plan Name",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  plan.planName,
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

                        // Full Description (no overflow)
                        if (plan.planDescription.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              plan.planDescription,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Arrow icon
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