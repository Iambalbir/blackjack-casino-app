import 'package:app/export_file.dart';

class RoomState {
  List<Map<String, dynamic>> allUsers;

  List<Map<String, dynamic>> filteredUsers;

  List<Map<String, dynamic>> selectedUsers;
  bool isLoading = true;
  String? searchQuery;
  final bool isCreatingRoom;
  final String roomCode;

  RoomState(
      {required this.allUsers,
      required this.filteredUsers,
      required this.isLoading,
      required this.searchQuery,
      required this.isCreatingRoom,
      required this.roomCode,
      required this.selectedUsers});

  factory RoomState.initialEvent() {
    return RoomState(
        allUsers: [],
        isLoading: true,
        isCreatingRoom: true,
        roomCode: '',
        searchQuery: '',
        filteredUsers: [],
        selectedUsers: []);
  }

  RoomState copyWith(
      {allUser,
      filteredUsers,
      selectedUsers,
      isCreatingRoom,
      roomCode,
      searchQuery,
      isLoading}) {
    return RoomState(
        filteredUsers: filteredUsers ?? this.filteredUsers,
        allUsers: allUser ?? this.allUsers,
        isCreatingRoom: isCreatingRoom ?? this.isCreatingRoom,
        roomCode: roomCode ?? this.roomCode,
        searchQuery: searchQuery ?? this.searchQuery,
        isLoading: isLoading ?? this.isLoading,
        selectedUsers: selectedUsers ?? this.selectedUsers);
  }
}
