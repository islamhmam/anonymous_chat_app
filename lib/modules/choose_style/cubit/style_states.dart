abstract class StyleStates{}

class StyleInitialState extends StyleStates{}

class GetStylesSuccessState extends StyleStates{}
class GetStylesLoadingState extends StyleStates{}
class GetStylesErrorState extends StyleStates{
  GetStylesErrorState(error);
}

class ChangeStyleIndexState extends StyleStates{}

class GetUserDataSuccessState extends StyleStates{}
class GetUserDataLoadingState extends StyleStates{}
class GetUserDataErrorState extends StyleStates{
  GetUserDataErrorState(error);
}

class UpdateUserDataErrorState extends StyleStates{}
class UpdateUserDataLoadingState extends StyleStates{}

