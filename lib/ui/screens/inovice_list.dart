import 'dart:convert';

import 'package:arti_stone_crusher/widget/appButton.dart';
import 'package:arti_stone_crusher/widget/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/network_config.dart';
import '../../utils/color.dart';
import '../../utils/utils.dart';
import '../../widget/app_dropDown.dart';
import '../../widget/background.dart';
import '../../widget/search_dropdown.dart';
import 'create_challan.dart';
import 'create_invoice.dart';


class InvoiceList extends StatefulWidget {
  const InvoiceList({Key? key}) : super(key: key);

  @override
  State<InvoiceList> createState() => _InvoiceListState();
}

class _InvoiceListState extends State<InvoiceList> {
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController partyController = TextEditingController();

  String? selectedVehicle = null;
  String? selectedProduct = null;
  String? selectedCompany ;
  String? selectedParty ;

  List challanList = [];
  List companyOptions = [];
  List vehicleOptions = [];
  List productOptions = [];
  List partyOptions = [];
  // bool isLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  TextEditingController vehicleNo= TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }


  ValueNotifier<bool> isLoadingPage = ValueNotifier(false);
  init()async{
    isLoadingPage.value = true;
    await Future.wait([
      fetchChallanList(),
      fetchCompanies(),
      fetchVehicles(),
      fetchProducts(),
      fetchParties(),
      fetchPlantList()
    ]);
    isLoadingPage.value = false;
  }

  Future<void> fetchChallanList() async {
    isLoading.value = true;

    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.invoiceList,
        data: {},
      );
      print('check url is ${ NetworkConfig.baseUrl + NetworkConfig.invoiceList}');

