abstract class HomeStates {}

class HomeInitialState extends HomeStates{}


class GetAllUsersSuccessState extends HomeStates{}
class GetAllUsersSuccessOneState extends HomeStates{}
class GetAllUsersLoadingState extends HomeStates{}
class GetAllUsersErrorState extends HomeStates {
  GetAllUsersErrorState(error);
}

class GetChatUsersSuccessState extends HomeStates{}
class GetChatUsersSuccessOneState extends HomeStates{}
class GetChatUsersLoadingState extends HomeStates{}
class GetChatUsersErrorState extends HomeStates {
  GetChatUsersErrorState(error);
}

class ChatUsersRemoveLocalState extends HomeStates{}
class ChatUsersRemoveFirebaseSuccessState extends HomeStates{}
class ChatUsersRemoveFirebaseErrorState extends HomeStates{}
class ChatUsersRemoveFirebaseLoadingState extends HomeStates{}


class GetUserDataSuccessState extends HomeStates{}
class GetUserDataLoadingState extends HomeStates{}
class GetUserDataErrorState extends HomeStates{
  GetUserDataErrorState(error);
}
