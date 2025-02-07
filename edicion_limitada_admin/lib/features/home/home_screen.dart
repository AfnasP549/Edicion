import 'package:edicion_limitada_admin/core/utils/navigator_utils.dart';
import 'package:edicion_limitada_admin/core/widget/custom_appbar.dart';
import 'package:edicion_limitada_admin/features/ads/view/ads_screen.dart';
import 'package:edicion_limitada_admin/features/brands/view/brands_screen.dart';
import 'package:edicion_limitada_admin/core/widget/Custom_dashboard_card.dart';
import 'package:edicion_limitada_admin/features/dashboard/view/dashboard.dart';
import 'package:edicion_limitada_admin/features/manage_orders/view/manage_order_screen.dart';
import 'package:edicion_limitada_admin/features/product/view/product_screen.dart';
import 'package:edicion_limitada_admin/features/screen/login_screen.dart/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar:  CustomAppbar(title: 'EDICIÓN',
        action: [
    IconButton(
      icon:  const Icon(
        Icons.logout,
        color: Colors.black,
      ),
      onPressed: ()  {
      _showLogoutConfirmation(context);
      },
    ),
  ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          children: [
            CustomDashboardCard(
              icon: Icons.dashboard,
              label: 'Dashboard',
              isFirst: true,
              onTap: () {
                
               customNavigator(context, const AdminDashboard());
              },
            ),
            CustomDashboardCard(
              icon: Icons.mobile_friendly_outlined,
              label: 'Brand Details',
              onTap: () {
               customNavigator(context,   const BrandsScreen());
              },
            ),
            // CustomDashboardCard(
            //   icon: Icons.add_box_outlined,
            //   label: 'Add Product',
            //   onTap: () {
            //     customNavigator(context, const AddProductScreen());
               
            //   },
            // ),
            
            CustomDashboardCard(
              icon: Icons.shopping_cart_outlined,
              label: 'Manage Products',
              onTap: () {
               
                customNavigator(context, const ProductScreen());
              },
            ),

            //!Manage Order
            CustomDashboardCard(
              icon: Icons.inventory_2_outlined,
              label: 'Manage Orders',
              onTap: () {
              
                customNavigator(context, const AdminOrderScreen());
              },
            ),
            CustomDashboardCard(
              icon: Icons.people_outline,
              label: 'ads',
              onTap: () {
                customNavigator(context, const AdsScreen());

              },
            ),
            
          ],
        ),
      ),
    );
  }

    Future<void> _showLogoutConfirmation(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Close dialog first
                Navigator.of(context).pop();
                
                // Perform logout
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
