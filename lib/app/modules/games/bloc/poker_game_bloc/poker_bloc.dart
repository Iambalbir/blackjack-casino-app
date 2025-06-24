import 'package:app/export_file.dart';

class PokerBloc extends Bloc<PokerEvents, PokerStates> {
  PokerBloc() : super(PokerStates.initialState()) {
    on<PokerTableDimensionsEvent>(_updateTableDimension);
    on<UpdatePokerTableHolePositionsEvent>(_initializeHolePositions);
  }

  void _updateTableDimension(
      PokerTableDimensionsEvent event, Emitter<PokerStates> emit) {
    final width = MediaQuery.sizeOf(event.context).width * 0.8;
    final height = MediaQuery.sizeOf(event.context).height * 0.68;
    emit(state.copyWith(tableHeight: height, tableWidth: width));
  }

  Future<void> _initializeHolePositions(
      UpdatePokerTableHolePositionsEvent event,
      Emitter<PokerStates> emit) async {
    final double holeRadius = state.tableHeight * 0.038;
    final double holeDiameter = holeRadius * 2;
    final double verticalSpace = state.tableHeight - holeDiameter * 2;
    final double margin = verticalSpace / 3;
    final double leftHole1Y = margin - 2;
    final double leftHole2Y = margin + holeDiameter + margin;
    final double rightHole1Y = leftHole1Y;
    final double rightHole2Y = leftHole2Y;

    var holePositions = [
      Offset(state.tableWidth / 1.78.w - holeRadius, -13.h),
      Offset(state.tableWidth / 1.78.w - holeRadius, state.tableHeight - 30.h),
      Offset(-15.w, leftHole1Y + 10.h),
      Offset(-15.w, leftHole2Y + 3.h),
      Offset(state.tableWidth - holeDiameter + 3.w, rightHole1Y),
      Offset(state.tableWidth - holeDiameter + 3.w, rightHole2Y),
    ];
    emit(state.copyWith(holePositions: holePositions));
  }
}
