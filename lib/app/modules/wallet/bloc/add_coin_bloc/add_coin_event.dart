abstract class AddCoinEvents {}

class MakePaymentEvent extends AddCoinEvents {
  dynamic totalCosting;

  MakePaymentEvent(this.totalCosting);
}
