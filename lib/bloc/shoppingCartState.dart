import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'package:engage/models/shoppingCartModel.dart';

import 'package:engage/app/engageApp.dart' as app;

abstract class ShoppingCartState extends Equatable {
  const ShoppingCartState();

  @override
  List<Object> get props => [];
}

class ShoppingCartEmpty extends ShoppingCartState {}

class ShoppingCartLoading extends ShoppingCartState {}

class ShoppingCartLoaded extends ShoppingCartState {
  final ShoppingCartModel shoppingCart;

  const ShoppingCartLoaded({@required this.shoppingCart}) : assert(shoppingCart != null);

  @override
  List<Object> get props => [shoppingCart];
}

class ShoppingCartError extends ShoppingCartState {}