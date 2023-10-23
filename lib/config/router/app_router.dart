import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:auth_app/config/router/app_router_notifier.dart';
import 'package:auth_app/features/auth/auth.dart';
import 'package:auth_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:auth_app/features/products/presentation/screens/product_screen.dart';
import 'package:auth_app/features/products/products.dart';

final goRouterProvider = Provider((ref) {

  final goRouterNotifier = ref.read(goRouterNotifierProvider);



  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      //Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const ProductsScreen(),
      ),
      ///* Product Routes
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),
      ),
      GoRoute(
        path: '/product/:id',
        builder: (context, state) => ProductScreen(
          productId: state.params['id'] ?? 'no-id',
        ),
      ),
    ],

    /// Bloquear si no se está autenticado de alguna manera
    
    redirect: (context, state) {

      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking) return null;

      if (authStatus == AuthStatus.notAuthenticated ) {
        if (isGoingTo=='/login' || isGoingTo=='/register') {
          return null;
        }
        return '/login';
      }
      
      if (authStatus == AuthStatus.authenticated ) {
        if (isGoingTo=='/login' || isGoingTo=='/register' || isGoingTo == '/splash' ) {
          return '/';
        }
        return null;
      }

      return null;
    },
    
  );
});

