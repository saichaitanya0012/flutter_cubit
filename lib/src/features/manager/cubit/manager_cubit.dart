import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'manager_state.dart';

class ManagerCubit extends Cubit<ManagerState> {
  ManagerCubit() : super(ManagerInitial());
}
