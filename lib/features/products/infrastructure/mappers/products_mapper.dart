

import 'package:auth_app/config/environment/environment.dart';
import 'package:auth_app/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';

class ProductMapper {


  static jsonToEntity(Map<String,dynamic> json) => Product(
    id: json['id'], 
    title: json['title'], 
    price: double.parse(json['price'].toString()), 
    description: json['description'], 
    slug: json['slug'], 
    stock: json['stock'], 
    sizes: List<String>.from( json['sizes'].map((size)=>size) ) , 
    gender: json['gender'], 
    tags:  List<String>.from( json['tags'].map((tag)=>tag) ) , 
    images: List<String>.from( 
      json['images'].map(
        (image)=>image.startsWith('http') ? image : '${Environment.apiUrl}/files/product/$image'

      ) 
    ) , 
    user: UserMapper.userJsonToEntitie(json['user'])
  );

}