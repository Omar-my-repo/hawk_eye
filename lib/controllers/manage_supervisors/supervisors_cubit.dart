import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maps/controllers/manage_supervisors/supervisors_states.dart';

//import 'package:maps/data/web_services/auth_services.dart';
//import 'package:maps/shared_component/shared.dart';

class SupervisorsCubit extends Cubit<SupervisorsStates> {
  SupervisorsCubit() : super(InitialState());

  static SupervisorsCubit get(context) => BlocProvider.of(context);

  List selectedUids = [];
  List unSelectedUids = [];

  addToSelectedList(String id) {
    selectedUids.add(id);
    emit(AddToSelectedList());
  }

  addToUnSelectedList(id) {
    unSelectedUids.add(id);
    emit(AddToUnSelectedList());
  }

  // removeFromSelectedList(String id){
  //   selectedUids.remove(id);
  //   emit(RemoveFromSelectedList());
  // }
  //
  //
  // removeFromUnSelectedList(String id){
  //   unSelectedUids.remove(id);
  //   emit(RemoveFromUnSelectedList());
  // }

  makeItSelected(id) {
    if (!selectedUids.contains(id)) {
      selectedUids.add(id);
    }

    unSelectedUids.remove(id);
    emit(MakeItSelected());
  }

  makeItUnselected(id) {
    if (!unSelectedUids.contains(id)) {
      unSelectedUids.add(id);
    }
    selectedUids.remove(id);

    emit(MakeItUnSelected());
  }
}
