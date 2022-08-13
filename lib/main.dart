import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:dog_share/bottom_bar.dart';
import 'package:dog_share/cart/cart.dart';
import 'package:dog_share/database/user_local_data.dart';
import 'package:dog_share/provider/bottom_navigation_bar_provider.dart';
import 'package:dog_share/provider/dark_theme_provider.dart';
import 'package:dog_share/screens/landing_page.dart';
import 'package:dog_share/screens/orders/order.dart';
import 'package:dog_share/screens/servicesScreen.dart';
import 'package:dog_share/inner_screens/service_details.dart';
import 'package:dog_share/main_screen.dart';
import 'package:dog_share/provider/cart_provider.dart';
import 'package:dog_share/provider/favs_provider.dart';
import 'package:dog_share/provider/orders_provider.dart';
import 'package:dog_share/provider/products.dart';
import 'package:dog_share/screens/auth/login.dart';
import 'package:dog_share/screens/auth/sign_up.dart';
import 'package:dog_share/screens/adminScreens/upload_product_form.dart';
import 'package:dog_share/user_state.dart';
import 'package:dog_share/wishlist/wishlist.dart';
import 'consts/theme_data.dart';
import 'screens/auth/forget_password.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  "high_importance_channel",
  "High Importance Notifications",
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await UserLocalData.init();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  void getCurrentAppTheme() async {
    print('called ,mmmmm');
    themeChangeProvider.darkTheme =
        await themeChangeProvider.darkThemePreferences.getTheme();
  }

  @override
  void initState() {
    getCurrentAppTheme();
    super.initState();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    bool isDarkTheme = false;
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: const CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: const Center(
                  child: Text('Error occured'),
                ),
              ),
            );
          }
          return MultiProvider(
            // ignore: always_specify_types
            providers: [
              ChangeNotifierProvider<BottomNavigationBarProvider>.value(
                value: BottomNavigationBarProvider(),
              ),
              ChangeNotifierProvider<FavouriteProvider>.value(value: FavouriteProvider()),
              ChangeNotifierProvider<FavsProvider>.value(value: FavsProvider()),
              ChangeNotifierProvider<OrdersProvider>.value(
                  value: OrdersProvider()),
              ChangeNotifierProvider<PetsProvider>.value(value: PetsProvider()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Dog Share',
              theme: ThemeData(
                scaffoldBackgroundColor: const Color(0xFF61c1bb),
                primaryColor: Colors.white,
                // accentColor: Colors.black,
                brightness: Brightness.light,
                dividerTheme: const DividerThemeData(
                    color: Colors.black, thickness: 0.5),
                textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white))
                    .apply(bodyColor: Colors.white, displayColor: Colors.white),
                // colorScheme: const ColorScheme(),
              ),
              home: UserState(),
              routes: {
                // '/': (ctx) => LandingPage(),
                // WebhookPaymentScreen.routeName: (ctx) =>
                //     WebhookPaymentScreen(),
                MyBookingsScreen.routeName: (ctx) => MyBookingsScreen(),
                ServicesScreen.routeName: (ctx) => const ServicesScreen(),
                LikedScreen.routeName: (ctx) => LikedScreen(),
                MainScreens.routeName: (ctx) => MainScreens(),
                ServiceDetailsScreen.routeName: (ctx) => ServiceDetailsScreen(),
                LoginScreen.routeName: (ctx) => const LoginScreen(),
                SignupScreen.routeName: (ctx) => const SignupScreen(),
                BottomBarScreen.routeName: (ctx) => BottomBarScreen(),
                UploadProductForm.routeName: (ctx) => UploadProductForm(),
                ForgetPassword.routeName: (ctx) => ForgetPassword(),
                LandingScreen.routeName: (ctx) => const LandingScreen(),
                OrderScreen.routeName: (ctx) => OrderScreen(),
              },
            ),
            //   },
            // ),
          );
        });
  }
}
