import 'package:flutter/material.dart';

class HistoryComponent extends StatelessWidget {
  final List<TransactionData> transactions;

  const HistoryComponent({
    super.key,
    this.transactions = const [],
    // this.transactions = const [
    //   TransactionData(
    //     id: "SN10-081212179828",
    //     amount: "-IDR120.000",
    //     date: "Jun 22, 2022",
    //     time: "2:20 PM",
    //     iconUrl: "https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-11.png",
    //   ),
    //   TransactionData(
    //     id: "SN10-081212179828",
    //     amount: "-IDR56.000",
    //     date: "Jun 22, 2022",
    //     time: "2:20 PM",
    //     iconUrl: "https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-11-2.png",
    //   ),
    //   TransactionData(
    //     id: "SN10-081212179828",
    //     amount: "-IDR88.000",
    //     date: "Jun 22, 2022",
    //     time: "2:20 PM",
    //     iconUrl: "https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/group-11-3.png",
    //   ),
    // ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 258),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'History',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1E25),
                ),
              ),
              InkWell(
                onTap: () {
                  // Handle see all tap
                },
                child: Row(
                  children: [
                    Text(
                      'See all',
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1E25),
                      ),
                    ),
                    SizedBox(width: 8),
                    Image.network(
                      'https://dashboard.codeparrot.ai/api/image/Z-VCBQggqYBhYb7w/chevron.png',
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Container(
              height: 1,
              color: Color(0xFFF7F7F7),
              margin: EdgeInsets.symmetric(vertical: 8),
            ),
            itemBuilder: (context, index) {
              return TransactionItem(transaction: transactions[index]);
            },
          ),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final TransactionData transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Row(
        children: [
          Image.network(
            transaction.iconUrl,
            width: 48,
            height: 48,
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  transaction.id,
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1E25),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      transaction.time,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Color(0xFF808D9E),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: 3,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Color(0xFF808D9E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      transaction.date,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        fontSize: 12,
                        color: Color(0xFF808D9E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            transaction.amount,
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D1E25),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionData {
  final String id;
  final String amount;
  final String date;
  final String time;
  final String iconUrl;

  TransactionData({
    required this.id,
    required this.amount,
    required this.date,
    required this.time,
    required this.iconUrl,
  });
}
