import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';
import 'package:auth_app/features/products/domain/repositories/products_repository.dart';
import 'package:auth_app/features/products/presentation/providers/products_repository_provider.dart';


final productsProvider = StateNotifierProvider<ProductsNotifier,ProductsState>((ref) {

  final ProductsRepository productsRepository = ref.watch(productRepositoryProvider);

  return ProductsNotifier( productsRepository: productsRepository  );
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  
  final ProductsRepository productsRepository;
  
  ProductsNotifier({
    required this.productsRepository
  })
    : super( ProductsState() ){
      loadNextPage();
    }

    Future<bool> createOrUpdateProduct (Map<String,dynamic> productLike) async {
      try {
        final product = await productsRepository.createUpdateProduct(productLike);
        final isProductInList = state.products.any((element) => element.id == product.id);

        if (!isProductInList) {
          state = state.copyWith(
            products: [...state.products,product]
          );
          return true;
        }

        state = state.copyWith(
          products: state.products.map((element) {
            if (element.id == product.id) {
              return product;
            }
            return element;
          }).toList()
        );
        return true;
      } catch (e) {
        return false;
      }
    }

  Future loadNextPage() async {

    if (state.isLastPage || state.isLoading) return;

    
    state = state.copyWith(
      isLoading: true,
    );

    final products = await productsRepository.getProductsByPage(limit: state.limit, offset: state.offset);

    if(products.isEmpty){
      state = state.copyWith(
        isLastPage: true,
        isLoading: false
      );
      return;
    }

    state = state.copyWith(
      isLastPage: false,
      isLoading: false,
      offset: state.offset + 10,
      products: [...state.products,...products]
    );


  }

  
}


class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith(
    {bool? isLastPage, 
    int? limit, 
    int? offset,
    bool? isLoading, 
    List<Product>? products}
  ) => ProductsState(
    isLastPage: isLastPage ?? this.isLastPage,
    limit: limit ?? this.limit,
    offset: offset ?? this.offset,
    isLoading: isLoading ?? this.isLoading,
    products: products ?? this.products,
  );
}
