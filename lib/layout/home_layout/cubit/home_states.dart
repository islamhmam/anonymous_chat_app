abstract class HomeStates {}

class HomeInitialState extends HomeStates{}


class GetAllUsersSuccessState extends HomeStates{}
class GetAllUsersLoadingState extends HomeStates{}
class GetAllUsersErrorState extends HomeStates {
  GetAllUsersErrorState(error);
}

class GetChatUsersSuccessState extends HomeStates{}
class GetChatUsersLoadingState extends HomeStates{}
class GetChatUsersErrorState extends HomeStates {
  GetChatUsersErrorState(error);
}