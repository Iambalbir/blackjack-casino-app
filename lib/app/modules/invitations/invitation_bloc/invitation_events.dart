abstract class InvitationEvents {}

class AcceptInvitationEvent extends InvitationEvents {
  final Map<String, dynamic> invite;

  AcceptInvitationEvent(this.invite);
}

class DeclineInvitationEvent extends InvitationEvents {
  final Map<String, dynamic> invite;

  DeclineInvitationEvent(this.invite);
}

class LoadInvitationsEvent extends InvitationEvents {}
