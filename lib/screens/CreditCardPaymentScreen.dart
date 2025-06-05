import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math'; // Import for min function

// This CreditCardPaymentScreen and its formatters remain unchanged as per your request
// and will not be modified.
class CreditCardPaymentScreen extends StatefulWidget {
  const CreditCardPaymentScreen({Key? key}) : super(key: key);

  @override
  State<CreditCardPaymentScreen> createState() => _CreditCardPaymentScreenState();
}

class _CreditCardPaymentScreenState extends State<CreditCardPaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF50E0F10), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white), // White back arrow
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pay with Credit/Debit Card',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal), // White title
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            padding: const EdgeInsets.all(25.0),
            decoration: BoxDecoration(
              color: const Color(0xFF17191B), // Darker grey for card background
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3), // Darker shadow for dark mode
                  spreadRadius: 5,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Pay with',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    color: Colors.white, // White text
                  ),
                ),
                const SizedBox(height: 20),
                // Credit Card Logos
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCardLogo('assets/visa_logo.png'),
                    _buildCardLogo('assets/mastercard_logo.webp'),
                    _buildCardLogo('assets/paypal_logo.png'),
                    _buildCardLogo('assets/apple_logo.png'),
                  ],
                ),
                const SizedBox(height: 30),

                // Card Number Input
                _buildInputField(
                  controller: _cardNumberController,
                  labelText: 'Card number',
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(19), // Max 16 digits + 3 spaces
                    CardNumberInputFormatter(),
                  ],
                ),
                const SizedBox(height: 25),

                // Exp Date and CVV2 Inputs
                Row(
                  children: [
                    Expanded(
                      child: _buildInputField(
                        controller: _expDateController,
                        labelText: 'Exp Date',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(5), // MM/YY
                          ExpirationDateFormatter(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: _buildInputField(
                        controller: _cvvController,
                        labelText: 'CVV',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(3), // Max 4 digits
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Pay Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement payment logic here
                      print('Card Number: ${_cardNumberController.text}');
                      print('Exp Date: ${_expDateController.text}');
                      print('CVV: ${_cvvController.text}');
                      // Show a confirmation or success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payment initiated!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A755D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Pay 100 USD',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  // Helper widget for building text input fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70, // Light grey label for dark mode
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2E), // Darker background for input field
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade700), // Darker border
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 18, color: Colors.white), // White text input
            cursorColor: Colors.white, // White cursor
          ),
        ),
      ],
    );
  }

  // Helper widget for building credit card logos (no changes needed)
  Widget _buildCardLogo(String imagePath) {
    return Container(
      width: 60, // Fixed width for consistency
      height: 40, // Fixed height for consistency
      padding: const EdgeInsets.all(5), // Add some padding inside the container
      decoration: BoxDecoration(
        color: Colors.white, // White background for the logos
        borderRadius: BorderRadius.circular(8), // Apply border radius
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(
        imagePath,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to a generic icon if image fails to load
          return const Icon(Icons.credit_card, size: 30, color: Colors.grey); // Larger fallback icon
        },
      ),
    );
  }
}

// Custom Input Formatter for Credit Card Number (adds spaces) - No changes
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text;

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }

    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

// UPDATED Custom Input Formatter for Expiration Date (MM/YY) - Remains same as last successful attempt
class ExpirationDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    // Only allow digits
    String digitsOnly = text.replaceAll(RegExp(r'\D'), '');
    String formattedText = '';

    if (digitsOnly.length > 0) {
      // Month (first two digits)
      formattedText += digitsOnly.substring(0, min(2, digitsOnly.length));
      if (digitsOnly.length >= 3) {
        // Add slash after month if there are year digits
        formattedText += '/';
        // Year (remaining digits)
        formattedText += digitsOnly.substring(2, min(4, digitsOnly.length));
      }
    }

    // Ensure total length is not more than 5 (MM/YY)
    if (formattedText.length > 5) {
      formattedText = formattedText.substring(0, 5);
    }

    // Adjust cursor position
    TextSelection newSelection = TextSelection.collapsed(offset: formattedText.length);

    // If the old value was shorter and the new value gained a slash,
    // ensure the cursor moves past the slash.
    if (oldValue.text.length < formattedText.length &&
        formattedText.length == 3 &&
        formattedText.contains('/') &&
        oldValue.text.length == 2) {
      newSelection = TextSelection.collapsed(offset: formattedText.length);
    } else if (oldValue.text.length > formattedText.length &&
        oldValue.text.endsWith('/') &&
        formattedText.length == 2) {
      // Handle backspace over the slash
      newSelection = TextSelection.collapsed(offset: formattedText.length);
    } else {
      // Default behavior: keep cursor at the end
      newSelection = TextSelection.collapsed(offset: formattedText.length);
    }


    return TextEditingValue(
      text: formattedText,
      selection: newSelection,
    );
  }
}

