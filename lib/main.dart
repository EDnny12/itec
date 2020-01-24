import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itec/providers/controller.dart';
import 'main_screen.dart';
import 'providers/dynamic_theme.dart';
import 'package:provider/provider.dart';
import 'providers/usuarios.dart';
import 'providers/principales.dart';
import 'providers/network.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  final Map<int, Color> color = {
    50: Color.fromRGBO(27, 57, 106, 1),
    100: Color.fromRGBO(27, 57, 106, 1),
    200: Color.fromRGBO(27, 57, 106, 1),
    300: Color.fromRGBO(27, 57, 106, 1),
    400: Color.fromRGBO(27, 57, 106, 1),
    500: Color.fromRGBO(27, 57, 106, 1),
    600: Color.fromRGBO(27, 57, 106, 1),
    700: Color.fromRGBO(27, 57, 106, 1),
    800: Color.fromRGBO(27, 57, 106, 1),
    900: Color.fromRGBO(27, 57, 106, 1),
  };

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Usuarios()),
        ChangeNotifierProvider(create: (context) => Principal()),
        ChangeNotifierProvider(
          create: (context) => Network(),
        ),
        ChangeNotifierProvider(
          create: (context) => Controlador(),
        )
      ],
      child: DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => ThemeData(
                primarySwatch: MaterialColor(0xFF1B396A, color),
                fontFamily: "Montserrat",
                brightness: brightness,


              ),
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              title: 'INFORMATEC',
              theme: theme,
              darkTheme: ThemeData(
                primarySwatch: MaterialColor(0xFF1B396A, color),
                fontFamily: "Montserrat",
                brightness: Brightness.dark,

              ),
              home: inicio(),
            );
          }),
    );
  }
}
