import 'package:employee_management/src/bloc/employee_bloc.dart';
import 'package:employee_management/src/data/storage_repository.dart';
import 'package:employee_management/src/screens/employee_list_screen.dart';
import 'package:employee_management/src/config/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage repository for persistent data
  final storageRepository = StorageRepository();
  await storageRepository.init();

  runApp(MyApp(storageRepository: storageRepository));
}

class MyApp extends StatelessWidget {
  /// Repository for handling storage operations
  final StorageRepository storageRepository;

  /// Root widget of the application.
  const MyApp({
    super.key,
    required this.storageRepository,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Initialize and provide EmployeeBloc globally
      create: (context) => EmployeeBloc(storageRepository)..add(LoadEmployees()),
      child: ScreenUtilInit(
        // Set design size for responsive scaling
        designSize: const Size(428, 886),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Employee Management',
          theme: ThemeData(
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: AppColors.backgroundColor,
            useMaterial3: false,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              color: AppColors.primaryColor,
              centerTitle: false,
              // Configure system overlay style for status bar
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.topSystemBarColor,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
            ),
          ),
          home: const EmployeeListScreen(),
        ),
      ),
    );
  }
}
