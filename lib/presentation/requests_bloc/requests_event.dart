part of 'requests_bloc.dart';

@immutable
abstract class RequestsEvent {}

class SelectItemEvent extends RequestsEvent {
  final int index;

  SelectItemEvent(this.index);
}
