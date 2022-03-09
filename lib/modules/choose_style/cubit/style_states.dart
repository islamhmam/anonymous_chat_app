abstract class StyleStates{}

class StyleInitialState extends StyleStates{}

class GetStylesSuccessState extends StyleStates{}
class GetStylesLoadingState extends StyleStates{}
class GetStylesErrorState extends StyleStates{
  GetStylesErrorState(error);
}

class ChangeStyleIndexState extends StyleStates{}

class GetUserDataSuccessStyleState extends StyleStates{}
class GetUserDataLoadingStyleState extends StyleStates{}
class GetUserDataErrorStyleState extends StyleStates{
  GetUserDataErrorStyleState(error);
}

class UpdateUserDataErrorState extends StyleStates{}
class UpdateUserDataLoadingState extends StyleStates{}

