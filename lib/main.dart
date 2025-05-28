import 'package:college_connectd/auth/controller/auth_controller.dart';
import 'package:college_connectd/core/storage/secure_storage.dart';
import 'package:college_connectd/firebase_options.dart';
import 'package:college_connectd/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';


// enum AuthStatus { loading, authenticated, unauthenticated }

// class AuthState {
//   final AuthStatus status;
//   final String? error;

//   const AuthState({
//     required this.status,
//     this.error,
//   });

//   AuthState copyWith({
//     AuthStatus? status,
//     String? error,
//   }) {
//     return AuthState(
//       status: status ?? this.status,
//       error: error ?? this.error,
//     );
//   }
// }



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    try {
      final status = await SecureStorageService().getLoginStatus();
      if(status){
        await getUserData();
      }
      ref.read(authStateProvider.notifier).update((state) {
        return status;
      });
      
    } catch (error) {
      ref.read(authStateProvider.notifier).update((state) {
        return false;
      });
    }
  }

  Future<String> getUid() async {
    try{
        final uid = await SecureStorageService().getuid();
        return uid;
    }catch(e){
      return 'na';
    }
  }

  
    Future<void> getUserData() async{
    final  uid = await getUid();
    if(uid=='na'){
      //error message
      return;
    }
    final userModel = await ref.watch(authControllerProvider.notifier).userData(uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(authStateProvider);

    if (isLoggedIn == null) {
      return MaterialApp(
        title: 'College Connect',
        home: Scaffold(
          body: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      );
    }

    return MaterialApp.router(
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 36, fontWeight: FontWeight.w600),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          ),
      ),
      title: 'College Connect',
      routerDelegate: RoutemasterDelegate(
        routesBuilder: (context) {
          final routes = isLoggedIn ? loggedInRoutes : loggedOutRoutes;
          return routes;
        },
      ),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}