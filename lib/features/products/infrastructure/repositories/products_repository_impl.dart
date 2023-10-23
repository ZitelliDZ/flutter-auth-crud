


import 'package:auth_app/features/products/domain/datasources/products_datasource.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';
import 'package:auth_app/features/products/domain/repositories/products_repository.dart';

class ProductsRepositoryImpl extends ProductsRepository {


  final ProductsDatasource productsDatasource;

  ProductsRepositoryImpl({required this.productsDatasource});

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) async {
    
    final product = await productsDatasource.createUpdateProduct(productLike);
    return product;
  }

  @override
  Future<Product> getProductById(String id)async {
    
    final product = await productsDatasource.getProductById(id);
    return product;
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) async{
    
    final products = await productsDatasource.getProductsByPage(limit: limit,offset: offset);
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term)async {
    
    final products = await productsDatasource.searchProductByTerm(term);
    return products;
  }



}