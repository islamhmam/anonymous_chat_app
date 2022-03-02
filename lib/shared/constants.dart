import '../models/user_model.dart';
import '../modules/login/login_screen.dart';
import 'components/components.dart';
import 'network/local/cash_helper.dart';

String token='';
String uid='';
UserModel? userModel;

void signOut(context)
{
  CashHelper.removeData(
    key: 'token',
  ).then((value)
  {
    if (value)
    {
      navigateAndFinish(
        context: context,
        widget: LoginScreen(),
      );
    }
  });
}




