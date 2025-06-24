import 'package:app/export_file.dart';

abstract class InvitationEvents {}

class AcceptInvitationEvent extends InvitationEvents {
  final Map<String, dynamic> invite;
  BuildContext context;

  AcceptInvitationEvent(this.invite, this.context);
}

class DeclineInvitationEvent extends InvitationEvents {
  final Map<String, dynamic> invite;

  DeclineInvitationEvent(this.invite);
}

class LoadInvitationsEvent extends InvitationEvents {
  dynamic isAcceptedInvites;

  LoadInvitationsEvent({this.isAcceptedInvites = false});
}
