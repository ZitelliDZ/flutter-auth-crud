

import 'package:flutter/material.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';

class ProductItem extends StatelessWidget {
  
  final Product product;
  const ProductItem({required this.product, super.key});

  @override
  Widget build(BuildContext context) {


    return Column(
      children: [
        _ImageViewer(images: product.images),
        Text(product.title,textAlign: TextAlign.left,),
        SizedBox(height: 20,),
      ],
    );
  }
}



class _ImageViewer extends StatelessWidget {

  final List<String> images;
  const _ImageViewer({ required this.images});

  @override
  Widget build(BuildContext context) {
    
    if (images.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset('assets/images/no-image.jpg',
          fit: BoxFit.cover,
          height: 250,  
        ),
      );
    }

    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: FadeInImage(
          fit: BoxFit.cover,
          height: 250,
          fadeOutDuration: const Duration(milliseconds: 300),
          fadeInDuration: const Duration(milliseconds: 300),
          image: NetworkImage(images.first),
          placeholder: AssetImage('assets/loaders/bottle-loader.gif'),
        ),
      );

  }
}