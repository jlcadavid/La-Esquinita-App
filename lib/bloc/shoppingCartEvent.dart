import 'package:equatable/equatable.dart';

abstract class ShoppingCartEvent extends Equatable {
  const ShoppingCartEvent();
}

class FetchShoppingCart extends ShoppingCartEvent {
  const FetchShoppingCart();

  @override
  List<Object> get props => [];
}