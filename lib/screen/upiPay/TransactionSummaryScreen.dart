import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iostest/providers/payment_status_notifier.dart';

class TransactionSummaryScreen extends StatefulWidget {
  final bool isSuccessful;
  final String message;
  final String amount;
  final String transactionId;

  const TransactionSummaryScreen({
    super.key,
    required this.isSuccessful,
    required this.message,
    required this.amount,
    required this.transactionId,
  });

  @override
  State<TransactionSummaryScreen> createState() => _TransactionSummaryScreenState();
}

class _TransactionSummaryScreenState extends State<TransactionSummaryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentStatusNotifier>().startStatusCheck(widget.transactionId,(isSuccessful, message) {
        print('Transaction status: $isSuccessful, message: $message');
      },);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('  Transaction Summary'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Consumer<PaymentStatusNotifier>(
            builder: (context, notifier, child) {
              return Column(
                children: [
                  _buildStatusIcon(notifier),
                  SizedBox(height: 30),
                  _buildTransactionCard(),
                  SizedBox(height: 20),
                  _buildRechargeSummaryCard(notifier),
                  SizedBox(height: 40),
                  _buildDoneButton(context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon(PaymentStatusNotifier notifier) {
    final status = notifier.transactionData?['txnStatus'];
    return Column(
      children: [
        Icon(
          status == 3 ? Icons.check_circle :
          status == 1 ? Icons.error :
          status == 2 ? Icons.pending : Icons.help,
          color: status == 3 ? Colors.green :
                 status == 1 ? Colors.red :
                 status == 2 ? Colors.orange : Colors.grey,
          size: 80,
        ),
        SizedBox(height: 20),
        Text(
          status == 3 ? 'Payment Successful' :
          status == 1 ? 'Payment Failed' :
          status == 2 ? 'Payment Processing' : 'Checking Status...',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _buildInfoRow('Amount', '₹${widget.amount}'),
            _buildInfoRow('Transaction ID', widget.transactionId),
            _buildInfoRow('Date & Time', _getCurrentDateTime()),
          ],
        ),
      ),
    );
  }

  Widget _buildRechargeSummaryCard(PaymentStatusNotifier notifier) {
    if (notifier.isLoading && notifier.transactionData == null) {
      return Center(
        child: Column(
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Checking recharge status...'),
          ],
        ),
      );
    }

    if (notifier.error != null) {
      return Card(
        color: Colors.red[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(notifier.error!, style: TextStyle(color: Colors.red[900])),
        ),
      );
    }

    if (notifier.transactionData != null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recharge Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              _buildInfoRow('Status', _getStatusText(notifier.transactionData!['txnStatus'])),
              _buildInfoRow('Amount Debited', notifier.transactionData!['customerDebited'] ? 'Yes' : 'No'),
              if (notifier.transactionData!['operatorTxnId'] != null)
                _buildInfoRow('Operator Transaction ID', notifier.transactionData!['operatorTxnId']),
              if (notifier.isLoading)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 8),
                      Text('Updating...', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return SizedBox.shrink();
  }

  // ... Keep existing helper methods (_buildInfoRow, _getCurrentDateTime, etc.)

  String _getStatusText(int status) {
    switch (status) {
      case 1:
        return 'Failed';
      case 2:
        return 'Processing';
      case 3:
        return 'Successful';
      default:
        return 'Unknown';
    }
  }

  Widget _buildDoneButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Text('Done', style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrentDateTime() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}, ${_formatTimeOfDay(now)}';
  }

  String _formatTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final hourString = hour == 0 ? '12' : hour.toString();
    final minuteString = dateTime.minute.toString().padLeft(2, '0');
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    return '$hourString:$minuteString $period';
  }
}