import 'dart:convert';

import 'package:arti_stone_crusher/utils/color.dart';
import 'package:arti_stone_crusher/widget/appButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../network/network_config.dart';
import '../../utils/utils.dart';
import '../../widget/app_dropDown.dart';
import '../../widget/app_textfield.dart';
import '../../widget/background.dart';
import '../../widget/search_dropdown.dart';
import 'inward_challan_list.dart';

class AddInwardChallan extends StatefulWidget {
  final bool isEdit;
  final data;
  final VoidCallback? callback;
  const AddInwardChallan({Key? key,  this.isEdit=false, this.data,  this.callback}) : super(key: key);

  @override
  State<AddInwardChallan> createState() => _AddInwardChallanState();
}

class _AddInwardChallanState extends State<AddInwardChallan> {
  // Dropdown selections
  String? selectedPlant;
  String? selectedSupplier;
  String? selectedVehicle;
  String? selectedQuery;
  String pumpTo = 'Hopper';
  String vehicleType = 'Own Vehicle';

  // Controllers
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController brassController = TextEditingController();
  final TextEditingController dateController = TextEditingController(text: DateFormat('dd-MM-yyyy').format(DateTime.now()));
  final TextEditingController timeController = TextEditingController(text: DateFormat('hh:mm').format(DateTime.now()));

  // Dropdown data
  List plantOptions = [];
  List supplierOptions = [];
  List vehicleOptions = [];
  List quarryOptions = [];

