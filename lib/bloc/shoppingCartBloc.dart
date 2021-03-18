import 'package:engage/bloc/shoppingCartEvent.dart';
import 'package:engage/bloc/shoppingCartState.dart';
import 'package:engage/models/shoppingCartModel.dart';
import 'package:engage/models/userModel.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:engage/app/engageApp.dart' as app;

class ShoppingCartBloc extends Bloc<ShoppingCartEvent, ShoppingCartState> {
  final UserModel buyer;

  ShoppingCartBloc(this.buyer)
      : assert(buyer != null),
        super(ShoppingCartEmpty());

  @override
  Stream<ShoppingCartState> mapEventToState(ShoppingCartEvent event) async* {
    if (event is FetchShoppingCart) {
      yield ShoppingCartLoading();
      try {
        final ShoppingCartModel shoppingCart =
            await app.apiClientService.fetchShoppingCart(buyer);
        yield ShoppingCartLoaded(shoppingCart: shoppingCart);
      } catch (_) {
        yield ShoppingCartError();
      }
    }
  }
}
