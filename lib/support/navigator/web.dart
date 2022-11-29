
import 'package:spaid/support/routes.dart';

class NavUtils {
  NavUtils._();
  static int count=0;
  static String get initialUrl {
    if(count==0){
      count++;
      return MyRoutes.splashScreen;
      // return MyRoutes.coachHomeScreen;
    }else {
      return MyRoutes.splashScreen;
      // return MyRoutes.coachHomeScreen;
    }
  }
}
