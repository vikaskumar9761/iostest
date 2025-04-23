import 'package:flutter/material.dart';
import 'package:iostest/models/config_model.dart';
import 'package:iostest/screen/operator/OperatorSelectionScreen.dart';
import '../../widgets/mobile_recharge_widgets.dart';

class MobileRechargeScreen extends StatefulWidget {
  final List<BillerRoot> billerRoot;
  final String categoryId ;
//final List<Circle> CirclesList;
  const MobileRechargeScreen({super.key,
   required this.billerRoot, 
   required this.categoryId,

   });

  @override
  _MobileRechargeScreenState createState() => _MobileRechargeScreenState();
}

class _MobileRechargeScreenState extends State<MobileRechargeScreen> {
  String rechargeType = "Prepaid";
  final TextEditingController phoneController = TextEditingController();

  List<BillerRoot> filterBillerRoots(List<BillerRoot> billerRoots, String type) {
    final billerRootArray=List<BillerRoot>.empty(growable: true);


for (BillerRoot billerRoot in billerRoots) {
  final billersObj = List<Biller>.empty(growable: true);

  for (Biller biller in billerRoot.billers) {
    if (biller.type.toLowerCase() == type.toLowerCase()) {
      billersObj.add(biller);
      debugPrint('Biller Name: ${biller.info}');
    }
  }

 billerRootArray.add(BillerRoot(name: billerRoot.name, billers: billersObj));
}
    return billerRootArray;
  }

  void handleProceed() async {
    String phone = phoneController.text.trim();
    print(phone);

    if (phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone)) {
      List<BillerRoot> billerRootsList = filterBillerRoots(widget.billerRoot, rechargeType);
      print(billerRootsList.length);
print('Operator selection screen called');

//print('CirclesList: ${widget.CirclesList?.length ?? 0}');
 
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OperatorSelectionScreen(
            categoryId: 'mobile',
            billerRoot: billerRootsList,//pass billerRoot List Item
            phoneNumber: phone, //  Pass user number here
            ),
            )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid 10-digit phone number'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Recharge'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MobileRechargeWidgets.rechargeTypeSelector(
              selectedType: rechargeType,
              onChanged: (type) {
                setState(() {
                  rechargeType = type;
                });
              },
            ),
            SizedBox(height: 30),
            MobileRechargeWidgets.phoneNumberInput(controller: phoneController),
            SizedBox(height: 30),
            MobileRechargeWidgets.proceedButton(onPressed: handleProceed),
          ],
        ),
      ),
    );
  }
}
