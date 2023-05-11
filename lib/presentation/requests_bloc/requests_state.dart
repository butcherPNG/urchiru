part of 'requests_bloc.dart';

@immutable
abstract class RequestsState {}

class RequestsInitial extends RequestsState {}

class SelectedState {
  final int? selectedItem;
  SelectedState(this.selectedItem);
}
