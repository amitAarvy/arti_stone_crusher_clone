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
import 'add_inward_challan.dart';

class InwardChallanList extends StatefulWidget {
  const InwardChallanList({super.key});

  @override
  State<InwardChallanList> createState() => _InwardChallanListState();
}

class _InwardChallanListState extends State<InwardChallanList> {
  // List vehicleOptions = [];
  String? selectedVehicle;
  // List plantOptions = [];
  String? selectedPlant;
  // List supplierOptions = [];
  String? selectedSupplier;
  // List quarryOptions = [];
  ValueNotifier<List> quarryOptions = ValueNotifier([]);
  ValueNotifier<List> supplierOptions = ValueNotifier([]);
  ValueNotifier<List> plantOptions = ValueNotifier([]);
  ValueNotifier<List> vehicleOptions = ValueNotifier([]);
  String? selectedQuarry;
  String? selectedPump ='Hopper';

  @override
  void initState() {
    super.initState();
    init();
  }

  ValueNotifier<bool> isLoadingPage = ValueNotifier(false);


  init()async{
    isLoadingPage.value = true;
    Future.value([
     fetchVehicles(),
      fetchPlants(),
      fetchSuppliers(),
      fetchQuarries(),
      fetchChallanInwardList(),
    ]);
    isLoadingPage.value = false;
}

  // bool isLoading = false;
  ValueNotifier<bool> isLoading = ValueNotifier(false);
  ValueNotifier<bool> isLoadingDelete = ValueNotifier(false);
  // bool isLoadingDelete = false;

  ValueNotifier<List> challanList = ValueNotifier([]);

