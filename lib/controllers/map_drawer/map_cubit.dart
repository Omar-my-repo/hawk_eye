import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps/controllers/map_drawer/map_states.dart';
import 'package:maps/data/web_services/lat_lon_services.dart';
import 'package:maps/data/web_services/report_services.dart';
import 'package:maps/shared_component/shared.dart';
//import 'package:connectivity/connectivity.dart';

class MapCubit extends Cubit<MapStates> {
  MapCubit() : super(InitialState());

  Position? newPosition;

  var oldLat = 30.033333;
  var oldLong = 31.233334;

  final LatLongServices _latLongServices = LatLongServices();
  final ReportServices _reportServices = ReportServices();

  static MapCubit get(context) => BlocProvider.of(context);

  updatePosition() async {
    newPosition = await Geolocator.getCurrentPosition();
    double distance = Geolocator.distanceBetween(
        newPosition!.latitude, newPosition!.longitude, oldLat, oldLong);
    if (distance >= 50) {
      await _latLongServices.updateUserGeoPoint(
        newPosition!.latitude,
        newPosition!.longitude,
      );
    }
    oldLat = newPosition!.latitude;
    oldLong = newPosition!.longitude;

    emit(UpdatePositionState());
  }

  uploadUserReport({required String report, required String date}) async {
    emit(UpdateReportLoadingState());

    _reportServices.uploadUserReport(report: report, date: date).then((value) {
      emit(UpdateReportSuccessState());
      showToast(errorMessage: 'تم ارسال التقرير بنجاح');
    }).catchError((e) {
      showToast(
          errorMessage:
              'لم يتم ارسال التقرير، الرجاء التحقق من إتصالك بالإنترنت');
      emit(UpdateReportFailureState());
    });
  }
}
