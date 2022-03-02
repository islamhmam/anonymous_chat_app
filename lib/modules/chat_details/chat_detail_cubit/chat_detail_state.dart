abstract class ChatDetailsStates {}

class ChatDetailsInitialState extends ChatDetailsStates{}


class ChatDetailsSendMessageSuccessState extends ChatDetailsStates{}
class ChatDetailsSendMessageErrorState extends ChatDetailsStates{}

class ChatDetailsGetMessagesSuccessState extends ChatDetailsStates{}
class ChatDetailsGetMessagesErrorState extends ChatDetailsStates{}

class ChatDetailsGetUserDataSuccessState extends ChatDetailsStates{}
class ChatDetailsGetUserDataLoadingState extends ChatDetailsStates{}
class ChatDetailsGetUserDataErrorState extends ChatDetailsStates{
  ChatDetailsGetUserDataErrorState(error);
}

class ChatDetailsScrollMessageState extends ChatDetailsStates{}
