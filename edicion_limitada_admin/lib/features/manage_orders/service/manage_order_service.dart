import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edicion_limitada_admin/features/manage_orders/model/manage_order_model.dart';

class AdminOrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<AdminOrderModel>> fetchAllOrders() async {
    try {
      final QuerySnapshot orderSnapshot = await _firestore
          .collection('orders')
          .orderBy('createdAt', descending: true)
          .get();

      return orderSnapshot.docs
          .map((doc) => AdminOrderModel.fromMap({
                ...doc.data() as Map<String, dynamic>,
                'id': doc.id,
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': newStatus,
      });
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}