// MODIFIED CryptoPayment class
class CryptoPayment extends StatefulWidget {
  const CryptoPayment({Key? key}) : super(key: key);

  @override
  State<CryptoPayment> createState() => _CryptoPaymentState();
}

class _CryptoPaymentState extends State<CryptoPayment> {
  // State for the selected tab: 0 for Transactions, 1 for Assets
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xF50E0F10), // Dark background
      appBar: AppBar( // Added AppBar for the header
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Crypto Wallet', // Header text for the CryptoPayment page
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Balance Section
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              child: Column(
                children: const [
                  Text(
                    '\$288.82', // Balance amount
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Balance', // Balance label
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons Section (Add funds, Send, More)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.add,
                    label: 'Add funds',
                    iconColor: Colors.white,
                    backgroundColor: Colors.blue,
                    onTap: () {
                      _showAddFundsOptions(context); // New: Show Add Funds options
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.send,
                    label: 'Send',
                    iconColor: Colors.white,
                    backgroundColor: const Color(0xFF2C2C2E),
                    onTap: () {
                      _showSendFundsOptions(context); // New: Show Send Funds options
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.more_horiz,
                    label: 'More',
                    iconColor: Colors.white,
                    backgroundColor: const Color(0xFF2C2C2E),
                    onTap: () {
                      _showMoreOptions(context); // New: Show More options
                    },
                  ),
                ],
              ),
            ),

            // Tabs Section (Transactions, Assets)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1F1F23),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 0;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: _selectedTab == 0 ? const Color(0xFF17191B) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Transactions', // Transactions tab
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 0 ? Colors.white : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTab = 1;
                          });
                          // The content will be updated by _buildAssetsList, no need for _showAssetsOptions here.
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          decoration: BoxDecoration(
                            color: _selectedTab == 1 ? const Color(0xFF17191B) : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              'Assets', // Assets tab
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: _selectedTab == 1 ? Colors.white : Colors.grey.shade400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content based on selected tab (Transaction List or Assets List)
            Expanded(
              child: _selectedTab == 0
                  ? _buildTransactionList() // Displays transaction list
                  : _buildAssetsList(), // Placeholder for Assets List
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for action buttons (Add funds, Send, More)
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required Color backgroundColor,
    required VoidCallback onTap, // Added onTap callback
  }) {
    return Column(
      children: [
        GestureDetector( // Wrap with GestureDetector for tap functionality
          onTap: onTap,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 30,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Widget to build the list of transactions
  Widget _buildTransactionList() {
    // Sample transaction data matching the image
    final List<Map<String, dynamic>> transactions = [
      {
        'logo': 'assets/images/mcdonalds_logo.png',
        'name': 'McDonald\'s',
        'date': 'On Aug \'12',
        'amount': '- \$46.23',
      },
      {
        'logo': 'assets/images/starbucks_logo.png',
        'name': 'Starbucks',
        'date': 'On Aug \'12',
        'amount': '- \$20.73',
      },
      {
        'logo': 'assets/images/metamask_logo.png',
        'name': 'Wallet connected',
        'date': 'On Aug \'12',
        'amount': '',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              // Transaction Logo/Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2C2C2E),
                ),
                child: ClipOval(
                  child: Image.asset(
                    transaction['logo'],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.account_balance_wallet, size: 24, color: Colors.grey.shade400);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 15),
              // Transaction Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      transaction['date'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              // Transaction Amount
              Text(
                transaction['amount'],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: transaction['amount'].startsWith('-') ? Colors.white : Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // New: Method to show "Add Funds" options
  void _showAddFundsOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17191B), // Dark background for bottom sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Funds From:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildAddFundsOption(
                context,
                icon: 'assets/delta.png',
                name: 'Delta Wallet',
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _showToast(context, 'Connecting to Delta Wallet...');
                  // Implement Delta wallet integration logic here
                },
              ),
              _buildAddFundsOption(
                context,
                icon: 'assets/MetaMask.png',
                name: 'MetaMask',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Connecting to MetaMask...');
                  // Implement MetaMask integration logic here
                },
              ),
              _buildAddFundsOption(
                context,
                iconData: Icons.qr_code,
                name: 'Scan QR Code',
                isIcon: true,
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Opening QR scanner...');
                  // Implement QR code scanner logic here
                },
              ),
              _buildAddFundsOption(
                context,
                iconData: Icons.wallet,
                name: 'Other Wallet',
                isIcon: true,
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Please enter wallet address...');
                  // Implement manual address input logic here
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }


  // Helper for "Add Funds" options
  Widget _buildAddFundsOption(BuildContext context, {String? icon, String? name, IconData? iconData, bool isIcon = false, required VoidCallback onTap}) {
    return ListTile(
      leading: isIcon
          ? Icon(iconData, color: Colors.white70, size: 30)
          : (icon != null ? Image.asset(icon, width: 30, height: 30) : null),
      title: Text(name ?? '', style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    );
  }

  // New: Method to show "Send Funds" options
  void _showSendFundsOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17191B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Send Funds To:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildSendOption(
                context,
                icon: Icons.qr_code_scanner,
                label: 'Scan QR Code',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Opening QR scanner for sending...');
                  // Implement QR code scanner for sending logic
                },
              ),
              _buildSendOption(
                context,
                icon: Icons.account_balance_wallet,
                label: 'Enter Wallet Address',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Prompting for wallet address...');
                  // Implement wallet address input logic
                },
              ),
              _buildSendOption(
                context,
                icon: Icons.person_add,
                label: 'Send to Contact',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Opening contacts list...');
                  // Implement send to contact logic
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Helper for "Send Funds" options
  Widget _buildSendOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 30),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    );
  }

  // New: Method to show "More" options
  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF17191B),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'More Options',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 20),
              _buildMoreOption(
                context,
                icon: Icons.history,
                label: 'Transaction History',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Viewing full transaction history...');
                  // Navigate to full transaction history screen
                },
              ),
              _buildMoreOption(
                context,
                icon: Icons.settings,
                label: 'Settings',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Opening settings...');
                  // Navigate to settings screen
                },
              ),
              _buildMoreOption(
                context,
                icon: Icons.security,
                label: 'Security',
                onTap: () {
                  Navigator.pop(context);
                  _showToast(context, 'Accessing security options...');
                  // Navigate to security settings
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // Helper for "More" options
  Widget _buildMoreOption(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 30),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 18)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
    );
  }

  // New: Method to build the Assets List
  Widget _buildAssetsList() {
    // Sample asset data
    final List<Map<String, String>> assets = [
      {'name': 'Ethereum', 'amount': '0.5 ETH', 'value': '\$1,800.00'},
      {'name': 'Algorand', 'amount': '1000 ALGO', 'value': '\$250.00'},
      {'name': 'Bitcoin', 'amount': '0.005 BTC', 'value': '\$300.00'},
      {'name': 'Dogecoin', 'amount': '500 DOGE', 'value': '\$40.00'},
      {'name': 'Litecoin', 'amount': '1.2 LTC', 'value': '\$80.00'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: _buildAssetEntry(context, asset['name']!, asset['amount']!, asset['value']!),
        );
      },
    );
  }

  // Helper for "Assets" entries
  Widget _buildAssetEntry(BuildContext context, String name, String amount, String value) {
    return Row(
      children: [
        // Placeholder for asset icon (you can replace with actual crypto icons)
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF2C2C2E),
          ),
          child: Icon(
            _getAssetIcon(name), // Get appropriate icon based on asset name
            color: Colors.grey,
            size: 28,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper to get asset icons (example)
  IconData _getAssetIcon(String assetName) {
    switch (assetName) {
      case 'Ethereum':
        return Icons.monetization_on;
      case 'Bitcoin':
        return Icons.monetization_on;
      case 'Algorand':
        return Icons.monetization_on;
      case 'Dogecoin':
        return Icons.monetization_on;
      case 'Litecoin':
        return Icons.monetization_on;
      default:
        return Icons.monetization_on;
    }
  }

  // New: Helper for showing a Toast message
  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}