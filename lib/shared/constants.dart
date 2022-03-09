import '../models/user_model.dart';
import '../modules/login/login_screen.dart';
import 'components/components.dart';
import 'network/local/cash_helper.dart';

String token='';
String uid='';
UserModel? globalUserModel;

void signOut(context)
{
  CashHelper.removeData(
    key: 'uid',
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




