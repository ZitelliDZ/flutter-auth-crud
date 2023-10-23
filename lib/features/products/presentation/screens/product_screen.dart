import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/features/products/domain/entities/product.dart';
import 'package:auth_app/features/products/presentation/providers/product_form_provider.dart';
import 'package:auth_app/features/products/presentation/providers/product_provider.dart';
import 'package:auth_app/features/shared/infrastructure/services/camera_gallery_service_imple.dart';
import 'package:auth_app/features/shared/widgets/custom_product_field.dart';
import 'package:auth_app/features/shared/widgets/full_screen_loader.dart';

class ProductScreen extends ConsumerWidget {
  final String productId;
  const ProductScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productState = ref.watch(productProvider(productId));

    void showSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        
        appBar: AppBar(
          title: 
          (productState.product == null || productState.product?.id == 'new') ? const Text('Nuevo Producto',style: TextStyle(fontSize: 20),) : const Text('Editar Producto',style: TextStyle(fontSize: 20),) ,
          actions: [
            Container(
                  padding: const EdgeInsets.only(right: 0),
              child: IconButton(
                  onPressed: () async{
                    final photoPath = await CameraGalleryServiceImpl().selectPhoto();
                    if (photoPath == null) return;
                    ref
                    .read(productFormProvider(productState.product!).notifier)
                    .updateProductImage(photoPath);
                    },
                  icon: const Icon(Icons.photo_library_outlined)),
            ),
            Container(
                  padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                  onPressed: () async{
                    final photoPath = await CameraGalleryServiceImpl().takePhoto();
                    if (photoPath == null) return;
                    ref
                  .read(productFormProvider(productState.product!).notifier)
                  .updateProductImage(photoPath);
                    },
                  icon: const Icon(Icons.camera_alt_outlined)),
            )
          ],
        ),
        body: productState.isLoading
            ? const FullScreenLoader()
            : _ProductView(product: productState.product!),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (productState.isLoading) return;
    
              ref
                  .read(productFormProvider(productState.product!).notifier)
                  .onFormSubmit()
                  .then((value) {
                    if (!value) return;
                    showSnackBar(context,'Producto guardado con éxito!');
                  });
            },
            child: const Icon(Icons.save_as_outlined)),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final Product product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));
    final textStyles = Theme.of(context).textTheme;

    return ListView(
      children: [
        SizedBox(
          height: 250,
          width: 600,
          child: _ImageGallery(images: productForm.images),
        ),
        const SizedBox(height: 10),
        Center(
            child: Text(productForm.title.value,
                textAlign: TextAlign.center, style: textStyles.titleSmall)),
        const SizedBox(height: 10),
        _ProductInformation(product: product),
      ],
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final Product product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productForm = ref.watch(productFormProvider(product));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Generales'),
          const SizedBox(height: 15),
          CustomProductField(
            isTopField: true,
            label: 'Nombre',
            initialValue: productForm.title.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onTitleChanged(value),
            errorMessage: productForm.title.errorMessage,
          ),
          CustomProductField(
            isTopField: false,
            label: 'Slug',
            initialValue: productForm.slug.value,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onSlugChanged(value),
            errorMessage: productForm.slug.errorMessage,
          ),
          CustomProductField(
            isBottomField: true,
            label: 'Precio',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.price.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onPriceChanged(double.tryParse(value) ?? -1),
            errorMessage: productForm.price.errorMessage,
          ),
          const SizedBox(height: 15),
          const Text('Extras'),
          _SizeSelector(
            selectedSizes: productForm.sizes,
            onSizesChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onSizeChanged(value),
          ),
          const SizedBox(height: 5),
          _GenderSelector(
              selectedGender: productForm.gener,
              onGenderChanged: (value) => ref
                  .read(productFormProvider(product).notifier)
                  .onGenderChanged(value)),
          const SizedBox(height: 15),
          CustomProductField(
            maxLines: 1,
            isTopField: true,
            label: 'Existencias',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            initialValue: productForm.inStock.value.toString(),
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onStockChanged(int.tryParse(value) ?? -1),
            errorMessage: productForm.inStock.errorMessage,
          ),
          CustomProductField(
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.description,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onDescriptionChanged(value),
          ),
          CustomProductField(
            isBottomField: true,
            maxLines: 2,
            label: 'Tags (Separados por coma)',
            keyboardType: TextInputType.multiline,
            initialValue: productForm.tags,
            onChanged: (value) => ref
                .read(productFormProvider(product).notifier)
                .onTagsChanged(value),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SizeSelector extends StatelessWidget {
  final List<String> selectedSizes;
  final List<String> sizes = const ['XS', 'S', 'M', 'L', 'XL', 'XXL', 'XXXL'];

  final Function(List<String> selectedSizes) onSizesChanged;

  const _SizeSelector(
      {required this.selectedSizes, required this.onSizesChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      emptySelectionAllowed: true,
      showSelectedIcon: false,
      segments: sizes.map((size) {
        return ButtonSegment(
            value: size,
            label: Text(size, style: const TextStyle(fontSize: 10)));
      }).toList(),
      selected: Set.from(selectedSizes),
      onSelectionChanged: (newSelection) {
        onSizesChanged(List.from(newSelection));
        FocusScope.of(context).unfocus();
      },
      multiSelectionEnabled: true,
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final String selectedGender;
  final List<String> genders = const ['men', 'women', 'kid'];
  final List<IconData> genderIcons = const [
    Icons.man,
    Icons.woman,
    Icons.boy,
  ];

  final void Function(String selectedGender) onGenderChanged;

  const _GenderSelector(
      {required this.selectedGender, required this.onGenderChanged});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SegmentedButton(
        emptySelectionAllowed: false,
        multiSelectionEnabled: false,
        showSelectedIcon: false,
        style: const ButtonStyle(visualDensity: VisualDensity.compact),
        segments: genders.map((size) {
          return ButtonSegment(
              icon: Icon(genderIcons[genders.indexOf(size)]),
              value: size,
              label: Text(size, style: const TextStyle(fontSize: 12)));
        }).toList(),
        selected: {selectedGender},
        onSelectionChanged: (newSelection) {
          onGenderChanged(newSelection.first);
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}

class _ImageGallery extends StatelessWidget {
  final List<String> images;
  const _ImageGallery({required this.images});

  @override
  Widget build(BuildContext context) {

    if(images.isEmpty) {
      return ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: Image.asset('assets/images/no-image.jpg',
                      fit: BoxFit.cover));
    }



    return PageView(
      scrollDirection: Axis.horizontal,
      controller: PageController(viewportFraction: 0.7),
      children:
      images.map((image) {

              late ImageProvider  imageProvider;

              if (image.startsWith('http')) {
                imageProvider = NetworkImage( image);
              } else {
                
                imageProvider = FileImage( File(image));
              }


              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  child: FadeInImage(
                    fit: BoxFit.cover,
                    image: imageProvider,
                    placeholder: const AssetImage('assets/loaders/bottle-loader.gif') ,
                    )
                  ,
                ),
              );
            }).toList(),
    );
  }
}
