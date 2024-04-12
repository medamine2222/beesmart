import 'package:cwt_ecommerce_app/features/shop/screens/order/widgets/purchases.dart';
import 'package:cwt_ecommerce_app/features/shop/screens/order/widgets/sales.dart';
import 'package:flutter/material.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../utils/constants/sizes.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState()=> _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('My Orders', style: Theme.of(context).textTheme.headlineSmall),
        showBackArrow: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: _currentIndex == 0 ? Colors.grey : Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Purchases',
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentIndex == 0 ? Colors.black : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(10),
                    backgroundColor: _currentIndex == 1 ? Colors.grey : Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text(
                    'Sales',
                    style: TextStyle(
                      fontSize: 14,
                      color: _currentIndex == 1 ? Colors.black : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace),
              child: _currentIndex == 0 ? const PurchasesScreen() : const SalesScreen(),
            ),
          ),
        ],
      ),
    );
  }
}
