import '../../../../../export_file.dart';

class PublicRoomState {
  bool isLoading;
  String entryFee;
  String groupName;
  String maxPlayers;

  dynamic selectedGameType;

  PublicRoomState({
    required this.isLoading,
    required this.entryFee,
    required this.groupName,
    required this.maxPlayers,
    required this.selectedGameType,
  });

  factory PublicRoomState.initialState() {
    return PublicRoomState(
      isLoading: false,
      maxPlayers: '',
      groupName: '',
      entryFee: '',
      selectedGameType: TYPE_BLACKJACK,
    );
  }

  PublicRoomState copyWith(
      {isLoading,
      maxLengthTController,
      maxPlayers,
      groupName,
      entreeFee,
      selectedGameType}) {
    return PublicRoomState(
      isLoading: isLoading ?? this.isLoading,
      entryFee: entreeFee ?? this.entryFee,
      groupName: groupName ?? this.groupName,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      selectedGameType: selectedGameType ?? this.selectedGameType,
    );
  }
}
