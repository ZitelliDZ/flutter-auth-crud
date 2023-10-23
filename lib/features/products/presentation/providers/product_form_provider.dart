import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:auth_app/config/environment/environment.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';
import 'package:auth_app/features/products/presentation/providers/products_provider.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/price.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/slug.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/stock.dart';
import 'package:auth_app/features/shared/infrastructure/inputs/title.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductStateform, Product>((ref, product) {

  final createUpdateCallback =
      ref.watch(productsProvider.notifier).createOrUpdateProduct;

  return ProductFormNotifier(
      onSubmitCallback: createUpdateCallback, product: product);
});

class ProductFormNotifier extends StateNotifier<ProductStateform> {
  final Future<bool> Function(Map<String, dynamic> productLike)?
      onSubmitCallback;

  ProductFormNotifier({this.onSubmitCallback, required Product product})
      : super(ProductStateform(
          id: product.id,
          title: Title.dirty(product.title),
          slug: Slug.dirty(product.slug),
          price: Price.dirty(product.price),
          inStock: Stock.dirty(product.stock),
          sizes: product.sizes,
          gener: product.gender,
          description: product.description,
          tags: product.tags.join(','),
          images: product.images,
        ));

  onTitleChanged(String value) {
    final newTitle = Title.dirty(value);
    state = state.copyWith(
        title: newTitle,
        isFormValid: Formz.validate([
          Title.dirty(value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  onSlugChanged(String value) {
    final newslug = Slug.dirty(value);
    state = state.copyWith(
        slug: newslug,
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(value),
          Price.dirty(state.price.value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  updateProductImage(String path) {
    state = state.copyWith(
      images:  [...state.images,path]   
    );
  }

  onPriceChanged(double value) {
    final newPrice = Price.dirty(value);
    state = state.copyWith(
        price: newPrice,
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(value),
          Stock.dirty(state.inStock.value),
        ]));
  }

  onStockChanged(int value) {
    final newStock = Stock.dirty(value);
    state = state.copyWith(
        inStock: newStock,
        isFormValid: Formz.validate([
          Title.dirty(state.title.value),
          Slug.dirty(state.slug.value),
          Price.dirty(state.price.value),
          Stock.dirty(value),
        ]));
  }

  onSizeChanged(List<String> sizes) {
    state = state.copyWith(sizes: sizes);
  }

  onGenderChanged(String gender) {
    state = state.copyWith(gener: gender);
  }

  onDescriptionChanged(String description) {
    state = state.copyWith(description: description);
  }

  onTagsChanged(String tags) {
    state = state.copyWith(tags: tags);
  }

  Future<bool> onFormSubmit() async {
    _touchEveryField();

    if (!state.isFormValid) return false;

    if (onSubmitCallback == null) return false;

    final productLike = {
      'id': state.id,
      'title': state.title.value,
      'price': state.price.value,
      'stock': state.inStock.value,
      'slug': state.slug.value,
      'gender': state.gener,
      'sizes': state.sizes,
      'images': state.images
          .map((image) =>
              image.replaceAll('${Environment.apiUrl}/files/product/', ''))
          .toList(),
      'description': state.description,
      'tags': state.tags.trim().split(','),
    };

    try {
      final product = await onSubmitCallback!(productLike);
    return true;
    } catch (e) {

    return false;
    }
  }

  _touchEveryField() {
    state = state.copyWith(
        isFormValid: Formz.validate([
      Title.dirty(state.title.value),
      Slug.dirty(state.slug.value),
      Price.dirty(state.price.value),
      Stock.dirty(state.inStock.value)
    ]));
  }
}

class ProductStateform {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final List<String> sizes;
  final String gener;
  final Stock inStock;
  final String description;
  final String tags;
  final List<String> images;

  ProductStateform(
      {this.isFormValid = false,
      this.id,
      this.title = const Title.dirty(''),
      this.slug = const Slug.dirty(''),
      this.price = const Price.dirty(0),
      this.sizes = const [],
      this.gener = 'men',
      this.inStock = const Stock.dirty(0),
      this.description = '',
      this.tags = '',
      this.images = const []});

  ProductStateform copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    List<String>? sizes,
    String? gener,
    Stock? inStock,
    String? description,
    String? tags,
    List<String>? images,
  }) =>
      ProductStateform(
        isFormValid: isFormValid ?? this.isFormValid,
        id: id ?? this.id,
        title: title ?? this.title,
        slug: slug ?? this.slug,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        gener: gener ?? this.gener,
        inStock: inStock ?? this.inStock,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        images: images ?? this.images,
      );
}
