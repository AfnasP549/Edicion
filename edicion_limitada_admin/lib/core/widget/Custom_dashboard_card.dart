
import 'package:flutter/material.dart';

class CustomDashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isFirst;
  final VoidCallback? onTap;  // Added onTap callback

  const CustomDashboardCard({
    super.key,
    required this.icon,
    required this.label,
    this.isFirst = false,
    this.onTap,  // Made optional but recommended
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(  // Added InkWell for tap effect
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),  // Matching card's border radius
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade400,
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}