      final data = response.data;
      print('check url is ${data}');
      if (data['result']['success'] == 1) {
        setState(() {
          challanList = data['result']['data'] ;
        });
      }else{
        setState(() {
          challanList = [];
        });
      }
    } catch (e) {
      print('Error fetching challans: $e');
    } finally {
      // setState(() {
      isLoading.value = false;
      // });
    }
  }

  void showDeleteAlert(BuildContext context, String tripId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Challan"),
          content: Text("Are you sure you want to delete this challan?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
              },
              child: Text("No"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                deleteChallan(tripId);  // call API
              },
              child: Text("Yes",style: TextStyle(fontWeight: FontWeight.w600,),),
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteChallan(String tripId) async {
    isLoading.value = true;

    print('check challan id is ${tripId}');
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.deleteInvoice +'?trip_id=$tripId',
        data: {},
      );
      final data = response.data;
      print('check data is ${data}');
      if (data['status'].toString() == 'true') {
        Fluttertoast.showToast(msg: data['message']);
        fetchChallanList();
      }else{
        Fluttertoast.showToast(msg: data['message']);
      }
    } catch (e) {
      debugPrint('check error is ${e}');
      // print('Error fetching challans: $e');
    } finally {

      isLoading.value = false;
    }
  }

  Future<void> fetchCompanies() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_company,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          companyOptions = data['result']['data'] ;
        });
      }
    } catch (e) {
      print('Error fetching companies: $e');
    }
  }

  Future<void> submitFilter() async {
    isLoadingSubmit.value =true;
    try {
      final dio = Dio();

      final response = await dio.post(
          NetworkConfig.baseUrl + NetworkConfig.filterInvoice,
          data: FormData.fromMap({
            "fromdate": fromDateController.text.isEmpty?'':fromDateController.text,
            "todate": toDateController.text.isEmpty?'':toDateController.text,
            "party_id": selectedParty??'',
            "vehicle_id": selectedVehicle??'',
            "vehicle_no": vehicleNo.text.isEmpty?'':vehicleNo.text,
            "product_id": selectedProduct??'',
            "company_id": selectedCompany??'',
            "plant_id":selectedPlant??''
          },)
      );
      final data = response.data;
      if (data['result']['success'] == 1) {
        challanList =[];
        setState(() {
          challanList = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching companies: $e');
    }finally{
      isLoadingSubmit.value = false;
    }
  }

  Future<void> fetchVehicles() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_vehicle,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          vehicleOptions = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching vehicles: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_product,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          productOptions = data['result']['data'] ;
        });
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  Future<void> fetchParties() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_party,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          partyOptions = data['result']['data'] ;
        });
      }
    } catch (e) {
      print('Error fetching parties: $e');
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        controller.text = pickedDate.toIso8601String().split('T').first;
      });
    }
  }

  String? selectedPlant;
  List plantOptions =[];
  Future<void> fetchPlantList() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_plant,
        data: {},
      );
      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          plantOptions = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching plant list: $e');
    }
  }


  ValueNotifier<bool> isLoadingSubmit = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue[50],
      // appBar: AppBar(
      //
      //   title: const Text(
      //     'Challan List',
      //     style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600,fontSize: 16),
      //   ),
      //   centerTitle: true,
      //   // backgroundColor: Colors.blue[50],
      //   elevation: 1,
      //   shadowColor: Colors.black12,
      // ),
        body:Background(
            mainContent:ValueListenableBuilder(
              valueListenable: isLoadingPage,
              builder: (context, bool loading, child) {
                if(loading){
                  return Center(child: CircularProgressIndicator(color: K.darkOrange,),);
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child:  SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                            onTap: (){
                              Utils.datePickerCommon(context).then((value) {
                                fromDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(value.toString()));
                                setState(() {
                                });
                              },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('From Date:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),),
                                SizedBox(height: 5,),
                                Container(
                                  height: 40,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: K.darkOrange)
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Center(child: Text(fromDateController.text==''?'':fromDateController.text,style: TextStyle(color: Colors.black),)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 10,),
                        InkWell(
                            onTap: (){
                              Utils.datePickerCommon(context).then((value) {
                                toDateController.text = DateFormat('dd/MM/yyyy').format(DateTime.parse(value.toString()));
                                setState(() {
                                });
                              },
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('To Date:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),),
                                SizedBox(height: 5,),
                                Container(
                                  height: 40,
                                  width: 1.sw,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: K.darkOrange)
                                  ),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 10),
                                        child: Center(child: Text(toDateController.text==''?'':toDateController.text,style: TextStyle(color: Colors.black),)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                        SizedBox(height: 10,),
                        _buildDropdown('Select Plant', plantOptions.map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['plant_name'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedPlant,
                                (val) => setState(() => selectedPlant = val)),
                        // SizedBox(height: 10,),
                        PartyDropdown(content: partyOptions, title: 'Select Party', valueId: 'party_id', valueText: 'company_name', onChanged: (value) {
                          setState(() {
                            selectedParty = value;
                          });
                        },value: selectedParty,showTitle: true,),
                        // _buildDropdown('Select Party', partyOptions.map((e) => DropdownMenuItem(value: e['party_id'].toString(), child: Text(e['company_name']??'',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList()
                        //     , selectedParty, (val) => setState(() => selectedParty = val)),
                        SizedBox(height: 10,),
                        _buildDropdown('Select Vehicle', vehicleOptions.map((e) => DropdownMenuItem(value: e['vehicle_id'].toString(), child: Text(e['vehicle_no']??'',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedVehicle, (val) => setState(() => selectedVehicle = val)),
                        AppTextField(
                          controller: vehicleNo,
                          showTitle: true,
                          title: 'Vehicle No',
                          hintText: 'Enter vehicle no',
                        ),
                        SizedBox(height: 10,),
                        _buildDropdown('Select Product', productOptions.map((e) => DropdownMenuItem(value: e['product_id'].toString(), child: Text(e['title'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedProduct, (val) => setState(() => selectedProduct = val)),
                        _buildDropdown('Select Company', companyOptions.map((e) => DropdownMenuItem(value: e['tbl_company_id'].toString(), child: Text(e['company_name']??'',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedCompany, (val) => setState(() => selectedCompany = val)),
                        const SizedBox(height: 12),

                        Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: ValueListenableBuilder(
                                  valueListenable: isLoadingSubmit,
                                  builder: (context,bool value, child) =>
                                      AppButton(
                                        text: 'Submit',
                                        isLoading: value,
                                        onPressed: () {
                                          // addInward();
                                          submitFilter();

                                          // Submit logic
                                        },
                                      ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: AppButton(
                                  backgroundColor: Colors.grey,
                                  text: 'Clear ',
                                  onPressed: () {
                                    fromDateController.text = '';
                                    toDateController.text = '';
                                    selectedVehicle =null;
                                    selectedPlant = null;
                                    // selectedVehicle = null;
                                    selectedProduct = null;
                                    selectedCompany=null ;
                                    selectedParty  = null;
                                    vehicleNo.clear();
                                    setState(() {
                                    });
                                    fetchChallanList();

                                  },
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ElevatedButton(
                          //     style: ElevatedButton.styleFrom(
                          //         backgroundColor:  Colors.blue,
                          //         shape: BeveledRectangleBorder(
                          //             borderRadius: BorderRadius.all(Radius.circular(5))
                          //         )
                          //     ),
                          //     onPressed: () {},
                          //     child: const Text('Submit',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
                          //   ),
                          // ),
                        ),
                        const SizedBox(height: 24),
                        _buildChallanCardView(),
                      ],
                    ),
                  ),
                );
              },

            ),
            topWidget: Padding(
              padding:  EdgeInsets.only(top:  0.07.sh,right: 15,left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap:(){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: Colors.white,)),
                  Text('Invoice List',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 20),),
                  SizedBox()
                ],
              ),
            ))



    );
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: AppTextField(
          showTitle: true,
          title: '$label:',
          controller: controller,
          hintText: label,
        )
      // Row(
      //   children: [
      //     Expanded(flex: 2, child: Text(label)),
      //     Expanded(
      //       flex: 5,
      //       child: AppTextField(
      //
      //         controller: controller,
      //         hintText: label,
      //       )
      //       // TextField(
      //       //   controller: controller,
      //       //   readOnly: true,
      //       //   decoration: const InputDecoration(
      //       //     border: OutlineInputBorder(),
      //       //   ),
      //       //   onTap: () => _selectDate(controller),
      //       // ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildDropdown(String label, List<DropdownMenuItem<String>>?  options, String? selectedValue, Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: AppDropdown(
          items: options,
          onChanged: (val) => onChanged(val!),
          value: selectedValue,
          hintText: label,
          showTitle: true,
          title: '$label:'),


      // Row(
      //   children: [
      //     Expanded(flex: 2, child: Text(label)),
      //     Expanded(
      //       flex: 5,
      //       child: DropdownButtonFormField<String>(
      //         isExpanded: true,
      //         value: selectedValue.isEmpty ? null : selectedValue,
      //         hint: Text(label),
      //         items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      //         onChanged: (val) => onChanged(val!),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildChallanCardView() {


    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, bool loading, child) {
        if (loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (challanList.isEmpty) {
          return const Center(child: Text('No invoice found'));
        }
        return Column(
          children: challanList.map((data) {
            return Card(
              color: Colors.blue[70],
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month,color: K.darkOrange,),
                            SizedBox(width: 2,),
                            Text('Date: ${data['date']}',style: TextStyle(color: K.darkOrange,fontWeight: FontWeight.w600),),
                          ],
                        ),
                        Row(
                          children: [
                            InkWell(
                                onTap: (){
                                  // print('check trip data is now ${data}');
                                  // deleteChallan(data['trip_id']);
                                  showDeleteAlert(context, data['trip_id']);
                                },
                                child: Text('Delete',style: TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.w600),)),
                            SizedBox(width: 10,),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateInvoice(callback: (){
                                    Navigator.pop(context);
                                    fetchChallanList();
                                  },data: data,isEdit: true,)));
                                },
                                child: Text('Edit',style: TextStyle(color: Colors.grey,fontSize: 15),)),
                            SizedBox(width: 10,),
                            InkWell(
                                onTap: ()async{
                                  print('check trip data is now ${data}');
                                  if(data['trip_id'] != null) {
                                    final Uri url = Uri.parse(
                                        'https://www.artistonecrusher.com/index/print_bill/${data['trip_id']}');
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
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }
                                },
                                child: Text('Print',style: TextStyle(color: Colors.blue,fontSize: 15),))
                          ],
                        )
                        ,
                      ],
                    ),
                    const SizedBox(height: 4),
                    Divider(color: K.darkOrange,),
                    const SizedBox(height: 4),
                    Text('Invoice No: ${data['invoice_no']??''}', style:  TextStyle(fontWeight: FontWeight.bold,color: K.darkOrange)),


                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.person,color: K.darkOrange,),
                        SizedBox(width: 2,),
                        Expanded(child: Text(' ${data['party_name']??''} ')),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.add_chart_rounded,color: K.darkOrange,),
                        SizedBox(width: 2,),
                        Text('Company: ${data['company_name']??''}'),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.fire_truck_rounded,color: K.darkOrange,),
                        SizedBox(width: 2,),
                        Text('Vehicle No: ${data['ownvehicleno']??''}'),
                      ],
                    ),

                    Row(
                      children: [
                        Icon(Icons.production_quantity_limits,color: K.darkOrange,),
                        SizedBox(width: 2,),
                        SizedBox(
                            width: 0.75.sw,
                            child: Text('Product: ${data['title']??''}')),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Icon(Icons.trip_origin,color: K.darkOrange,),
                    //     SizedBox(width: 2,),
                    //     Text('Trips: ${data['trips']??''}'),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },

    );
  }
}