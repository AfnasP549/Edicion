part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}
class OrderError extends OrderState {
  final String message;
  OrderError(this.message);
  
  @override
  List<Object> get props => [message];
}
class OrderLoaded extends OrderState {
  final List<AdminOrderModel> orders;
  OrderLoaded(this.orders);
  
  @override
  List<Object> get props => [orders];
}