  ValueNotifier<bool> isLoadingPage = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    init().then((value) {
      edit();
    });
  }

  Future<void> init() async {
    isLoadingPage.value = true;
    await Future.wait([
      fetchPlantList(),
      fetchVehicles(),
      fetchQuarries(),
      fetchSupplierList(),
    ]);
    if(!widget.isEdit){
      isLoadingPage.value = false;
    }
  }

  void edit() {
    // Future.delayed(Duration(seconds: 1), () {
      if (widget.isEdit) {
        print('check list data is found $vehicleOptions');
        List data = vehicleOptions.where(
              (element) {
                print('check id is ${element}');
                print('check id is ${widget.data}');
                return element['vehicle_id'].toString() == widget.data['vehicle_id'].toString();
              },
        ).toList();
        print('check list data is found $data');
        selectedPlant = widget.data['plant_id'];
        remark.text = widget.data['remark']??'';
        selectedSupplier = widget.data['supplier_vehicle_id'];
        selectedVehicle = data.isEmpty ? null : jsonEncode(data[0]);
        selectedQuery = widget.data['quary_id'];
        vehicleNumberController.text = widget.data['vehicle_no'];
        weightController.text = widget.data['weight'];
        brassController.text = widget.data['brass'];
        dateController.text = '${widget.data['date'].toString().split('-')[2]}-${widget.data['date'].toString().split('-')[1]}-${widget.data['date'].toString().split('-')[0]}';
        timeController.text = widget.data['time'];
        vehicleType = widget.data['vehicle_type'].toString() == '2' ? 'Supplier Vehicle' : 'Own Vehicle';
        pumpTo= widget.data['pump_to'].toString()=="1"?'Hopper':'Outsite Stock';

        setState(() {}); // move inside to reflect updated values
      }
      isLoadingPage.value = false;
    // });
  }


  Future<void> fetchEditList() async {
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

  Future<void> fetchSupplierList() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_supplier,
        data: {},
      );
      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          supplierOptions = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching plant list: $e');
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
          vehicleOptions = data['result']['data'] ;
        });
      }
    } catch (e) {
      print('Error fetching vehicles: $e');
    }
  }

  Future<void> fetchQuarries() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_quary,
        data: {},
      );
      final data = response.data;
      if (data['result']['success'] == 1) {
        setState(() {
          quarryOptions = data['result']['data'] ;
        });
      }
    } catch (e) {
      print('Error fetching quarry list: $e');
    }
  }

  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoading1 = ValueNotifier(false);

  TextEditingController remark= TextEditingController();

  Future<void> addInward({bool isPrint = false}) async {
    try {

      if(isPrint){
        isLoading1.value =true;
      }else{
       isLoading.value =true;
      }
      // if(selectedVehicle ==null){
      //   Fluttertoast.showToast(msg: 'Please select Vehicle');
      //   return;
      // }

      final dio = Dio();
      var requiredField = {
        "plant_id":selectedPlant,
        "vehicle_type":vehicleType=='Own Vehicle'?1:2,
        "supplier_vehicle_id":selectedSupplier,
        "vehicle_id":selectedVehicle==null?null:jsonDecode(selectedVehicle!)['vehicle_id'],
        "vehicle_no":vehicleNumberController.text,
        "weight":weightController.text,
        "brass":brassController.text,
        "time":timeController.text,
        "date":'${dateController.text.toString().split('-')[2]}-${dateController.text.toString().split('-')[1]}-${dateController.text.toString().split('-')[0]}',
        "pump_to":pumpTo=='Hopper'?1:2,
        "quary_id":selectedQuery,
        "remark":remark.text
      };
      print('check url is ${NetworkConfig.baseUrl + NetworkConfig.addInward}');
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.addInward,
        data:  FormData.fromMap(requiredField)
      );
      final data = response.data;
      print('yes it is 1 ${data} \n ${requiredField}');

      if (data['result']['success'].toString() == '1') {
        if(isPrint){
          final tripId = data['result']['inward_id'];
          final Uri url = Uri.parse(
              'https://www.artistonecrusher.com/index/print_inward_challan/$tripId'
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
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InwardChallanList()));
          return;
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InwardChallanList()));

        }
       Fluttertoast.showToast(msg: data['result']['msg'] );
      }else{
        Fluttertoast.showToast(msg: data['result']['error_msg'] );
      }
    } catch (e) {
      print('Error fetching Quary  list: $e');
    }finally{
      if(isPrint){
        isLoading1.value =false;
      }else{
        isLoading.value =false;
      }
    }
  }

  ValueNotifier<String> challanType = ValueNotifier('');
  TextEditingController challanNo = TextEditingController();
  Future<void> updateInward() async {
    try {
      isLoading.value =true;
      if(selectedVehicle ==null){
        Fluttertoast.showToast(msg: 'Please select Vehicle');
        return;
      }
      final dio = Dio();
      var requiredField = {
        "id":widget.data['id'],
        "plant_id":selectedPlant,
        "vehicle_type":vehicleType=='Own Vehicle'?1:2,
        "supplier_vehicle_id":selectedSupplier,
        "vehicle_id":jsonDecode(selectedVehicle!)['vehicle_id'],
        "vehicle_no":vehicleNumberController.text,
        "weight":weightController.text,
        "brass":brassController.text,
        "time":timeController.text,
        "date":'${dateController.text.toString().split('-')[2]}-${dateController.text.toString().split('-')[1]}-${dateController.text.toString().split('-')[0]}',
        "pump_to":pumpTo=='Hopper'?1:2,
        "quary_id":selectedQuery,
        "remark":remark.text
      };
      print('check url is ${requiredField}');
      print('check url is ${NetworkConfig.baseUrl + NetworkConfig.upateInward}');
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.upateInward,
        data:  requiredField
      );
      final data = response.data;
      print('yes it is 1 ${data} \n ${requiredField}');
      if (data['result']['success'].toString() == '1') {
        print('yes it is ');
       Fluttertoast.showToast(msg: data['result']['msg'] );
       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>InwardChallanList()));
       widget.callback!();
       Navigator.pop(context);
      }else{
        Fluttertoast.showToast(msg: data['result']['msg'] );
      }
    } catch (e) {
      print('Error fetching Quary  list: $e');
    }finally{
      isLoading.value = false;
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        mainContent: ValueListenableBuilder(
          valueListenable: isLoadingPage,
          builder: (context, bool loading, child) {
            if(loading){
              return Center(child: CircularProgressIndicator(color: K.darkOrange,),);
            }
            return Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SingleChildScrollView(
                padding:  EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildDropdown('Select Plant', plantOptions.map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['plant_name'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedPlant,
                            (val) => setState(() => selectedPlant = val)),

                    _buildRadioButtons('Select Vehicle Type', ['Own Vehicle', 'Supplier Vehicle'],
                        vehicleType, (val) {
                          if(widget.isEdit){
                            selectedSupplier = null;
                            selectedVehicle = null;
                            // pumpTo = '';
                            // selectedQuery = null;
                            vehicleNumberController.clear();
                            // weightController.clear();
                            // brassController.clear();
                            // timeController.clear();
                          }else{
                            selectedSupplier = null;
                            selectedVehicle = null;
                            pumpTo = '';
                            selectedQuery = null;
                            vehicleNumberController.clear();
                            weightController.clear();
                            brassController.clear();
                            // dateController.clear();
                            // timeController.clear();
                          }



                          setState(() => vehicleType = val);
                        }),
                    if (vehicleType == 'Supplier Vehicle')...[
                      PartyDropdown(content: supplierOptions, title: 'Select Supplier', valueId: 'id', valueText: 'supplier_name', onChanged: (value) {
                        setState(() {
                          selectedSupplier = value;
                        });
                      },value: selectedSupplier,showTitle: true,),
                      SizedBox(height: 10,),
                    ],
                    if (vehicleType != 'Supplier Vehicle')...[
                      _buildDropdown('Select Vehicle', vehicleOptions.map((e) => DropdownMenuItem(value: jsonEncode(e),child: Text(e['vehicle_no'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedVehicle,
                              (val) {
                            var data = jsonDecode(val);
                            vehicleNumberController.text=data['vehicle_no'].toString();
                            selectedVehicle = val;
                          }),
                      _buildTextField('Enter Vehicle Number', vehicleNumberController),
                    ],

                    ValueListenableBuilder(
                      valueListenable: challanType,
                      builder: (context, String type, child) =>
                       Column(
                        children: [
                          _buildRadioButtons(
                              'Select Challan Type',
                              ['Manual', 'Automatic'],
                              type, (val) {
                            // bloc.add(SelectCredit(selectCredit: val));

                              if(val =='Automatic'){
                                challanNo.text ='OC-0526-.01';
                              }
                              challanType.value = val;

                          }),

                          if(type =='Manual')
                            _buildTextField(
                                'Enter Challan Number', challanNo,),
                        ],
                      ),
                    ),


                    _buildTextField('Weight', weightController),
                    _buildTextField('Brass', brassController),
                    _buildDropdown('Quary Selection', quarryOptions.map((e) => DropdownMenuItem(value: e['id'].toString(),child: Text(e['mine_name'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),))).toList(), selectedQuery,
                            (val) => setState(() => selectedQuery = val)),
                    _buildRadioButtons('Dump to', ['Hopper', 'Outsite Stock'],
                        pumpTo, (val) => setState(() => pumpTo = val)),


                    InkWell(
                        onTap: (){
                          Utils.datePickerCommon(context).then((value) {
                            print('check date picker value ${value}');
                            dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.parse(value.toString()));
                            setState(() {
                            });
                          },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select Date:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),),
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
                                    child: Center(child: Text(dateController.text==''?'':dateController.text,style: TextStyle(color: Colors.black),)),
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
                          Utils.timePickerCommon(context).then((value) {
                            // print('check time picker value ${value!.format(context)}');
                            timeController.text = value!.format(context).toString();
                            setState(() {
                            });
                            // bloc.add(SelectTripsTime(selectTripsTime: ));
                          },
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select Time:',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.grey),),
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
                                    child: Center(child: Text(timeController.text==''?'':timeController.text,style: TextStyle(color: Colors.black),)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 10,),

                    _buildTextField('Remark', remark,maxLine: 4),
                    // _buildTextField('Select Time', timeController, hintText: '-- : -- --'),
                    const SizedBox(height: 16),
                    Center(
                      child: ValueListenableBuilder(
                        valueListenable: isLoading,
                        builder: (context,bool value, child) =>
                            AppButton(
                              text: widget.isEdit?'Update':'Add',
                              isLoading: value,
                              onPressed: () {
                                if(widget.isEdit){
                                  updateInward();
                                }else{
                                  addInward();
                                }

                                // Submit logic
                              },
                            ),
                      ),
                    ),
                    if(!widget.isEdit)...[
                      const SizedBox(height: 20),
                      ValueListenableBuilder(
                        valueListenable: isLoading1,
                        builder: (context, bool loading, child) =>
                            AppButton(
                              backgroundColor: Color(0xffE8710F),
                              text: 'Save and Print',
                              onPressed:  () {
                                addInward(isPrint: true);
                              },
                              isLoading: loading,
                            ),
                      ),
                    ],
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
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.white)),
               Text('${widget.isEdit?'Update':'Add'} Inward Challan',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontSize: 20)),
              const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {String? hintText,int?maxLine}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppTextField(
        controller: controller,
        hintText: hintText ?? label,
        showTitle: true,
        maxLine: maxLine,

        title: '$label:',

      ),
    );
  }

  Widget _buildDropdown(String label, List<DropdownMenuItem<String>>? items, String? value,
      void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppDropdown(
        items:
        items,
        onChanged: (val) => onChanged(val!),
        value: value,
        hintText: label,
        showTitle: true,
        title: '$label:',
      ),
    );
  }

  Widget _buildRadioButtons(String label, List<String> options, String groupValue,
      void Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
              TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
          Row(
            children: options.map((option) {
              return Row(
                children: [
                  Radio<String>(
                    activeColor: K.darkOrange,
                    value: option,
                    groupValue: groupValue,
                    onChanged: (value) => onChanged(value!),
                  ),
                  Text(option),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
