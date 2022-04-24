abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}
class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{
  final String userId;
  RegisterSuccessState(this.userId);
}

class RegisterErrorState extends RegisterStates{
  final String error;
  RegisterErrorState(this.error);
}

class CreateUserLoadingState extends RegisterStates{}
class CreateUserSuccessState extends RegisterStates{}

class CreateUserErrorState extends RegisterStates{
  final String error;
  CreateUserErrorState(this.error);
}



class ChangePolicyState extends RegisterStates{}
