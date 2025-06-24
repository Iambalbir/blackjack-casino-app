import 'package:app/export_file.dart';

class RoomState {
  List<Map<String, dynamic>> allUsers;

  List<Map<String, dynamic>> filteredUsers;

  List<Map<String, dynamic>> selectedUsers;
  bool isLoading = true;
  String? searchQuery;
  final bool isCreatingRoom;
  final String roomCode;
  dynamic entryFee;
  dynamic groupName;

  RoomState(
      {required this.allUsers,
      required this.filteredUsers,
      required this.isLoading,
      required this.searchQuery,
      required this.isCreatingRoom,
      required this.groupName,
      required this.roomCode,
      required this.entryFee,
      required this.selectedUsers});

  factory RoomState.initialEvent() {
    return RoomState(
        allUsers: [],
        isLoading: true,
        entryFee: '',
        isCreatingRoom: true,
        roomCode: '',
        searchQuery: '',
        groupName: '',
        filteredUsers: [],
        selectedUsers: []);
  }

  RoomState copyWith(
      {allUser,
      filteredUsers,
      selectedUsers,
      entryFee,
      isCreatingRoom,
        groupName,
      roomCode,
      searchQuery,
      isLoading}) {
    return RoomState(
        filteredUsers: filteredUsers ?? this.filteredUsers,
        entryFee: entryFee ?? this.entryFee,
        groupName: groupName ?? this.groupName,
        allUsers: allUser ?? this.allUsers,
        isCreatingRoom: isCreatingRoom ?? this.isCreatingRoom,
        roomCode: roomCode ?? this.roomCode,
        searchQuery: searchQuery ?? this.searchQuery,
        isLoading: isLoading ?? this.isLoading,
        selectedUsers: selectedUsers ?? this.selectedUsers);
  }
}
