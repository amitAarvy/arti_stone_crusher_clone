import 'dart:convert';

import 'package:arti_stone_crusher/bloc/challan_bloc/challan_bloc.dart';
import 'package:arti_stone_crusher/bloc/challan_bloc/challan_event.dart';
import 'package:arti_stone_crusher/bloc/challan_bloc/challan_state.dart';
import 'package:arti_stone_crusher/data/repo/challan_repo.dart';
import 'package:arti_stone_crusher/utils/color.dart';
import 'package:arti_stone_crusher/utils/utils.dart';
import 'package:arti_stone_crusher/widget/app_dropDown.dart';
import 'package:arti_stone_crusher/widget/app_textfield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../network/network_config.dart';
import '../../utils/enum.dart';
import '../../widget/appButton.dart';
import '../../widget/background.dart';
import '../../widget/search_dropdown.dart';
import 'challan_list.dart';

class CreateChallan extends StatefulWidget {
  final bool isEdit;
  final data;
  final VoidCallback? callback;

  const CreateChallan({Key? key, this.isEdit = false, this.data, this.callback})
      : super(key: key);

  @override
  State<CreateChallan> createState() => _CreateChallanState();
}

class _CreateChallanState extends State<CreateChallan> {
  final ChallanRepo repo = ChallanRepo();

  List productList = [];
  List partYList = [];
  List vehicleList = [];

  TextEditingController searchParty = TextEditingController();

