import 'package:intl/intl.dart';

import '../../../export_file.dart';

Future<String> generateUniqueNickname() async {
  final adjectives = [
    'Cool',
    'Fast',
    'Lucky',
    'Sneaky',
    'Funky',
    'Silent',
    'Wild'
  ];
  final animals = [
    'Tiger',
    'Panda',
    'Shark',
    'Eagle',
    'Wolf',
    'Otter',
    'Falcon'
  ];
  final rand = Random();

  String nickname;
  bool isUnique = false;

  while (!isUnique) {
    nickname = '${adjectives[rand.nextInt(adjectives.length)]}'
        '${animals[rand.nextInt(animals.length)]}'
        '${rand.nextInt(900) + 100}'; // e.g. FunkyOtter453

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('nickname', isEqualTo: nickname)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      isUnique = true;
      return nickname;
    }
  }

  // Should never reach here, but fallback
  return 'Player${DateTime.now().millisecondsSinceEpoch}';
}

String formatTimestamp(String isoTime) {
  try {
    final dateTime = DateTime.parse(isoTime);
    final formatter = DateFormat('hh:mm a dd/MM/yyyy');
    return formatter.format(dateTime);
  } catch (e) {
    return 'Invalid date';
  }
}

String generateRandomCard() {
  final ranks = [
    'A\n',
    '2\n',
    '3\n',
    '4\n',
    '5\n',
    '6\n',
    '7\n',
    '8\n',
    '9\n',
    '10\n',
    'J\n',
    'Q\n',
    'K\n'
  ];
  final suits = ['♠', '♥', '♦', '♣'];
  final rank = (ranks..shuffle()).first;
  final suit = (suits..shuffle()).first;
  return '$rank$suit';
}

int calculateHandValue(List<dynamic> cards) {
  int total = 0;
  int aces = 0;
  for (var card in cards) {
    String rank = card.substring(0, card.length - 1).replaceAll('\n', '');
    if (rank == 'A') {
      aces++;
      total += 11;
    } else if (['K', 'Q', 'J'].contains(rank)) {
      total += 10;
    } else {
      total += int.tryParse(rank) ?? 0;
    }
  }

  // Downgrade Aces from 11 to 1 if needed
  while (total > 21 && aces > 0) {
    total -= 10;
    aces--;
  }
  return total;
}
