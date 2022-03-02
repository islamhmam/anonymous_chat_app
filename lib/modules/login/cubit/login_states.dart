abstract class LoginStates{}

class LoginInitialState extends LoginStates{}
class LoginLoadingState extends LoginStates{}

class LoginSuccessState extends LoginStates{
  final String userId;

  LoginSuccessState(this.userId);

}

class LoginErrorState extends LoginStates{
  final String error;

  LoginErrorState(this.error);
}