  Future fetchProductList() async {
    try {
      Map<String, dynamic> data = {};
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.productListFetch(data);
      if (res['result']['success'].toString() == "1") {
        productList = res['result']['data'];
        // emit(state.copyWith(productList: res['result']['data'],));
        setState(() {});
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      Fluttertoast.showToast(msg: e.toString());
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);

  Future init() async {
    isLoading.value = true;
    await Future.wait([
      fetchProductList(),
      fetchVehicleList(),
      fetchPartyList(),
      fetchCompany(),
      fetchPlant(),
      fetchSupplierList(),
    ]);
    if (!widget.isEdit) {
      isLoading.value = false;
    }
  }

  Future fetchPartyList() async {
    try {
      Map<String, dynamic> data = {};
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchParty(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        partYList = res['result']['data'];
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future fetchMeasurementId(String vehicleId) async {
    try {
      Map<String, dynamic> data = {
        "party_id": selectParty,
        "vehicle_id": vehicleId
      };
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchMeasurement(data);
      print('api resoonse is mesasurement ${res}');
      // if (res['result']['success'].toString() == "1") {

        measurementController.text = res['measurement'];
      // } else {
      //   throw res['result']['error_msg'];
      // }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future fetchVehicleList() async {
    try {
      Map<String, dynamic> data = {};
      var res = await repo.fetchVehicleList(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        vehicleList = res['result']['data'];
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }
  }

  List companyList = [];

  Future fetchCompany() async {
    try {
      Map<String, dynamic> data = {};
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchCompanyList(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        companyList = res['result']['data'];
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }
  }

  List plantList = [];

  Future fetchPlant() async {
    try {
      Map<String, dynamic> data = {};
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchPlantList(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        plantList = res['result']['data'];
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }
  }

  List supplierList = [];
  Future fetchSupplierList() async {
    try {
      Map<String, dynamic> data = {};
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.fetchSupplierList(data);
      print('api resoonse is supplier ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        supplierList = res['result']['data'];
      } else {
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    }
  }

  Future<void> fetchEditList() async {
    try {
      print('check data is 1${widget.data}');
      final dio = Dio();
      final response =
          await dio.post(NetworkConfig.baseUrl + NetworkConfig.selectChallan,
              data: FormData.fromMap(
                {"trip_id": widget.data['trip_id']},
              ));
      final data = response.data;
      print('check data is ${data}');
      if (data['result']['success'] == 1) {
        print('check data is sa${data}');
        setState(() {
          editFieldUpdate(data['result']['data']);

          // plantOptions = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching plant list: $e');
    } finally {
      isLoading.value = false;
    }
  }

  ValueNotifier<bool> isLoadingButton = ValueNotifier(false);
  ValueNotifier<bool> isLoadingButton1 = ValueNotifier(false);

  void fetchSubmitChallan({bool isPdf = false}) async {
    if (transport == 'Without Transport') {
      if (
          // selectedSupplier == null
          // ||
          selectParty == null ||
              selectCompany == null ||
              weightController.text.isEmpty ||
              measurementController.text.isEmpty ||
              creditType == '' ||
              selectParty == null ||
              // selectVehicle == null ||
              // vehicleNumberController.text.isEmpty ||
              selectTripsDate == '' ||
              selectTripsTime == '' ||
              // selectTrips == null ||
              selectProduct == null) {
        Fluttertoast.showToast(msg: 'Please fill the form');
        return;
      } else {
        if (creditType != 'Credit') {
          if (selectPaymentMethod == '') {
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
      }
    }

    if (transport == 'With Transport') {
      if (vehicleType == '' ||
          siteAddressController.text.isEmpty ||
          selectParty == null ||
          selectCompany == null ||
          weightController.text.isEmpty ||
          measurementController.text.isEmpty ||
          creditType == '' ||
          selectParty == null ||
          // selectVehicle == null ||
          // vehicleNumberController.text.isEmpty ||
          selectTripsDate == '' ||
          selectTripsTime == '' ||
          // selectTrips == null ||
          selectProduct == null) {
        Fluttertoast.showToast(msg: 'Please fill the form');
        return;
      } else {
        if (vehicleType != 'Own Vehicle') {
          if (selectedSupplier == null ||
              selectedSupplier.toString() == 'null') {
            print('check it 3');
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
        if (creditType != 'Credit') {
          if (selectPaymentMethod == '') {
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
      }
    }
    // if(selectCompany ==null){
    //   Fluttertoast.showToast(msg: 'Please fill the form');
    //   // emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
    //   return;
    // }
    // if(selectVehicle ==null){
    //   Fluttertoast.showToast(msg: 'Please fill the form');
    //   // emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
    //   return;
    // }

    var decodeData = jsonDecode(selectVehicle.toString());
    try {
      Map<String, dynamic> data = {
        "party_id": selectParty,
        "vehicle_id": decodeData==null?"":decodeData['vehicle_id']??'',
        "vehicle_no": vehicleNumberController.text,
        "date":
            DateFormat('yyyy-MM-dd').format(DateTime.parse(selectTripsDate)),
        "product_id": selectProduct,
        // "trips": selectTrips,
        "trip_time": selectTripsTime,
        "transport_type": transport == 'With Transport' ? 1 : 2,
        "plant_id": selectPlant,
        "company_id": selectCompany,
        "weight": weightController.text,
        "measurement": measurementController.text,
        "credit": creditType == 'Credit' ? 1 : 2,
        "address": siteAddressController.text,
        "cash_upi": selectPaymentMethod == ''
            ? ''
            : selectPaymentMethod == 'Cash'
                ? 1
                : 2,
        "vehicle_type": vehicleType == 'Own Vehicle' ? 1 : 2,
        // "address":siteAddressController.text,
        "supplier_id": selectedSupplier,
      };

      //
      // if(transport == 'With Transport'){
      //   data.addAll({
      //     // "vehicle_type":vehicleType =='Own Vehicle'?1:2,
      //
      //   });
      // }

      if(isPdf){
        isLoadingButton1.value = true;
      }else{
        isLoadingButton.value = true;
      }
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.createChallan(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        Fluttertoast.showToast(msg: res['result']['msg']);
        if(isPdf) {
          final urls = res['result']['url'].toString();
          final uri = Uri.parse(urls);

          // Get the value of trip_id
          final tripId = uri.queryParameters['trip_id'];
          final Uri url = Uri.parse(
              // res['result']['url']
              'https://www.artistonecrusher.com/index/print_challan/$tripId'
          );
          if (await canLaunchUrl(url)) {
            await launchUrl(url,

              browserConfiguration: BrowserConfiguration(
                  showTitle: true
              ),
              mode: LaunchMode.externalApplication,
              webViewConfiguration: const WebViewConfiguration(
                enableJavaScript: true,

              ),
            );
          }
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => ChallanList()));

        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChallanList()), (route) => false)
        // emit(state.copyWith(loginApiStatus: ApiStatus.success, successMsg: res['result']['msg']));
      } else {
        Fluttertoast.showToast(msg: res['result']['error_msg']);
        throw res['result']['error_msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    } finally {
      isLoadingButton.value = false;
      // emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void   fetchUpateChallan() async {
    print('check it is ${selectTripsDate}');

    if (transport == 'Without Transport') {
      if (selectParty == null ||
          selectCompany == null ||
          weightController.text.isEmpty ||
          measurementController.text.isEmpty ||
          creditType == '' ||
          selectParty == null ||
          // selectVehicle == null ||
          // vehicleNumberController.text.isEmpty ||
          selectTripsDate == '' ||
          selectTripsTime == '' ||
          // selectTrips == null ||
          selectProduct == null) {
        Fluttertoast.showToast(msg: 'Please fill the form');
        return;
      } else {
        if (creditType != 'Credit') {
          if (selectPaymentMethod == '') {
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
      }
    }

    if (transport == 'With Transport') {
      bool isEmptyCommonFields = vehicleType == '' ||
          siteAddressController.text.isEmpty ||
          weightController.text.isEmpty ||
          measurementController.text.isEmpty ||
          creditType == '' ||
          selectParty == null ||
          selectCompany == null ||
          // selectVehicle == null ||
          // vehicleNumberController.text.isEmpty ||
          selectTripsDate == '' ||
          selectTripsTime == '' ||
          // selectTrips == null ||
          selectProduct == null;
      print('check itis ${isEmptyCommonFields}');

      if (isEmptyCommonFields) {
        Fluttertoast.showToast(msg: 'Please fill the form');
        return;
      } else {
        if (vehicleType != 'Own Vehicle') {
          if (selectedSupplier == null ||
              selectedSupplier.toString() == 'null') {
            print('check it 3');
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
        if (creditType != 'Credit') {
          if (selectPaymentMethod == '') {
            Fluttertoast.showToast(msg: 'Please fill the form');
            return;
          }
        }
      }
    }

    // if(selectCompany ==null){
    //   Fluttertoast.showToast(msg: 'Please fill the form');
    //   // emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
    //   return;
    // }
    // if(selectVehicle ==null){
    //   Fluttertoast.showToast(msg: 'Please fill the form');
    //   // emit(state.copyWith(loginApiStatus: ApiStatus.initial, successMsg:'Please fill the form'));
    //   return;
    // }

    var decodeData = jsonDecode(selectVehicle.toString());

    print('check tripd id is ${widget.data['trip_id']}');
    try {
      Map<String, dynamic> data = {
        "id": widget.data['trip_id'],
        "party_id": selectParty,
        "vehicle_id": decodeData==null?"":decodeData['vehicle_id']??"",
        "vehicle_no": vehicleNumberController.text,
        "date": selectTripsDate.contains('-') == true
            ? '${selectTripsDate.split('-')[2]}-${selectTripsDate.split('-')[1]}-${selectTripsDate.split('-')[0]}'
            : DateFormat('yyyy-MM-dd').format(DateTime.parse(selectTripsDate)),
        "product_id": selectProduct,
        // "trips": selectTrips,
        "trip_time": selectTripsTime,
        "transport_type": transport == 'With Transport' ? 1 : 2,
        // "vehicle_type":vehicleType =='Own Vehicle'?1:2,
        // "address":siteAddressController.text,
        "plant_id": selectPlant,
        // "supplier_id":selectedSupplier,
        "company_id": selectCompany,
        "weight": weightController.text,
        "measurement": measurementController.text,
        "credit": creditType == 'Credit' ? 1 : 2,
        "cash_upi": selectPaymentMethod == ''
            ? ''
            : selectPaymentMethod == 'Cash'
                ? 1
                : 2,
        "vehicle_type": vehicleType == 'Own Vehicle' ? 1 : 2,
        "address": siteAddressController.text,
        "supplier_id": selectedSupplier,
      };

      // if(transport == 'With Transport'){
      //   data.addAll({
      //     // "vehicle_type":vehicleType =='Own Vehicle'?1:2,
      //     "vehicle_type":vehicleType =='Own Vehicle'?1:2,
      //     "address":siteAddressController.text,
      //     "supplier_id":selectedSupplier,
      //   });
      // }

      isLoadingButton.value = true;
      // emit(state.copyWith(loginApiStatus: ApiStatus.loading));
      var res = await repo.upateChallan(data);
      print('api resoonse is ${res}');
      if (res['result']['success'].toString() == "1") {
        print('check list is ${res['result']['data']}');
        Fluttertoast.showToast(msg: res['result']['msg']);
        widget.callback!();
      } else {
        throw res['result']['msg'];
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      // emit(state.copyWith(loginApiStatus: ApiStatus.error, error: e.toString()));
    } finally {

      isLoadingButton.value = false;
      isLoadingButton1.value = false;
      // emit(state.copyWith(loginApiStatus: ApiStatus.initial));
    }
  }

  void resetChallanForm({bool isReset = false}) {
    if (isReset == true) {
      selectParty = null;
      selectVehicle = null;
      vehicleNumberController.clear();

      selectProduct = null;
      selectTrips = '';
      transport = '';
      vehicleType = ''; // or default value if any
      siteAddressController.clear();
      selectPlant = null;
      selectedSupplier = null;
      selectCompany = null;
      weightController.clear();
      measurementController.clear();
      creditType = ''; // or default
      selectPaymentMethod = '';
      selectTripsDate = DateTime.now().toString();
      selectTripsTime = DateFormat('hh:mm').format(DateTime.now()).toString();
    } else {
      // selectParty = null;
      // selectVehicle= null;
      // vehicleNumberController.clear();

      // selectProduct = null;
      // selectTrips = '';
      transport = '';
      vehicleType = ''; // or default value if any
      siteAddressController.clear();
      // selectPlant = null;
      selectedSupplier = null;
      // selectCompany = null;
      // weightController.clear();
      // measurementController.clear();
      // creditType = ''; // or default
      selectPaymentMethod = '';
      // selectTripsDate = DateTime.now().toString();
      // selectTripsTime = DateFormat('hh:mm').format(DateTime.now()).toString();
    }

    setState(() {});
  }

  void editFieldUpdate(Map<String, dynamic> data1) {
    print('check error is e ${data1}');
    print('check error is ${vehicleList}');
    List vehicleListSelect = vehicleList
        .where(
            (e) => e['vehicle_id'].toString() == data1['vehicle_id'].toString())
        .toList();

    selectParty = data1['party_id'];
    if(vehicleListSelect.isNotEmpty){
      print('check error is vehicle list ${vehicleListSelect}');
     selectVehicle = jsonEncode(vehicleListSelect[0]);
    }
    vehicleNumberController.text = widget.data['ownvehicleno']??'';
    selectTripsDate =
        '${widget.data['date'].toString().split('-')[2]}-${widget.data['date'].toString().split('-')[1]}-${widget.data['date'].toString().split('-')[0]}';
    selectProduct = data1['product_id'];
    selectTrips = widget.data['trips'];
    selectTripsTime = '${data1['trip_time']}';
    transport = data1['transport_type'].toString() == '1'
        ? "With Transport"
        : data1['transport_type'].toString() == '2'
            ? "Without Transport"
            : '';
    vehicleType = data1['vehicle_type'].toString() == '1'
        ? 'Own Vehicle'
        : data1['vehicle_type'].toString() == '2'
            ? 'Supplier Vehicle'
            : ''; // or default value if any
    siteAddressController.text = data1['address'].toString();
    selectPlant = data1['plant_id'].toString();

    selectCompany = data1['company_id'];
    weightController.text = data1['weight'];
    measurementController.text = data1['measurement'];
    creditType = data1['credit'].toString() == '1'
        ? "Credit"
        : data1['credit'].toString() == '2'
            ? 'Non Credit'
            : ''; // or default
    selectPaymentMethod = data1['cash_upi'].toString() == '1'
        ? "Cash"
        : data1['cash_upi'].toString() == '2'
            ? "UPI"
            : '';
    if (data1['vehicle_type'].toString() == '2') {
      selectedSupplier = data1['supplier_id'];
    } else {
      selectedSupplier = null;
    }

    setState(() {});
  }

  // late ChallanBloc bloc;
  String transport = 'With Transport';
  String vehicleType = '';
  String creditType = 'Non Credit';
  String selectPaymentMethod = '';
  String? selectPlant;
  String selectTripsDate = DateTime.now().toString();
  String selectTripsTime =
      DateFormat('hh:mm').format(DateTime.now()).toString();
  String? selectedCompany;
  String? selectVehicle;
  String? selectTrips;
  String? selectedProduct;
  String? selectedSupplier;
  String? selectCompany;
  String? selectProduct;
  String? selectParty;
  String? product;
  int trips = 1;

  final TextEditingController siteAddressController = TextEditingController();
  final TextEditingController partyController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController tripDateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController measurementController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    // bloc = ChallanBloc(repo: ChallanRepo());
    // TODO: implement initState
    super.initState();
    // bloc.add(ProductList());
    // bloc.add(PartyList());
    // bloc.add(VehicleList());
    // bloc.add(CompanyList());
    // bloc.add(PlantList());
    // bloc.add(SupplierList());

    init().then(
      (value) {
        if (widget.isEdit) {
          fetchEditList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blue[50],
        // appBar: AppBar(
        //   title: const Text('Create Challan',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
        //   centerTitle: true,
        //   // backgroundColor: Colors.blue[50],
        // ),
        body: Background(
            mainContent: ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, bool loading, child) {
                if (loading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: K.darkOrange,
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            _buildRadioRow(
                                'Select Transport',
                                ['With Transport', 'Without Transport'],
                                transport, (val) {
                              print('value is$val');
                              resetChallanForm();
                              setState(() {
                                transport = val;
                              });
                            }),

                            _buildDropdownRow(
                              'Select Plant',
                              plantList
                                  .map((e) => DropdownMenuItem(
                                        child: Text(e['plant_name'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14)),
                                        value: e['id'].toString(),
                                      ))
                                  .toList(),
                              selectPlant == '' ? null : selectPlant,
                              (val) {
                                setState(() {
                                  selectPlant = val;
                                });
                                // bloc.add(SelectPlant(selectPlant: val));
                              },
                            ),

                            //
                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous, current) =>
                            //   previous.plantList != current.plantList ||
                            //       previous.selectPlant != current.selectPlant,
                            //   builder: (context, state) {
                            //     return ;
                            //   },
                            // ),

                            _buildDropdownRow(
                              readOnly: widget.isEdit,
                                'Select Company',
                                companyList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(
                                          e['company_name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        value: e['tbl_company_id'].toString(),
                                      ),
                                    )
                                    .toList(),
                                selectCompany == '' ? null : selectCompany,
                                (val) {
                              setState(() {
                                selectCompany = val;
                              });
                              // bloc.add(SelectCompany(selectCompany: val));
                            }),
                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.selectCompany != current.selectCompany || previous.companyList != current.companyList,
                            //   builder: (context, state) {
                            //     return
                            //
                            //   },
                            // ),

                            if (transport.toString() == 'With Transport') ...[
                              _buildTextFieldRow(
                                  'Enter Site Address', siteAddressController,
                                  (value) {
                                // bloc.add(SiteAddress(siteAddress: value));
                              }),
                              // BlocBuilder<ChallanBloc, ChallanState>(
                              //   buildWhen: (previous,current)=>previous.siteAddress != current.siteAddress,
                              //   builder: (context, state) {
                              //     return  ;
                              //   },
                              // ),

                              // BlocBuilder<ChallanBloc, ChallanState>(
                              //   buildWhen: (previous,current)=>previous.selectCompany != current.selectCompany,
                              //   builder: (context, state) {
                              //     return
                              //
                              //       BlocBuilder<ChallanBloc, ChallanState>(
                              //         buildWhen: (previous,current)=>previous.companyList != current.companyList,
                              //         builder: (context, state) =>
                              //             _buildDropdownRow('Select Company', state.companyList.map((e) => DropdownMenuItem(child: Text(e['company_name']),value: e['tbl_company_id'].toString(),),).toList(), state.selectCompany,
                              //                     (val) {
                              //                   bloc.add(SelectCompany(selectCompany: val));
                              //                 }),
                              //       );
                              //   },
                              // ),

                              Column(
                                children: [
                                  _buildRadioRow(
                                      'Select Own/Supplier',
                                      ['Own Vehicle', 'Supplier Vehicle'],
                                      vehicleType, (val) {
                                    setState(() {
                                      vehicleType = val;
                                    });
                                    // bloc.add(SelectSupplier(selectSupplier: val));
                                  }),

                                  PartyDropdown(content: partYList, title: 'Select Party', valueId: 'party_id', valueText: 'company_name', onChanged: (value) {
                                    setState(() {
                                      selectParty = value;
                                    });
                                  },value: selectParty,showTitle: true,),

                                  // DropdownButtonHideUnderline(
                                  //   child: DropdownButton2<String>(
                                  //     isExpanded: true,
                                  //
                                  //     hint: Text(
                                  //       'Select Item',
                                  //       style: TextStyle(
                                  //         fontSize: 14,
                                  //         color: Theme.of(context).hintColor,
                                  //       ),
                                  //     ),
                                  //     items: partYList
                                  //         .map((item) => DropdownMenuItem(
                                  //               value:
                                  //                   item['party_id'].toString(),
                                  //               child: Text(
                                  //                 item['company_name']
                                  //                     .toString(),
                                  //                 style: const TextStyle(
                                  //                   fontSize: 14,
                                  //                 ),
                                  //               ),
                                  //             ))
                                  //         .toList(),
                                  //     value: selectParty,
                                  //     onChanged: (value) {
                                  //       print('check value is $value');
                                  //       setState(() {
                                  //         selectParty = value;
                                  //       });
                                  //     },
                                  //     buttonStyleData: const ButtonStyleData(
                                  //       padding: EdgeInsets.symmetric(
                                  //           horizontal: 16),
                                  //       height: 40,
                                  //       // width: 200,
                                  //     ),
                                  //
                                  //     dropdownStyleData:
                                  //         const DropdownStyleData(
                                  //       maxHeight: 200,
                                  //     ),
                                  //     menuItemStyleData:
                                  //         const MenuItemStyleData(
                                  //       height: 40,
                                  //     ),
                                  //     dropdownSearchData: DropdownSearchData(
                                  //       searchController: searchParty,
                                  //       searchInnerWidgetHeight: 50,
                                  //       searchInnerWidget: Container(
                                  //         height: 50,
                                  //         padding: const EdgeInsets.only(
                                  //           top: 8,
                                  //           bottom: 4,
                                  //           right: 8,
                                  //           left: 8,
                                  //         ),
                                  //         child: TextFormField(
                                  //           expands: true,
                                  //           maxLines: null,
                                  //           controller: searchParty,
                                  //           decoration: InputDecoration(
                                  //             isDense: true,
                                  //             contentPadding:
                                  //                 const EdgeInsets.symmetric(
                                  //               horizontal: 10,
                                  //               vertical: 8,
                                  //             ),
                                  //             hintText: 'Search for an item...',
                                  //             hintStyle:
                                  //                 const TextStyle(fontSize: 12),
                                  //             border: OutlineInputBorder(
                                  //               borderRadius:
                                  //                   BorderRadius.circular(8),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //       searchMatchFn: (item, searchValue) {
                                  //         // Convert search to lowercase
                                  //         final search = searchValue.toLowerCase();
                                  //
                                  //         // item.child is a widget (Text in your case)
                                  //         if (item.child is Text) {
                                  //           final itemText = (item.child as Text).data?.toLowerCase() ?? '';
                                  //           print('check itme text is ${itemText} ');
                                  //           return itemText.contains(search);
                                  //         }
                                  //
                                  //         // If not a Text widget, fallback to value
                                  //         final itemValue = item.value?.toLowerCase() ?? '';
                                  //         return itemValue.contains(search);
                                  //       },
                                  //     ),
                                  //     onMenuStateChange: (isOpen) {
                                  //       if (!isOpen) {
                                  //         searchParty.clear();
                                  //       }
                                  //     },
                                  //   ),
                                  // ),

                                  // _buildDropdownRow(
                                  //     'Select Party',
                                  //     partYList
                                  //         .map(
                                  //           (e) => DropdownMenuItem(
                                  //             child: Text(
                                  //               e['company_name'].toString(),
                                  //               style: TextStyle(
                                  //                   fontWeight: FontWeight.w400,
                                  //                   fontSize: 14),
                                  //             ),
                                  //             value: e['party_id'].toString(),
                                  //           ),
                                  //         )
                                  //         .toList(),
                                  //     selectParty == '' ? null : selectParty,
                                  //     (val) {
                                  //   setState(() {
                                  //     selectParty = val;
                                  //   });
                                  //   // bloc.add(SelectParty(selectParty: val));
                                  // }),

                                  // BlocBuilder<ChallanBloc, ChallanState>(
                                  //   buildWhen: (previous,current)=>previous.selectParty != current.selectParty || previous.listParty != current.listParty,
                                  //   builder: (context, state) {
                                  //     return
                                  //   },
                                  // ),

                                  _buildDropdownRow(
                                      'Select Vehicle',
                                      vehicleList
                                          .map(
                                            (e) => DropdownMenuItem(
                                              child: Text(
                                                e['vehicle_no'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 14),
                                              ),
                                              value: jsonEncode(e),
                                            ),
                                          )
                                          .toList(),
                                      selectVehicle == ''
                                          ? null
                                          : selectVehicle, (val) {
                                    var data = jsonDecode(val);
                                    print('check value is ${data}');

                                    setState(() {
                                      vehicleNumberController.text =
                                          data['vehicle_no'].toString();
                                      selectVehicle = val;
                                    });
                                    fetchMeasurementId(data['vehicle_id']);
                                    // bloc.add(VehicleNo(vehicleNo:data['vehicle_no'].toString()));
                                    //
                                    // bloc.add(SelectVehicle(selectVehicle:val ));
                                  }),
                                  // BlocBuilder<ChallanBloc, ChallanState>(
                                  //   buildWhen: (previous,current)=> previous.vehicleList != current.vehicleList ||previous.selectVehicle != current.selectVehicle,
                                  //   builder: (context, state) {
                                  //     return
                                  //       ;
                                  //   },
                                  // ),

                                  // own vehicle
                                  if (vehicleType.toString() ==
                                      'Own Vehicle') ...[
                                    _buildTextFieldRow(
                                      'Enter Vehicle Number',
                                      vehicleNumberController,
                                      (value) {
                                        // bloc.add(VehicleNo(vehicleNo:value ));
                                      },
                                    )
                                    // BlocBuilder<ChallanBloc, ChallanState>(
                                    //   buildWhen: (previous,current)=>previous.vehicleNo != current.vehicleNo,
                                    //   builder: (context, state) {
                                    //     return  ;
                                    //   },
                                    // ),
                                  ],

                                  if (vehicleType.toString() ==
                                      'Supplier Vehicle') ...[
                                    PartyDropdown(content: supplierList, title: 'Select Supplier'
                                        , valueId: 'id', valueText: 'supplier_name', onChanged: (value) {
                                      setState(() {
                                        selectedSupplier = value;
                                      });
                                    },value: selectedSupplier,showTitle: true,),
                                    // _buildDropdownRow(
                                    //     'Select Supplier',
                                    //     supplierList
                                    //         .map(
                                    //           (e) => DropdownMenuItem(
                                    //             child: Text(
                                    //               e['supplier_name'].toString(),
                                    //               style: TextStyle(
                                    //                   fontWeight:
                                    //                       FontWeight.w400,
                                    //                   fontSize: 14),
                                    //             ),
                                    //             value: e['id'].toString(),
                                    //           ),
                                    //         )
                                    //         .toList(),
                                    //     selectedSupplier == ''
                                    //         ? null
                                    //         : selectedSupplier, (val) {
                                    //   setState(() {
                                    //     selectedSupplier = val;
                                    //   });
                                    //   // bloc.add(SelectedSupplier(selectedSupplier: val));
                                    // })

                                    // // BlocBuilder<ChallanBloc, ChallanState>(
                                    // //   buildWhen: (previous,current)=>previous.supplierList != current.supplierList || previous.selectedSupplier != current.selectedSupplier,
                                    // //   builder: (context, state) {
                                    // //     print('check value is %${state.selectedSupplier}');
                                    // //     return   _buildDropdownRow('Select Supplier', state.supplierList.map((e) => DropdownMenuItem(child: Text(e['supplier_name'].toString(),style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),value: e['id'].toString(),),).toList(),
                                    // //         state.selectedSupplier==''?null:state.selectedSupplier,
                                    // //             (val) {
                                    // //           bloc.add(SelectedSupplier(selectedSupplier: val));
                                    // //         });
                                    //   },
                                    // ),
                                  ]
                                ],
                              )
                            ],

                            // without transport

                            if (transport.toString() ==
                                'Without Transport') ...[
                              PartyDropdown(content: partYList, title: 'Select Party', valueId: 'party_id', valueText: 'company_name', onChanged: (value) {
                                setState(() {
                                  selectParty = value;
                                });
                              },value: selectParty,showTitle: true,),


                              // _buildDropdownRow(
                              //     'Select Party',
                              //     partYList
                              //         .map(
                              //           (e) => DropdownMenuItem(
                              //             child: Text(
                              //               e['company_name'].toString(),
                              //               style: TextStyle(
                              //                   fontWeight: FontWeight.w400,
                              //                   fontSize: 14),
                              //             ),
                              //             value: e['party_id'].toString(),
                              //           ),
                              //         )
                              //         .toList(),
                              //     selectParty, (val) {
                              //   setState(() {
                              //     selectParty = val;
                              //   });
                              //   // bloc.add(SelectParty(selectParty: val));
                              // }),

                              // BlocBuilder<ChallanBloc, ChallanState>(
                              //   buildWhen: (previous,current)=>previous.listParty != current.listParty || previous.selectParty != current.selectParty,
                              //   builder: (context, state) {
                              //     return   ;
                              //   },
                              // ),

                              _buildDropdownRow(
                                  'Select Vehicle',
                                  vehicleList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          child: Text(
                                            e['vehicle_no'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14),
                                          ),
                                          value: jsonEncode(e),
                                        ),
                                      )
                                      .toList(),
                                  selectVehicle == '' ? null : selectVehicle,
                                  (val) {
                                // vehicleNumberController.text = e[]
                                // bloc.add(SelectVehicle(selectVehicle: val));
                                var data = jsonDecode(val);
                                print('check value is ${data}');
                                setState(() {
                                  vehicleNumberController.text =
                                      data['vehicle_no'].toString();
                                  selectVehicle = val;
                                });
                                // bloc.add(VehicleNo(vehicleNo:data['vehicle_no'].toString()));
                                //
                                // bloc.add(SelectVehicle(selectVehicle:val ));
                              }),

                              // BlocBuilder<ChallanBloc, ChallanState>(
                              //   buildWhen: (previous,current)=>previous.vehicleList != current.vehicleList || previous.selectVehicle != current.selectVehicle,
                              //   builder: (context, state) {
                              //     return
                              //       _buildDropdownRow('Select Vehicle',
                              //           state.vehicleList.map((e) => DropdownMenuItem(child: Text(e['vehicle_no'],style: TextStyle(fontWeight: FontWeight.w400,fontSize: 14),),value: jsonEncode(e),),).toList(),
                              //           state.selectVehicle==''?null:state.selectVehicle,
                              //               (val) {
                              //             // vehicleNumberController.text = e[]
                              //             // bloc.add(SelectVehicle(selectVehicle: val));
                              //             var data  = jsonDecode(val);
                              //             print('check value is ${data}');
                              //             bloc.add(VehicleNo(vehicleNo:data['vehicle_no'].toString()));
                              //             vehicleNumberController.text =data['vehicle_no'].toString() ;
                              //             bloc.add(SelectVehicle(selectVehicle:val ));
                              //           });
                              //   },
                              // ),

                              _buildTextFieldRow(
                                'Enter Vehicle Number',
                                vehicleNumberController,
                                (value) {
                                  // bloc.add(VehicleNo(vehicleNo:value ));
                                },
                              )

                              // BlocBuilder<ChallanBloc, ChallanState>(
                              //   buildWhen: (previous,current)=>previous.vehicleNo != current.vehicleNo,
                              //   builder: (context, state) {
                              //     return  ;
                              //   },
                              // ),
                            ],

                            // _buildDropdownRow(
                            //     'Trips',
                            //     List.generate(10, (i) => '${i + 1}')
                            //         .map(
                            //           (e) => DropdownMenuItem(
                            //             child: Text(
                            //               e,
                            //               style: TextStyle(
                            //                   fontWeight: FontWeight.w400,
                            //                   fontSize: 14),
                            //             ),
                            //             value: e.toString(),
                            //           ),
                            //         )
                            //         .toList(),
                            //     selectTrips == '' ? null : selectTrips, (val) {
                            //   setState(() {
                            //     selectTrips = val;
                            //   });
                            //   // bloc.add(SelectTrips(selectTrips: val));
                            // }),

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.selectTrips != current.selectTrips,
                            //   builder: (context, state) {
                            //
                            //     return   ;
                            //   },
                            // ),

                            InkWell(
                                onTap: () {
                                  Utils.datePickerCommon(context).then(
                                    (value) {
                                      print('check date picker value ${value}');
                                      setState(() {
                                        if (widget.isEdit) {
                                          if (value == null) {
                                            return;
                                          }
                                          selectTripsDate =
                                              DateFormat('dd-MM-yyyy')
                                                  .format(value);
                                        } else {
                                          if (value == null) {
                                            return;
                                          }
                                          selectTripsDate = value.toString();
                                        }
                                      });
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Trip Date:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: K.darkOrange)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Center(
                                                child: Text(
                                              widget.isEdit
                                                  ? DateFormat('dd-MM-yyyy')
                                                  .format(DateTime.parse(
                                                  DateFormat(
                                                      'dd-MM-yyyy')
                                                      .parseStrict(
                                                      selectTripsDate)
                                                      .toString()))
                                                  : selectTripsDate == ''
                                                      ? ''
                                                      : DateFormat('dd-MM-yyyy')
                                                          .format(DateTime.parse(
                                                              selectTripsDate)),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous != current.selectTrips,
                            //   builder: (context, state) {
                            //     return    ;
                            //   },
                            // ),
                            SizedBox(height: 10,),
                            InkWell(
                                onTap: () {
                                  Utils.timePickerCommon(context).then(
                                    (value) {
                                      print(
                                          'check time picker value ${value!.format(context)}');
                                      setState(() {
                                        selectTripsTime =
                                            value!.format(context).toString();
                                      });
                                    },
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Select Time:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1.sw,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border:
                                              Border.all(color: K.darkOrange)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Center(
                                                child: Text(
                                              selectTripsTime == ''
                                                  ? ''
                                                  : selectTripsTime,
                                              style: TextStyle(
                                                  color: Colors.black),
                                            )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.selectTripsTime != current.selectTripsTime,
                            //   builder: (context, state) {
                            //     return  ;
                            //   },
                            // ),

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous != current.selectTrips,
                            //   builder: (context, state) {
                            //     return _buildTextFieldRow('Select Time', timeController,(value) {
                            //
                            //     },);
                            //   },
                            // ),

                            _buildDropdownRow(
                                'Select Product',
                                productList
                                    .map(
                                      (e) => DropdownMenuItem(
                                        child: Text(
                                          e['title'].toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14),
                                        ),
                                        value: e['product_id'].toString(),
                                      ),
                                    )
                                    .toList(),
                                selectProduct == '' ? null : selectProduct,
                                (val) {
                              setState(() {
                                selectProduct = val;
                              });
                              // bloc.add(SelectProduct(selectProduct: val));
                            }),
                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   // buildWhen: (previous,current)=>previous.productList != current.productList || previous.selectProduct != current.selectProduct,
                            //   builder: (context, state) {
                            //     print('check product list is ${state.productList}');
                            //     return ;
                            //   },
                            // ),

                            _buildTextFieldRow(
                              keyBoardType: TextInputType.number,
                              'Measurement',
                              measurementController,

                              (value) {
                                // bloc.add(Measurement(measurement: value));
                              },
                            ),

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.measurement != current.measurement,
                            //   builder: (context, state) {
                            //     return   ;
                            //   },
                            // ),

                            _buildTextFieldRow(
                              keyBoardType: TextInputType.number,
                              'Weight',
                              weightController,
                              (value) {
                                // bloc.add(Weight(weight: value));
                              },
                            ),
                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.weight != current.weight,
                            //   builder: (context, state) {
                            //     return  ;
                            //   },
                            // ),

                            Column(
                              children: [
                                _buildRadioRow(
                                    'Select Credit',
                                    ['Credit', 'Non Credit'],
                                    creditType, (val) {
                                  // bloc.add(SelectCredit(selectCredit: val));
                                  setState(() {
                                    creditType = val;
                                  });
                                }),
                                if (creditType.toString() == 'Non Credit')
                                  _buildRadioRow(
                                      'Select Payment Method',
                                      ['Cash', 'UPI'],
                                      selectPaymentMethod, (val) {
                                    setState(() {
                                      selectPaymentMethod = val;
                                    });
                                  })
                                // BlocBuilder<ChallanBloc, ChallanState>(
                                //   buildWhen: (previous,current)=>previous.selectPaymentMethod != current.selectPaymentMethod,
                                //   builder: (context, state) {
                                //     return  _;
                                //   },
                                // ),
                              ],
                            )

                            // BlocBuilder<ChallanBloc, ChallanState>(
                            //   buildWhen: (previous,current)=>previous.selectCredit != current.selectCredit,
                            //   builder: (context, state) {
                            //     return ;
                            //   },
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                backgroundColor: Colors.grey,
                                text: "Reset",
                                onPressed: () {
                                  // bloc.add(SelectCompany(selectCompany: ''));
                                  // bloc.add(SelectPlant(selectPlant: null));
                                  // bloc.add(SelectPaymentMethod(selectPaymentMethod: ''));
                                  // bloc.add(SelectCredit(selectCredit: ''));
                                  // bloc.add(Weight(weight: ''));
                                  // bloc.add(Measurement(measurement: ''));
                                  // bloc.add(SelectProduct(selectProduct: ''));
                                  // bloc.add(SelectTripsTime(selectTripsTime: ''));
                                  // bloc.add(SelectTripsDate(selectTripsDate:''));
                                  // bloc.add(SelectTrips(selectTrips: ''));
                                  // bloc.add(SelectParty(selectParty: ''));
                                  // bloc.add(VehicleNo(vehicleNo:''));
                                  // bloc.add(SelectVehicle(selectVehicle:'' ));
                                  // bloc.add(SelectSupplier(selectSupplier: ''));
                                  // bloc.add(SiteAddress(siteAddress: ''));
                                  // bloc.add(SelectTransport(selectTransport: ''));
                                  // bloc.add(ResetAllFields());
                                  // measurementController.clear();
                                  // weightController.clear();
                                  // vehicleNumberController.clear();
                                  // siteAddressController.clear();
                                  resetChallanForm(isReset: true);
                                },
                                // isLoading: state.loginApiStatus == ApiStatus.loading,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: ValueListenableBuilder(
                              valueListenable: isLoadingButton,
                              builder: (context, bool loading, child) =>
                                  AppButton(
                                    fontSize: 14,
                                text: widget.isEdit ? 'Update and Go to List' : 'Save and Go to List',
                                onPressed: () {
                                  if (widget.isEdit) {
                                    fetchUpateChallan();
                                  } else {
                                    fetchSubmitChallan();
                                  }
                                  // bloc.add(SubmitChallan());
                                },
                                isLoading: loading,
                              ),
                            )

                                // BlocListener<ChallanBloc, ChallanState>(
                                //   listenWhen: (previous, current) => previous.loginApiStatus != current.loginApiStatus,
                                //   listener: (context, state) {
                                //     if(state.loginApiStatus == ApiStatus.error){
                                //       Utils.showFlushBar(state.error, FlushBarType.error, context);
                                //     }
                                //     if(state.loginApiStatus == ApiStatus.success){
                                //       // Navigator.pop(context);
                                //       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ChallanList()), (route) => false);
                                //       Utils.showFlushBar(state.successMsg, FlushBarType.success, context);
                                //     }
                                //   },
                                //   child: BlocBuilder<ChallanBloc, ChallanState>(
                                //     buildWhen: (previous, current) => previous.loginApiStatus != current.loginApiStatus,
                                //     builder: (context, state) {
                                //       return AppButton(
                                //         text: "Add",
                                //         onPressed: () {
                                //           bloc.add(SubmitChallan());
                                //         },
                                //         isLoading: state.loginApiStatus == ApiStatus.loading,
                                //       );
                                //     },
                                //   ),
                                //   //
                                //   // SizedBox(
                                //   //   width: double.infinity,
                                //   //   height: 50,
                                //   //   child: ElevatedButton(
                                //   //     style: ElevatedButton.styleFrom(
                                //   //       backgroundColor: K.darkOrange,
                                //   //       shape: RoundedRectangleBorder(
                                //   //         borderRadius: BorderRadius.circular(10),
                                //   //       ),
                                //   //     ),
                                //   //     onPressed: isLoading ? null : _login,
                                //   //     child: isLoading
                                //   //         ? const CircularProgressIndicator(color: Colors.white)
                                //   //         : const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                                //   //   ),
                                //   // ),
                                // ),
                                ),
                          ],
                        ),
                        // const SizedBox(height: 20),
                        if(!widget.isEdit)...[
                          const SizedBox(height: 20),
                          ValueListenableBuilder(
                            valueListenable: isLoadingButton1,
                            builder: (context, bool loading, child) =>
                                AppButton(
                                  text: 'Save and Print',
                                  onPressed: () {
                                    if (widget.isEdit) {
                                      fetchUpateChallan();
                                    } else {
                                      fetchSubmitChallan(isPdf: true);
                                    }
                                    // bloc.add(SubmitChallan());
                                  },
                                  isLoading: loading,
                                ),
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            topWidget: Padding(
              padding: EdgeInsets.only(top: 0.07.sh, right: 15, left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Text(
                    '${widget.isEdit ? "Update" : "Create"} Challan',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 20),
                  ),
                  SizedBox()
                ],
              ),
            )));
  }

  Widget _buildRadioRow(String label, List<String> options, String selected,
      ValueChanged onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label + ' :',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
          ),
          Row(
            children: options
                .map((opt) => Row(
                      children: [
                        Radio<String>(
                            activeColor: K.darkOrange,
                            value: opt,
                            groupValue: selected,
                            onChanged: onChanged),
                        Text(opt),
                      ],
                    ))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _buildDropdownRow(
      String label,
      final List<DropdownMenuItem<String>>? items,
      String? selectedValue,
      ValueChanged onChanged,{bool readOnly =false}) {
    print('check dropdown value ${selectedValue}');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AppDropdown(
        isReadOnly: readOnly,
          items: items,
          onChanged: onChanged,
          value: selectedValue,
          hintText: label,
          showTitle: true,
          title: '$label:'),
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller,
      ValueChanged<String>? onChanged,
      {bool isReadOnly = false,keyBoardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: AppTextField(
        keyboardType: keyBoardType,
        controller: controller,
        hintText: label,
        isRequired: isReadOnly,
        showTitle: true,
        title: '$label:',
        onChanged: onChanged,
      ),
    );
  }
}
