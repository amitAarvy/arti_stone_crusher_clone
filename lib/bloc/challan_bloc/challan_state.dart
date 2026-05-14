// part of 'challan_bloc.dart';


import 'package:equatable/equatable.dart';

import '../../utils/enum.dart';

class ChallanState extends Equatable{
  final String selectTransport;
  final List productList;
  final List plantList;
  final List supplierList;
  final List listParty;
  final List companyList;
  final List vehicleList;
  final String? selectPlant;
  final String siteAddress;
  final String? selectCompany;
  final String selectSupplier;
  final String? selectedSupplier;
  final String? selectVehicle;
  final String vehicleNo;
  final String? selectTrips;
  final String? selectParty;
  final String? selectProduct;
  final String selectTripsDate;
  final String selectTripsTime;
  final String measurement;
  final String weight;
  final String selectCredit;
  final String selectPaymentMethod;

  final ApiStatus loginApiStatus;

  final String successMsg;
  final String error;

  const ChallanState({
    this.selectTransport='With Transport',
    this.selectTripsDate='',
    this.productList= const [],
    this.plantList= const [],
    this.listParty= const [],
    this.supplierList= const [],
    this.companyList= const [],
    this.vehicleList= const [],
    this.selectTripsTime='',
    this.selectProduct=null,
    this.selectPlant=null,
    this.siteAddress='',
    this.selectCompany=null,
    this.selectSupplier='',
    this.selectParty = null,
    this.selectedSupplier = null,
    this.selectVehicle=null,
    this.vehicleNo='',
    this.selectTrips=null,
    this.measurement='',
    this.weight='',
    this.selectCredit='',
    this.selectPaymentMethod='',
    this.loginApiStatus = ApiStatus.initial,
    this.successMsg = '',
    this.error = '',
  });

  ChallanState backToInitial(){
    return const ChallanState(
      selectTransport: '',
      selectPlant: '',
      productList: [],
      companyList: [],
      listParty: [],
      plantList: [],
      supplierList: [],
      vehicleList: [],
      siteAddress:'',
      selectProduct:'',
      selectTripsTime:'',
    selectCompany:'',
    selectedSupplier:'',
      selectTripsDate:'',
   selectSupplier:'',
    selectParty:'',
    selectVehicle:'',
    vehicleNo:'',
      selectTrips:'',
    measurement:'',
   weight:'',
    selectCredit:'',
    selectPaymentMethod:'',
      loginApiStatus: ApiStatus.initial,
      successMsg: '',
      error: '',
    );
  }

  ChallanState copyWith({
    String?selectTransport,
    List?productList,
    List?listParty,
    List?supplierList,
    List?companyList,
    List?plantList,
    List?vehicleList,
    String? selectTripsTime,
    String? selectedSupplier,
    String? selectProduct,
    String? password,
    String? selectTripsDate,
    String? selectPlant,
     String? siteAddress,
     String? selectCompany,
     String? selectSupplier,
     String? selectParty,
    String? selectVehicle,
     String? vehicleNo,
     String? selectTrips,
     String? measurement,
     String? weight,
     String? selectCredit,
     String? selectPaymentMethod,
    dynamic advertiseImage,
    ApiStatus? loginApiStatus,
    String? successMsg,
    String? error,
  }){
    return ChallanState(

      selectTransport: selectTransport ??this.selectTransport,
      selectProduct: selectProduct??this.selectProduct ,
      vehicleList: vehicleList ??this.vehicleList,
      companyList: companyList ??this.companyList,
      supplierList: supplierList ??this.supplierList,
      plantList: plantList ??this.plantList,
      productList: productList ??this.productList,
      listParty: listParty ?? this.listParty,
      selectPlant: selectPlant??this.selectPlant,
      selectTripsTime: selectTripsTime ??this.selectTripsTime,
      selectedSupplier: selectedSupplier?? this.selectedSupplier ,
      siteAddress: siteAddress ??this.siteAddress,
      selectCompany: selectCompany??this.selectCompany,
      selectTripsDate: selectTripsDate ??this.selectTripsDate,
      selectSupplier: selectSupplier ??this.selectSupplier,
      selectParty: selectParty??this.selectParty ,
      selectVehicle: selectVehicle??this.selectVehicle,
      vehicleNo: vehicleNo ??this.vehicleNo,
      selectTrips: selectTrips??this.selectTrips ,
      measurement: measurement ??this.measurement,
      weight: weight ??this.weight,
      selectCredit: selectCredit ??this.selectCredit,
      selectPaymentMethod: selectPaymentMethod ??this.selectPaymentMethod,
      loginApiStatus: loginApiStatus ?? this.loginApiStatus,
      successMsg: successMsg ?? this.successMsg,
      error: error ?? this.error,
    );
  }




  @override
  List<Object?> get props => [
    selectTransport,
    selectPlant,
    siteAddress,
    productList,
    vehicleList,
    companyList,
    selectTripsDate,
    selectProduct,
    plantList,
    selectTripsTime,
    weight,listParty,selectedSupplier,supplierList,
    selectCredit,
    selectCompany,
    selectSupplier,
    selectVehicle,
    vehicleNo,
    selectPaymentMethod,
    selectTrips,
    measurement,
    selectParty,
    loginApiStatus,
    successMsg,
    error,
  ];
}