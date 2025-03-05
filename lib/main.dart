import 'package:delivery_app/providers/review_provider.dart';
import 'package:delivery_app/providers/shopping_cart_provider.dart';
import 'package:delivery_app/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:delivery_app/screens/authentication_screen.dart';
import 'package:delivery_app/screens/menu_screen.dart';
import 'package:delivery_app/providers/order_provider.dart';
import 'package:delivery_app/providers/dish_provider.dart';
import 'package:delivery_app/providers/restaurant_provider.dart';
import 'package:delivery_app/screens/about_us_screen.dart';
import 'package:delivery_app/screens/ordered_items_screen.dart';
import 'package:delivery_app/screens/welcome_screen.dart';
import 'package:delivery_app/screens/cart_screen.dart';
import 'package:delivery_app/services/firestore_service.dart';
import 'package:delivery_app/data/data.dart';

late List<CameraDescription> cameras;
late CameraDescription? firstCamera;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    cameras = await availableCameras();
    firstCamera = cameras.isNotEmpty ? cameras.first : null;
  } catch (e) {
    print("Error accessing camera: $e");
    firstCamera = null;
  }

  FirestoreService firestoreService = FirestoreService();

  await firestoreService.addRestaurant(restaurant);
  await firestoreService.addDishes(dishes, restaurant.id);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => DishProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ReviewProvider()),
        ChangeNotifierProvider(create: (_) => ShoppingCartProvider()),
        ChangeNotifierProvider(create: (_) => AuthenticationService()),
      ],
      child: MaterialApp(
        title: 'Restaurant Delivery App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/authentication': (context) => const AuthenticationScreen(),
          '/': (context) => const WelcomeScreen(),
          '/menu': (context) => const MenuScreen(),
          '/cart': (context) => const CartScreen(),
          '/about_us': (context) => const AboutUsScreen(),
          '/ordered_items': (context) => const OrderedItemsScreen(),
        },
      ),
    );
  }
}
