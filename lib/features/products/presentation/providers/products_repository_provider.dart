


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:auth_app/features/products/domain/repositories/products_repository.dart';
import 'package:auth_app/features/products/infrastructure/datasources/products_datasource_impl.dart';
import 'package:auth_app/features/products/infrastructure/repositories/products_repository_impl.dart';

final productRepositoryProvider = Provider<ProductsRepository>((ref) {

  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final productRepositoryImpl = ProductsRepositoryImpl(
    productsDatasource: ProductsDatasourceImple(
      accessToken: accessToken
    )
  );
  
  return productRepositoryImpl;
});