


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';
import 'package:auth_app/features/products/domain/repositories/products_repository.dart';
import 'package:auth_app/features/products/presentation/providers/products_repository_provider.dart';



final productProvider = StateNotifierProvider.autoDispose.family<ProductNotifier,ProductState,String>((ref,productId) {
  

  final ProductsRepository productsRepository = ref.watch(productRepositoryProvider);
  
  return ProductNotifier(productsRepository: productsRepository, productId: productId);

});


class ProductNotifier extends StateNotifier<ProductState> {
  
  final ProductsRepository productsRepository;

  
  ProductNotifier({
    required this.productsRepository,
    required String productId
  }): super(ProductState( id: productId)){
    loadProduct();
  }

  Product _newEmptyProduct () => Product(
    id: 'new', 
    title: 'Nuevo Producto', 
    price: 0, 
    description: 'Descripción', 
    slug: 'Nuevo-producto', 
    stock: 0, 
    sizes: [], 
    gender: 'men', 
    tags: [], 
    images: [],
    );

  Future<void> loadProduct() async {

    try {

      if (state.id == 'new') {
        state = state.copyWith(
        isLoading: false,
        product: _newEmptyProduct()
        );
        
        return;
      }

      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        isLoading: false,
        product: product
      );

    } catch (e) {
      // 404 product not found
      print(e);
    }

  }
  
}


class ProductState {

  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving
  }) => ProductState(
    id: id ?? this.id,
    product: product ?? this.product,
    isLoading: isLoading ?? this.isLoading,
    isSaving: isSaving ?? this.isSaving,
  );

}