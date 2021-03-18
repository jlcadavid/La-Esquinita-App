import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:engage/models/userModel.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:dio_retry/dio_retry.dart';
import 'package:http_parser/http_parser.dart';

import 'package:engage/models/productModel.dart';
import 'package:engage/models/categoryModel.dart';
import 'package:engage/models/commerceModel.dart';
import 'package:engage/models/shoppingCartModel.dart';
import 'package:engage/models/cartItemModel.dart';
import 'package:engage/models/couponModel.dart';

import 'package:engage/app/engageApp.dart' as app;

final apiClient = Dio(
  BaseOptions(
    baseUrl: "https://lalorduy.dentotys.com/api",
    headers: {
      HttpHeaders.acceptHeader: "application/json",
    },
  ),
);

final storageClient = Dio(
  BaseOptions(
    baseUrl: "https://lalorduy.dentotys.com/storage",
    headers: {
      HttpHeaders.acceptHeader: "application/json",
    },
  ),
);

final shoppingCartClient = Dio(
  BaseOptions(
    baseUrl: "https://lalorduy.dentotys.com/car",
    headers: {
      HttpHeaders.acceptHeader: "application/json",
    },
  ),
);

final apiClientInterceptor = RetryInterceptor(
  dio: apiClient,
  options: RetryOptions(
    retries: 3,
    retryInterval: const Duration(milliseconds: 1500),
    retryEvaluator: (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 429)
        return true;
      else
        return error.type != DioErrorType.CANCEL &&
            error.type != DioErrorType.RESPONSE;
    },
  ),
);

final storageClientInterceptor = RetryInterceptor(
  dio: storageClient,
  options: RetryOptions(
    retries: 3,
    retryInterval: const Duration(milliseconds: 1500),
    retryEvaluator: (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 429)
        return true;
      else
        return error.type != DioErrorType.CANCEL &&
            error.type != DioErrorType.RESPONSE;
    },
  ),
);

final shoppingCartClientInterceptor = RetryInterceptor(
  dio: shoppingCartClient,
  options: RetryOptions(
    retries: 3,
    retryInterval: const Duration(milliseconds: 1500),
    retryEvaluator: (error) {
      if (error.type == DioErrorType.RESPONSE &&
          error.response.statusCode == 429)
        return true;
      else
        return error.type != DioErrorType.CANCEL &&
            error.type != DioErrorType.RESPONSE;
    },
  ),
);

class APIClientService with ChangeNotifier {
  UserModel parseUserJsonResponse(String responseData) {
    print(responseData);
    var l = jsonDecode(responseData) as Map<String, dynamic>;
    //print(l);
    return UserModel.fromJson(l);
  }

  CommerceModel parseCommerceJsonResponse(String responseData) {
    print(responseData);
    var l = jsonDecode(responseData) as Map<String, dynamic>;
    //print(l);
    return CommerceModel.fromJson(l);
  }

  ProductModel parseProductJsonResponse(String responseData) {
    print(responseData);
    var l = jsonDecode(responseData) as Map<String, dynamic>;
    //print(l);
    return ProductModel.fromJson(l);
  }

