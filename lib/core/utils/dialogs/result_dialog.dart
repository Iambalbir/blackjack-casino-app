import 'package:app/app/modules/games/bloc/gameEvents.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../export_file.dart';

class ResultDialog extends StatefulWidget {
  dynamic width;
  dynamic height;
  dynamic result;
  dynamic playerReturn;
  dynamic dataBloc;
  dynamic adState;
  dynamic onAddComplete;

  ResultDialog(
      {Key? key,
      this.width,
      this.height,
      this.result,
      required this.onAddComplete,
      this.playerReturn,
      this.dataBloc,
      this.adState})
      : super(key: key);

  @override
  _ResultDialogState createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  RewardedAd? rewardedAd;
  String adButtonText = 'Watch Ad';
  bool showAd = false;
  bool rewardEarned = false;

  void adClosed() {
    if (rewardEarned) {
      GameEvents _event = AdWatchedEvent();
      widget.dataBloc.add(_event);
    } else {
      // do nothing
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.adState.initialization.then((status) {
      RewardedAd.load(
        adUnitId: widget.adState.rewardAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('Rewarded ad loaded.');
            setState(() {
              rewardedAd = ad;
            });

            if (showAd) {
              rewardedAd!.show(
                onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                  print('User earned reward: ${reward.amount} ${reward.type}');
                  setState(() {
                    rewardEarned = true;
                  });

                  widget.onAddComplete();

                  // TODO: Call your wallet update or event trigger here
                  // updateWallet(reward.amount);
                },
              );

              rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  print('Ad closed.');
                  ad.dispose();
                  adClosed(); // your method
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  print('Ad failed to show: $error');
                  ad.dispose();
                },
              );
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('Rewarded ad failed to load: $error');
          },
        ),
      );
    });
  }

  String displayText() {
    if (widget.result == kDealerBust || widget.result == kPlayerWon) {
      return 'You win';
    } else if (widget.result == kPlayerBust || widget.result == kDealerWon) {
      return 'You lost';
    } else if (widget.result == kTie) {
      return 'Tie';
    } else {
      return 'Surrender';
    }
  }

  Widget displayPlayerReturn() {
    if (widget.playerReturn.isNegative) {
      return Text(
        '${widget.playerReturn}',
        style: textStyleBodySmall(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: widget.width * 0.06,
            color: kRed),
      );
    } else {
      return Text(
        '+${widget.playerReturn}',
        style: textStyleBodySmall(context).copyWith(
            fontWeight: FontWeight.bold,
            fontSize: widget.width * 0.06,
            color: kStayButtonGreen),
      );
    }
  }

  Widget adStatement() {
    if (widget.playerReturn.isNegative) {
      return Text(
        'Recover your bet',
        style: textStyleBodySmall(context).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    } else {
      return Text(
        'Double your profit',
        style: textStyleBodySmall(context).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width * 0.8,
      height: widget.width * 0.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '${displayText()}',
            style: textStyleBodySmall(context).copyWith(
                fontWeight: FontWeight.bold, fontSize: widget.width * 0.06),
          ),
          displayPlayerReturn(),
          adStatement(),
          MaterialButton(
              child: Container(
                width: widget.width * 0.4,
                height: widget.width * 0.13,
                child: Center(
                  child: Text(
                    '$adButtonText',
                    style: textStyleBodySmall(context).copyWith(
                        fontSize: widget.width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    color: kHitButtonYellow,
                    borderRadius: BorderRadius.circular(100)),
              ),
              onPressed: () {
                showAd = true;
                setState(() {
                  adButtonText = "Loading";
                });
                rewardedAd?.show(
                  onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
                    print(
                        'User earned reward: ${reward.amount} ${reward.type}');
                  },
                );
              }),
          MaterialButton(
              child: Container(
                width: widget.width * 0.4,
                height: widget.width * 0.13,
                child: Center(
                  child: Text(
                    'Continue',
                    style: textStyleBodySmall(context).copyWith(
                        fontSize: widget.width * 0.045,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                decoration: BoxDecoration(
                    color: kDoneBlueButton,
                    borderRadius: BorderRadius.circular(100)),
              ),
              onPressed: () {
                GameEvents _event = ContinueEvent();
                widget.dataBloc.add(_event);
              })
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
    );
  }
}
