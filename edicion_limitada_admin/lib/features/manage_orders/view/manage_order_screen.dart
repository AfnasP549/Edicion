import 'dart:convert';

import 'package:edicion_limitada_admin/features/manage_orders/cubit/order_cubit.dart';
import 'package:edicion_limitada_admin/features/manage_orders/model/manage_order_model.dart';
import 'package:edicion_limitada_admin/features/manage_orders/service/manage_order_service.dart';
import 'package:edicion_limitada_admin/features/manage_orders/view/order_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrderCubit(AdminOrderService())..fetchOrders(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Manage Orders'),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is OrderError) {
              return Center(child: Text(state.message));
            } else if (state is OrderLoaded) {
              return ListView.builder(
                itemCount: state.orders.length,
                itemBuilder: (context, index) {
                  final order = state.orders[index];
                  return OrderCard(order: order);
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final AdminOrderModel order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  // Define status options as constants to ensure consistency
  static const orderStatuses = [
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  // Helper method to get display text for status
  String getStatusDisplay(String status) {
    // Capitalize first letter
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${order.id}'),
            Text('Total Amount: \$${order.totalAmount.toStringAsFixed(2)}'),
            Text('Status: ${getStatusDisplay(order.status)}'),
            Text('Payment Status: ${order.paymentStatus}'),
            const SizedBox(height: 8),
            const Text('Shipping Address:'),
            Text(order.address.toString()),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Update Status: '),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButton<String>(
                    value: order.status.toLowerCase(),
                    isExpanded: true,
                    items: orderStatuses.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(getStatusDisplay(value)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<OrderCubit>().updateOrderStatus(
                              order.id,
                              newValue,
                            );
                      }
                    },
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: (){
                  Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderHistoryScreen(order: order),
          ),
        );
              },
              child: ExpansionTile(
                title: const Text('Order Items'),
                children: order.items.map((item) {
                  return ListTile(
                    leading: item.imageUrl.isNotEmpty
                        ? Image.memory(
                            base64Decode(item.imageUrl),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                        : const Icon(Icons.image_not_supported),
                    title: Text(item.productName),
                    subtitle: Text(
                      'Quantity: ${item.quantity} - Price: \$${item.price.toStringAsFixed(2)}',
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}