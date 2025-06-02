class InvitationState {
  final bool isLoading;
  final List<Map<String, dynamic>> invitations;
  final List<Map<String, dynamic>> selectedUsers;
  final String? roomCode;
  final String status; // e.g., "waiting", "active", "completed"
  final Map<String, dynamic>? navigateToRoom;

  const InvitationState({
    this.isLoading = false,
    this.navigateToRoom,
    this.invitations = const [],
    this.selectedUsers = const [],
    this.roomCode,
    this.status = 'waiting',
  });

  InvitationState copyWith({
    bool? isLoading,
    Map<String, dynamic>? navigateToRoom,
    List<Map<String, dynamic>>? invitations,
    List<Map<String, dynamic>>? selectedUsers,
    String? roomCode,
    String? status,
  }) {
    return InvitationState(
      isLoading: isLoading ?? this.isLoading,
      navigateToRoom: navigateToRoom ?? this.navigateToRoom,
      invitations: invitations ?? this.invitations,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      roomCode: roomCode ?? this.roomCode,
      status: status ?? this.status,
    );
  }
}
