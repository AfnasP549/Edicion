import 'package:bloc/bloc.dart';
import 'package:edicion_limitada_admin/features/manage_orders/model/manage_order_model.dart';
import 'package:edicion_limitada_admin/features/manage_orders/service/manage_order_service.dart';
import 'package:equatable/equatable.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final AdminOrderService _orderService;
  OrderCubit(this._orderService) : super(OrderInitial());


  Future<void> fetchOrders() async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.fetchAllOrders();
      emit(OrderLoaded(orders));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _orderService.updateOrderStatus(orderId, newStatus);
      await fetchOrders(); // Refresh the orders list
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }
}
