import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'requests_event.dart';
part 'requests_state.dart';

class RequestsBloc extends Bloc<RequestsEvent, SelectedState> {
  RequestsBloc() : super(SelectedState(null));

  @override
  Stream<SelectedState> mapEventToState(RequestsEvent event) async* {
    if (event is SelectItemEvent) {
      yield SelectedState(event.index);
    }
  }
}
