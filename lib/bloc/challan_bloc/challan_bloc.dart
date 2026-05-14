import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../../data/repo/challan_repo.dart';
import '../../services/session_controller.dart';
import '../../utils/enum.dart';
import '../../data/repo/login_repo.dart';
import 'challan_event.dart';
import 'challan_state.dart';


class ChallanBloc extends Bloc<ChallanEvent, ChallanState>{
  final ChallanRepo repo;
  final SessionController _sessionController = SessionController();
  ChallanBloc({required this.repo}) : super(const ChallanState()){
    on<SelectTransport>(_selectTransport);
    on<SelectPlant>(_selectPlant);
    on<SelectTripsDate>(_selectTripsDate);
    on<SiteAddress>(_siteAddress);
    on<SelectCompany>(_selectCompany);
    on<SelectSupplier>(_selectSupplier);
    on<SelectParty>(_selectParty);
    on<SelectVehicle>(_selectVehicle);
    on<SelectedSupplier>(_selectedSupplier);
    on<VehicleNo>(_vehicleNo);
    on<SelectTrips>(_selectTrips);
    on<Measurement>(_measurement);
    on<SelectProduct>(_selectProduct);
    on<Weight>(_weight);
    on<SelectCredit>(_selectCredit);
    on<ProductList>(fetchProductList);
    on<PartyList>(fetchPartyList);
    on<CompanyList>(fetchCompany);
    on<PlantList>(fetchPlant);
    on<SupplierList>(fetchSupplierList);
    on<VehicleList>(fetchVehicleList);
    on<SubmitChallan>(fetchSubmitChallan);
    on<SelectPaymentMethod>(_selectPaymentMethod);
    on<SelectTripsTime>(_selectTripsTime);
    on<ResetAllFields>(resetField);

    // on<LoginWithEmailPassword>(_loginWithEmailPassword);
  }

  void _selectTransport(SelectTransport event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectTransport: event.selectTransport));
  }
  void _siteAddress(SiteAddress event, Emitter<ChallanState> emit){
    emit(state.copyWith(siteAddress: event.siteAddress));
  }
  void _selectCompany(SelectCompany event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectCompany: event.selectCompany));
  }
  void _measurement(Measurement event, Emitter<ChallanState> emit){
    emit(state.copyWith(measurement: event.measurement));
  }
 void _selectSupplier(SelectSupplier event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectSupplier: event.selectSupplier));
  }
  void _selectParty(SelectParty event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectParty: event.selectParty));
  }
  void _selectPaymentMethod(SelectPaymentMethod event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectPaymentMethod: event.selectPaymentMethod));
  }
  void _selectProduct(SelectProduct event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectProduct: event.selectProduct));
  }
  void _weight(Weight event, Emitter<ChallanState> emit){
    emit(state.copyWith(weight: event.weight));
  } void _selectCredit(SelectCredit event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectCredit: event.selectCredit));
  }
  void _selectTrips(SelectTrips event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectTrips: event.selectTrips));
  }

  void _selectPlant(SelectPlant event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectPlant: event.selectPlant));
  }
  void _vehicleNo(VehicleNo event, Emitter<ChallanState> emit){
    emit(state.copyWith(vehicleNo: event.vehicleNo));
  }
  void _selectVehicle(SelectVehicle event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectVehicle: event.selectVehicle));
  }
  // void _resetField(ResetAllFields event, Emitter<ChallanState> emit){
  //   emit(state.copyWith(selectVehicle: event.selectVehicle));
  // }

  void _selectTripsDate(SelectTripsDate event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectTripsDate: event.selectTripsDate));
  }
  void _selectTripsTime(SelectTripsTime event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectTripsTime: event.selectTripsTime));
  }
  void _selectedSupplier(SelectedSupplier event, Emitter<ChallanState> emit){
    emit(state.copyWith(selectedSupplier: event.selectedSupplier));
  }

  void resetField(ResetAllFields event, Emitter<ChallanState> emit) async {
    print('check event ${state.selectCompany}');
    emit(state.copyWith(
      selectCompany: '',
      selectPlant: '',
      selectPaymentMethod: '',
      selectCredit: '',
      weight: '',
      measurement: '',
      selectProduct: '',
      selectTripsTime: '',
      selectTripsDate: '',
      selectTrips: '',
      selectParty: '',
      vehicleNo: '',
      selectVehicle: '',
      selectSupplier:'',
      siteAddress: '',
      selectTransport: '',
    ));
    print('check event ${state.selectCompany}');
  }

  void fetchProductList(ProductList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {
      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.productListFetch(data);
      if(res['result']['success'].toString() == "1"){
        emit(state.copyWith(productList: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void fetchPartyList(PartyList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {

      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchParty(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(listParty: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }


  void fetchVehicleList(VehicleList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {

      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchVehicleList(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(vehicleList: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void fetchCompany(CompanyList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {

      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchCompanyList(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(companyList: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void fetchPlant(PlantList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {

      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchPlantList(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(plantList: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void fetchSupplierList(SupplierList event, Emitter<ChallanState> emit)async
  {
    try{
      Map<String, dynamic> data = {

      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchSupplierList(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(supplierList: res['result']['data'],));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }


  void fetchSubmitChallan(SubmitChallan event, Emitter<ChallanState> emit)async
  {

    if(state.selectCompany ==null){
      emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
      return;
    }if(state.selectVehicle ==null){
      emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
      return;
    }

    var decodeData= jsonDecode(state.selectVehicle.toString());
    try{
      Map<String, dynamic> data = {
        "party_id":state.selectParty,
        "vehicle_id":decodeData['vehicle_id'],
        "vehicle_no":state.vehicleNo,
        "date":DateFormat('yyyy-MM-dd').format(DateTime.parse(state.selectTripsDate)),
        "product_id":state.selectProduct,
        "trips":state.selectTrips,
        "trip_time":state.selectTripsTime,
        "transport_type":state.selectTransport == 'With Transport'?1:0,
        "vehicle_type":state.selectSupplier =='Own Vehicle'?1:0,
        "address":state.siteAddress,
        "plant_id":state.selectPlant,
        "supplier_id":state.selectedSupplier,
        "company_id":state.selectCompany,
        "weight":state.weight,
        "measurement":state.measurement,
        "credit":state.selectCredit =='Credit'?1:0,
        "cash_upi":state.selectPaymentMethod == ''?'':state.selectPaymentMethod == 'Cash'?1:0,
      };
      emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.createChallan(data);
      print('api resoonse is ${res}');
      if(res['result']['success'].toString() == "1"){
        print('check list is ${res['result']['data']}');
        emit(state.copyWith(loginApiStatus: ApiStatus.success, successMsg: res['result']['msg']));
      }else{
        throw res['result']['error_msg'];
      }
    }catch(e, s){
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }finally{
      emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }
}