  Future<UserModel> createUser(String document, String firstName,
      String lastName, String phone, String email, String password) async {
    try {
      final response = await apiClient.post(
        '/commerce/postUserCommerce',
        data: jsonEncode(
          <String, dynamic>{
            'document': document,
            'name': firstName,
            'last_name': lastName,
            'email': email,
            'cellphone': phone,
            'password': password,
          },
        ),
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.data);
        return parseUserJsonResponse(jsonEncode(response.data['data']));
      } else
        throw Exception(
            'Couldn\'t get user with credentials:\nPhone: $phone\nPassword:$password');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<UserModel> fetchUser(String phone, String password) async {
    try {
      final response = await apiClient.post(
        '/client/loggin',
        data: jsonEncode(
          <String, dynamic>{
            'cellphone': phone,
            'password': password,
          },
        ),
      );
      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.data);
        return parseUserJsonResponse(jsonEncode(response.data['data']));
      } else
        throw Exception(
            'Couldn\'t get user with credentials:\nPhone: $phone\nPassword:$password');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<CommerceModel> createCommerce(CommerceModel newCommerce) async {
    try {
      final response = await apiClient.post(
        '/commerce/postCommerce',
        data: jsonEncode(
          newCommerce.toJson(),
        ),
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.data);
        return parseCommerceJsonResponse(jsonEncode(response.data['data']));
      } else
        return throw Exception('Couldn\'t create new commerce.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ProductModel> createProduct(ProductModel newProduct) async {
    try {
      FormData formData = new FormData();

      List<File> imgs = newProduct.imageLocation.map((e) {
        //print(e.toString().split('File: ').last.replaceAll("'", ""));
        return File.fromUri(
            Uri(path: e.toString().split('File: ').last.replaceAll("'", "")));
      }).toList();

      newProduct.toJson().forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      formData.files.addAll(
        imgs.map(
          (e) => MapEntry(
            "img_product",
            MultipartFile.fromFileSync(
              e.path,
              filename: e.path.split('/').last,
              contentType: MediaType.parse('image/png'),
            ),
          ),
        ),
      );

      final response = await apiClient.post(
        '/product/createProduct',
        data: formData,
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(response.data);
        return parseProductJsonResponse(
            jsonEncode(response.data.first['original']['data']));
      } else
        return throw Exception('Couldn\'t create new product.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchProducts(
      int categoryID, int commerceID) async {
    try {
      final response = await apiClient.get(
        '/product/getProductsCategoriesList',
        queryParameters: <String, dynamic>{
          'idCommerce': commerceID == null ? 0 : commerceID,
          'idCategory': categoryID == null ? 0 : categoryID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get categories.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.statusCode);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ProductModel> fetchProductInfo(ProductModel product) async {
    try {
      final response = await apiClient.get(
        '/product/ProductInfo',
        queryParameters: <String, dynamic>{
          'id_product': product.productID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
      } else
        return throw Exception('Couldn\'t get categories.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.statusCode);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final response = await apiClient.get(
        '/searchProducts',
        queryParameters: <String, dynamic>{
          'keyWord': keyword,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get categories.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.statusCode);
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ShoppingCartModel> addProductToShoppingCart(
      UserModel buyer, ProductModel product, int quantity) async {
    try {
      final response = await shoppingCartClient.get(
        '/add',
        queryParameters: <String, dynamic>{
          'id': product.productID,
          'name': product.name,
          'price': product.price,
          'quantity': quantity,
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        if (response.data['data'].isEmpty) {
          var temp = <String, dynamic>{
            'id': 0,
            'user_id': app.authService.currentUserData.userID,
            'get_details': [],
          };
          return ShoppingCartModel.fromJson(jsonDecode(jsonEncode(temp)));
        }
        return ShoppingCartModel.fromJson(
            jsonDecode(jsonEncode(response.data['data'])));
      } else
        return throw Exception('Couldn\'t add product.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ShoppingCartModel> deleteProductFromShoppingCart(
      UserModel buyer, CartItemModel item) async {
    try {
      final response = await shoppingCartClient.get(
        '/remove',
        queryParameters: <String, dynamic>{
          'id': item.cartProducts.first.productID,
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        if (response.data['data'].isEmpty) {
          var temp = <String, dynamic>{
            'id': 0,
            'user_id': app.authService.currentUserData.userID,
            'get_details': [],
          };
          return ShoppingCartModel.fromJson(jsonDecode(jsonEncode(temp)));
        }
        return ShoppingCartModel.fromJson(
            jsonDecode(jsonEncode(response.data['data'])));
      } else
        return throw Exception('Couldn\'t get shopping cart items.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ShoppingCartModel> deleteShoppingCart(UserModel buyer) async {
    try {
      final response = await shoppingCartClient.get(
        '/delete',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        if (response.data['data'].isEmpty) {
          var temp = <String, dynamic>{
            'id': 0,
            'user_id': app.authService.currentUserData.userID,
            'get_details': [],
          };
          return ShoppingCartModel.fromJson(jsonDecode(jsonEncode(temp)));
        }
        return ShoppingCartModel.fromJson(
            jsonDecode(jsonEncode(response.data['data'])));
      } else
        return throw Exception('Couldn\'t get shopping cart items.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<ShoppingCartModel> fetchShoppingCart(UserModel buyer) async {
    try {
      final response = await shoppingCartClient.get(
        '/myCar',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        if (response.data['data'].isEmpty) {
          var temp = <String, dynamic>{
            'id': 0,
            'user_id': app.authService.currentUserData.userID,
            'get_details': [],
          };
          return ShoppingCartModel.fromJson(jsonDecode(jsonEncode(temp)));
        }
        return ShoppingCartModel.fromJson(
            jsonDecode(jsonEncode(response.data['data'])));
      } else
        return throw Exception('Couldn\'t get shopping cart items.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<CouponModel>> fetchCoupons(UserModel buyer) async {
    try {
      final response = await apiClient.get(
        '/coupon/myCoupons',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        if (response.data['data'].isEmpty) {
          return <CouponModel>[];
        }
        return List<CouponModel>.from(json
            .decode(jsonEncode(response.data['data'].first['get_coupon']))
            .map((x) => CouponModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get shopping cart items.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> validateCoupon(UserModel buyer, CouponModel coupon) async {
    try {
      final response = await apiClient.get(
        '/coupon/validate',
        queryParameters: <String, dynamic>{
          'name': coupon.name,
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> createOrder(UserModel buyer, ShoppingCartModel order,
      {CouponModel appliedCoupon}) async {
    var data = <String, dynamic>{
      'user_id': buyer.userID,
      'order_details':
          jsonEncode(order.cartItems.map((e) => e.toJson()).toList()),
    };
    if (appliedCoupon != null) {
      data.putIfAbsent('coupon_id', () => appliedCoupon.id);
    }
    try {
      final response = await apiClient.post(
        '/order/save',
        data: data,
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> fetchClientPendingOrders(UserModel buyer) async {
    try {
      final response = await apiClient.get(
        '/order/getPendingOrder',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> fetchClientCompletedOrders(UserModel buyer) async {
    try {
      final response = await apiClient.get(
        '/order/getCompletedOrder',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> fetchClientCancelledOrders(UserModel buyer) async {
    try {
      final response = await apiClient.get(
        '/order/getCancelledOrder',
        queryParameters: <String, dynamic>{
          'user_id': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> fetchCommercePendingOrders(CommerceModel commerce) async {
    try {
      final response = await apiClient.get(
        '/order/getCommercePendingOrder',
        queryParameters: <String, dynamic>{
          'commerce_id': commerce.commerceID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<bool> fetchCommerceCompletedOrders(CommerceModel commerce) async {
    try {
      final response = await apiClient.get(
        '/order/getCommerceCompleteOrder',
        queryParameters: <String, dynamic>{
          'commerce_id': commerce.commerceID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else
        return false;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchOutstandingProducts() async {
    try {
      final response = await apiClient.get(
        '/outstandingProducts',
      );

      print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get products.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchExplore() async {
    try {
      final response = await apiClient.get(
        '/explorer',
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get products.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchPromotions() async {
    try {
      final response = await apiClient.get(
        '/coupon/proms',
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x['get_products'].first)));
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchSuggestions(UserModel buyer) async {
    try {
      final response = await apiClient.get(
        '/userRecommends',
        queryParameters: <String, dynamic>{
          'id_user': buyer.userID,
        },
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data'].first['get_products']))
                .map((x) => ProductModel.fromJson(x)));
      }
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<ProductModel>> fetchCarousel() async {
    try {
      final response = await apiClient.get(
        '/carrusel',
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['data']));
        return List<ProductModel>.from(
            jsonDecode(jsonEncode(response.data['data']))
                .map((x) => ProductModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get categories.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      final response = await apiClient.get(
        '/commerce/getCategories',
      );

      //print("HTTP Response Code: ${response.statusMessage}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        //print(jsonEncode(response.data['res']));
        return List<CategoryModel>.from(
            jsonDecode(jsonEncode(response.data['res']))
                .map((x) => CategoryModel.fromJson(x)));
      } else
        return throw Exception('Couldn\'t get categories.');
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      if (e.response != null) {
        print(e.response.data);
        print(e.response.headers);
        print(e.response.request);
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        print(e.request);
        print(e.message);
      }
    }
    return null;
  }
}
