import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:auth_app/features/products/presentation/providers/products_provider.dart';
import 'package:auth_app/features/products/presentation/widgets/product_item.dart';
import 'package:auth_app/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu( scaffoldKey: scaffoldKey ),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: const Icon( Icons.search_rounded)
          )
        ],
      ),
      body: const _ProductsView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon( Icons.add ),
        onPressed: () {
          context.push('/product/new');
        },
      ),
    );
  }
}


class _ProductsView extends ConsumerStatefulWidget {
  const _ProductsView();

  @override
  ConsumerState<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends  ConsumerState<_ProductsView> {

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    ref.read(productsProvider.notifier).loadNextPage();

    scrollController.addListener(() {

      if (ref.read(productsProvider).isLoading) return;

      if ((scrollController.position.pixels + 400) >=
          scrollController.position.maxScrollExtent) {
          ref.read(productsProvider.notifier).loadNextPage();
      }
         
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final productsState = ref.watch( productsProvider );

    return Padding(
      padding: const EdgeInsets.only(left: 20,right: 20),
      child: MasonryGridView.count(
        controller: scrollController,
        padding: const EdgeInsets.only(bottom: 100),
        //physics: const BouncingScrollPhysics(),
        crossAxisCount: 2,
        itemBuilder: (context, index) {
          final product = productsState.products[index];
          return GestureDetector(onTap: () {
            context.push('/product/${product.id}');
          }, child: ProductItem(product: product));
        },
        mainAxisSpacing: 20,
        crossAxisSpacing: 35,
        itemCount: productsState.products.length,
      ),
    );
  }
}