  Future<void> fetchChallanInwardList() async {
      isLoading.value = true;

    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.inwardChalanList,
        data: {},
      );
      final data = response.data;
      challanList.value = [];
      if (data['result']['success'] == 1) {
        challanList.value = data['result']['data'];
      }
    } catch (e) {
      print('Error fetching challans: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future deleteChallan(String id) async {

      isLoadingDelete.value = true;
    try {
      final dio = Dio();
      final response = await dio.post(
        '${NetworkConfig.baseUrl + NetworkConfig.deleteInwardChallan}?id=$id',
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        Fluttertoast.showToast(msg: data['result']['msg']);
        return true;
      }
    } catch (e) {
      print('Error fetching challans: $e');
    } finally {
        isLoadingDelete.value = false;
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
          quarryOptions.value = data['result']['data'];
      }
    } catch (e) {
      print('Error fetching quarries: $e');
    }
  }

  Future<void> fetchSuppliers() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_supplier,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
          supplierOptions.value = data['result']['data'] ;
      }
    } catch (e) {
      print('Error fetching suppliers: $e');
    }
  }

  Future<void> fetchPlants() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.list_plant,
        data: {},
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
          plantOptions.value = data['result']['data'] ;
      }
    } catch (e) {
      print('Error fetching plants: $e');
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
          vehicleOptions.value = data['result']['data'] ;
      }
    } catch (e) {
      print('Error fetching vehicles: $e');
    }
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildFilters(context),
                      const SizedBox(height: 16),
                      _buildChallanCardList(),
                    ],
                  ),
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
                  child: Icon(Icons.arrow_back, color: Colors.white)),
              Text(
                'Inward Challan List',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20),
              ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  ValueNotifier isLoadingSubmit = ValueNotifier(false);


  Future<void> submitFilter() async {
    isLoadingSubmit.value =true;
    try {
      final dio = Dio();

      // var queryp = {
      //   "fromdate": fromDateController.text,
      //   "todate": toDateController.text,
      //   "vehicle_id": selectedVehicle,
      //   "plant_id": selectedPlant,
      //   "quary_id": selectedQuarry,
      //   "challan_no":challanNo.text,
      //   "supplier_vehicle_id":selectedSupplier,
      //   "pump_to":selectedPump==null?'':selectedPump =='Hopper'?1:2
      // };

      // print('cehck data is ${queryp}');
      //
      // print(jsonEncode(data1));
      final response = await dio.post(
          NetworkConfig.baseUrl + NetworkConfig.filterChallanInward,
          data: FormData.fromMap({
            "fromdate": fromDateController.text,
            "todate": toDateController.text,
            "vehicle_id": selectedVehicle,
            "plant_id": selectedPlant,
            "quary_id": selectedQuarry,
            "challan_no":challanNo.text,
            "supplier_vehicle_id":selectedSupplier,
            "pump_to":selectedPump==null?'':selectedPump =='Hopper'?1:2
          },)
      );
      final data = response.data;
      print('cehck list data is ${data}');
      if (data['result']['success'] == 1) {
        challanList.value =[];
        setState(() {
          challanList.value = data['result']['data'];
        });
      }
    } catch (e) {
      print('Error fetching companies: $e');
    }finally{
      isLoadingSubmit.value = false;
    }
  }

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();
  TextEditingController supplierInvoiceNo = TextEditingController();
  Widget _buildFilters(BuildContext context) {
    return Column(
      children: [
        // _filterRow(['From Date', 'To Date']),
        InkWell(
            onTap: (){
              Utils.datePickerCommon(context).then((value) {
                print('check date picker value ${value}');
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
                print('check date picker value ${value}');
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
        _filterRow(['Challan No', 'Select Vehicle']),
        _filterRow(['Select Quary', 'Select Supplier']),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ValueListenableBuilder(
                  valueListenable: plantOptions,
                  builder: (context, List plant, child) =>
                  AppDropdown(
                    items: plant
                        .map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['plant_name'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedPlant = val;
                      });
                    },
                    value: selectedPlant,
                    hintText: 'Select Plant',
                    showTitle: true,
                    title: 'Select Plant:',
                  ),
                ),
              ),
            ),
          ],
        ),
        _buildRadioGroup('Dump to', ['Hopper', 'Outsite Stock'],selectedPump,),

        _buildTextField('Supplier Invoice No', supplierInvoiceNo,),
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: isLoadingSubmit,
                builder: (context, value, child) =>
                 AppButton(
                  text: 'Submit',
                  isLoading: value==true?true:false,
                  onPressed: () {
                    submitFilter();
                  },
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: AppButton(
                backgroundColor: Colors.grey,
                text: 'Clear ',
                onPressed: () {
                  fromDateController.text = '';
                  toDateController.text = '';
                  challanNo.clear();
                  selectedVehicle =null;
                  selectedSupplier =null;
                  selectedPlant =null;
                  selectedQuarry =null;
                  selectedPump = null;
                  setState(() {
                  });
                  fetchChallanInwardList();

                },
              ),
            ),
          ],
        )
      ],
    );
  }

  ValueNotifier<List> selectChallan = ValueNotifier([]);
  Widget _filterRow(List<String> fields) {
    return Row(
      children: fields.map((field) {
        Widget fieldWidget;

        if (field == 'Select Vehicle') {
          fieldWidget = ValueListenableBuilder(
            valueListenable: vehicleOptions,
            builder: (context,List vehicle, child) =>
             AppDropdown(
              items: vehicle
                  .map((e) => DropdownMenuItem(value: e['vehicle_id'].toString(), child: Text(e['vehicle_no'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedVehicle = val;
                });
              },
              value: selectedVehicle??null,
              hintText: field,
              showTitle: true,
              title: '$field:',
            ),
          );
        } else if (field == 'Select Supplier') {
          fieldWidget = ValueListenableBuilder(
            valueListenable: supplierOptions,
            builder: (context, List supplierData, child) =>
         AppDropdown(
              items: supplierData
                  .map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['supplier_name'],style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedSupplier = val;
                });
              },
              value: selectedSupplier==null?null:selectedSupplier,
              hintText: field,
              showTitle: true,
              title: '$field:',
            ),
          );
        } else if (field == 'Select Quary') {
          fieldWidget = ValueListenableBuilder(
            valueListenable: quarryOptions,
            builder: (context, List quarryData, child) =>
             AppDropdown(
              items: quarryData
                  .map((e) => DropdownMenuItem(value: e['id'].toString(), child: Text(e['mine_name']??'',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w400),)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  selectedQuarry = val;
                });
              },
              value: selectedQuarry,
              hintText: field,
              showTitle: true,
              title: '$field:',
            ),
          );
        } else {
          fieldWidget = AppTextField(
            controller: challanNo,
            hintText: field,
            showTitle: true,
            title: '$field:',
          );
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: fieldWidget,
          ),
        );
      }).toList(),
    );
  }

  TextEditingController challanNo = TextEditingController();
  Widget _buildRadioGroup(String label, List<String> options,String? select) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          ...options.map((opt) => Row(
            children: [
              Radio(
                  activeColor: K.darkOrange,
                  value: opt,
                  groupValue: select==''?null:select,
                  onChanged: (val) {
                    setState(() {
                      selectedPump = val;
                    });

                  }),
              Text(opt),
            ],
          )),
        ],
      ),
    );
  }



  void showCreateInvoiceSheet(BuildContext context) {
    final TextEditingController invoiceNoController =
    TextEditingController();

    final TextEditingController dateController =
    TextEditingController();

    final TextEditingController remarkController =
    TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Title
              const Text(
                "Create Invoice",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              /// Supplier Invoice No
              const Text("Supplier Invoice No"),

              const SizedBox(height: 8),

              TextField(
                controller: invoiceNoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Invoice No",
                ),
              ),

              const SizedBox(height: 16),

              /// Supplier Invoice Date
              const Text("Supplier Invoice Date"),

              const SizedBox(height: 8),

              TextField(
                controller: dateController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "dd/mm/yyyy",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    dateController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                },
              ),

              const SizedBox(height: 16),

              /// Remark
              const Text("Remark"),

              const SizedBox(height: 8),

              TextField(
                controller: remarkController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Enter Remark",
                ),
              ),

              const SizedBox(height: 20),

              /// Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Close"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Submit"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildChallanCardList() {
    return ValueListenableBuilder(
      valueListenable: isLoading,
      builder: (context, bool loading, child) {
        if(loading){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ValueListenableBuilder(
          valueListenable: selectChallan,
          builder: (context, List selectedChallan, child) =>
              ValueListenableBuilder(
                valueListenable:  challanList,
                builder: (context, List challanData, child) {
                  print('selectChallan$selectChallan');
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(selectedChallan.isNotEmpty)...[
                          AppButton(
                            text: 'Create Invoice',
                            onPressed: (){
                              showCreateInvoiceSheet(context);

                            },
                          ),
                          SizedBox(height: 10,),

                        ],
                        ListView.builder(
                          itemCount: challanData.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final c = challanData[index];
                            return Card(
                              color: Color(0xffF8F1F9),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [

                                        InkWell(
                                            onTap: ()async{
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>AddInwardChallan(data: c,isEdit: true,callback: (){
                                                fetchChallanInwardList();
                                              },)));
                                            },
                                            child: Text('Edit',style: TextStyle(color: Colors.grey,fontSize: 15),)),
                                        SizedBox(width: 10,),
                                        InkWell(
                                            onTap: ()async{
                                              showDeleteConfirmation(context,(){
                                                deleteChallan('${c['id'].toString()}').then((value) {
                                                  if(value.toString()=='true'){
                                                    Navigator.pop(context);
                                                    fetchChallanInwardList();
                                                  }
                                                },);
                                              });
                                            }, child: Text('Delete',style: TextStyle(color: Colors.red,fontSize: 15),)),
                                        // SizedBox(width: 10,),
                                        // InkWell(
                                        //     onTap: ()async{
                                        //       print('check trip data is now ${c}');
                                        //       if(c['id'] != null) {
                                        //         final Uri url = Uri.parse(
                                        //             'https://www.artistonecrusher.com/index/print_inward_challan/${c['id']}');
                                        //         if (await canLaunchUrl(url)) {
                                        //           await launchUrl(url,
                                        //
                                        //             browserConfiguration: BrowserConfiguration(
                                        //                 showTitle: true
                                        //             ),
                                        //             mode: LaunchMode.externalApplication,
                                        //             webViewConfiguration: const WebViewConfiguration(
                                        //               enableJavaScript: true,
                                        //
                                        //             ),
                                        //           );
                                        //         } else {
                                        //           throw 'Could not launch $url';
                                        //         }
                                        //       }
                                        //
                                        //     },
                                        //     child: Text('Print',style: TextStyle(color: Colors.blue,fontSize: 15),))
                                      ],
                                    ),

                                    Row(
                                      children: [
                                        Checkbox(
                                          value: selectedChallan.contains(c['challan_no']),
                                          onChanged: (value) {
                                            setState(() {
                                            if (selectedChallan.contains(c['challan_no'].toString())) {
                                              selectChallan.value.remove(c['challan_no'].toString());
                                            } else {
                                              selectChallan.value.add(c['challan_no'].toString());
                                            }
                                            });
                                          },),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Challan No: ${c['challan_no']}',
                                                style: const TextStyle(fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Wrap(
                                      runSpacing: 4,
                                      spacing: 16,
                                      children: [
                                        Text('Plant: ${c['plant_name']}'),
                                        Text('Type: ${c['vehicle_type'].toString()=='1'?'Own Vehicle':'Supplier Vehicle'}'),
                                        if(c['vehicle_type'].toString() != '1')
                                          Text('Supplier: ${c['supplier_name']??''}'),
                                        Text('Vehicle No: ${c['vehicle_no']??''}'),
                                        Text('Weight: ${c['weight']}'),
                                        Text('Brass: ${c['brass']}'),
                                        Text('Quary: ${c['mine_name']}'),
                                        Text('Pump To: ${c['pump_to'].toString()=='1'?'Hopper':'Outsite Stock'}'),
                                        Text('Date: ${c['date'].toString().split('-')[2]}/${c['date'].toString().split('-')[1]}/${c['date'].toString().split('-')[0]}'),
                                        Text('Time: ${c['time']}'),
                                        Text('Remark: ${c['remark']}'),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                },
              ),
        );
      },
    );
  }

  Future<void> showDeleteConfirmation(BuildContext context, VoidCallback onDelete) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text('Do you want to delete?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: Text('Cancel', style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
          ),
          SizedBox(width: 30,),
          ValueListenableBuilder(
            valueListenable: isLoadingDelete,
            builder: (context,bool value, child) =>
             ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: onDelete,
              child: value?SizedBox(height: 20,width: 20,child: CircularProgressIndicator(),):Text('Delete',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
