import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/flutter_bluetooth_printer.dart';
import 'package:chicken_dilivery/Model/salesModel.dart';

class ReceiptPage extends StatefulWidget {
  final Salesmodel salesData;
  final String itemName;
  final String shopName;
  final String rootName;

  const ReceiptPage({
    super.key,
    required this.salesData,
    required this.itemName,
    required this.shopName,
    required this.rootName,
  });

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  ReceiptController? controller;

  Future<void> _printReceipt() async {
    final device = await FlutterBluetoothPrinter.selectDevice(context);

    if (device != null) {
      controller?.print(address: device.address);
    }
  }

  // Helper method to format date
  String _formatDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        return '${parts[0]}/${parts[1]}/${parts[2]}';
      }
      return date;
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Receipt'),
        backgroundColor: const Color.fromARGB(255, 26, 11, 167),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: Receipt(
              builder: (context) => Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  const SizedBox(height: 10),
                  Text(
                    'CHICKEN DELIVERY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Fresh Chicken Shop',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 15),
                  
                  // Divider
                  Divider(color: Colors.grey[400], thickness: 1),
                  const SizedBox(height: 10),
                  
                  // Bill Information
                  _buildReceiptRow('Bill No:', widget.salesData.billNo),
                  // _buildReceiptRow('Date:', _formatDate(widget.salesData.addedDate)),
                  _buildReceiptRow('Root:', widget.rootName),
                  _buildReceiptRow('Shop:', widget.shopName),
                  
                  const SizedBox(height: 15),
                  Divider(color: Colors.grey[400], thickness: 1),
                  const SizedBox(height: 10),
                  
                  // Item Details Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('ITEM', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('QTY', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('RATE', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('AMOUNT', style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  Divider(color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  
                  // Item Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          widget.itemName,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${widget.salesData.quantityKg} kg',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rs.${widget.salesData.sellingPrice}',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Rs.${(widget.salesData.amount ?? 0).toStringAsFixed(2)}',
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 15),
                  Divider(color: Colors.grey[400], thickness: 1),
                  const SizedBox(height: 10),
                  
                  // Total Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL AMOUNT:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Rs.${(widget.salesData.amount ?? 0).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  // VAT Number if available
                  if (widget.salesData.vatNumber != null && widget.salesData.vatNumber!.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        _buildReceiptRow('VAT No:', widget.salesData.vatNumber!),
                      ],
                    ),
                  
                  const SizedBox(height: 20),
                  
                  // Footer
                  Divider(color: Colors.grey[400], thickness: 1),
                  const SizedBox(height: 10),
                  Text(
                    'Thank you for your business!',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Visit again',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
              onInitialized: (controller) {
                this.controller = controller;
              },
            ),
          ),
          
          // Print Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _printReceipt,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 26, 11, 167),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.print, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Print Receipt',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[600],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Go Back',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}