
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/Images.dart';
import '../../widget/background.dart';
import '../auth/login.dart';
import '../screens/add_inward_challan.dart';
import '../screens/challan_list.dart';
import '../screens/create_challan.dart';
import '../screens/create_invoice.dart';
import '../screens/inovice_list.dart';
import '../screens/inward_challan_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        mainContent: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavCard(context, 'Create Challan', AppIcon.createChallan, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateChallan()));
                  }),
                  _buildNavCard(context, 'Challan List', AppIcon.createList, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChallanList()));
                  }),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavCard(context, 'Add Inward Challan', AppIcon.inwardChallan, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AddInwardChallan()));
                  }),
                  _buildNavCard(context, 'Inward Challan List', AppIcon.createList, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InwardChallanList()));
                  }),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavCard(context, 'Create Invoice', Images.invoiceList, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateInvoice()));
                  }),
                  _buildNavCard(context, 'Invoice List', AppIcon.createList, () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const InvoiceList()));
                  }),
                ],
              ),
            ],
          )
        ),
        topWidget: Padding(
          padding:  EdgeInsets.only(top: 0.05.sh,right: 15,left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dashboard',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 20),),
              IconButton(
                icon: const Icon(Icons.logout,color: Colors.white,),
                tooltip: 'Logout',
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
            ],
          ),
        )
      ),
    );
    //   Scaffold(
    //   bottomNavigationBar: Container(
    //     decoration:  BoxDecoration(
    //         image: DecorationImage(image: AssetImage(Images.loginBg),fit: BoxFit.cover)
    //     ),
    //
    //     child: Container(
    //       height: 0.7.sh,
    //       width: 1.sw,
    //       decoration: BoxDecoration(
    //         color: Colors.white,
    //         borderRadius: BorderRadius.only(
    //           topLeft: Radius.circular(40),
    //           topRight: Radius.circular(40),
    //         ),
    //       ),
    //       child: Padding(
    //         padding: const EdgeInsets.all(16.0),
    //         child: GridView.count(
    //           crossAxisCount: 2,
    //           mainAxisSpacing: 16,
    //           crossAxisSpacing: 16,
    //           children: [
    //             _buildNavCard(context, 'Create Challan', Icons.playlist_add, () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateChallan()));
    //             }),
    //             _buildNavCard(context, 'Challan List', Icons.list_alt, () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => const ChallanList()));
    //             }),
    //             _buildNavCard(context, 'Add Inward Challan', Icons.add_business, () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => const AddInwardChallan()));
    //             }),
    //             _buildNavCard(context, 'Inward Challan List', Icons.inventory_2, () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => const InwardChallanList()));
    //             }),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    //   // backgroundColor: Color(0xffFF8F33),
    //   // appBar: AppBar(
    //   //   backgroundColor: Color(0xffFF8F33),
    //   //   title: const Text("Dashboard",),
    //   //   actions: [
    //   //     // IconButton(
    //   //     //   icon: const Icon(Icons.person),
    //   //     //   tooltip: 'Profile',
    //   //     //   onPressed: () {
    //   //     //     // Navigate to profile page
    //   //     //   },
    //   //     // ),
    //   //
    //   //   ],
    //   // ),
    //   body: Container(
    //     height: 1.sh,
    //     width: 1.sw,
    //     decoration:  BoxDecoration(
    //         image: DecorationImage(image: AssetImage(Images.loginBg),fit: BoxFit.cover)
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         SizedBox(height: 0.1.sh),
    //         Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 10),
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //             children: [
    //               Text('Dashboard',style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 20),),
    //               IconButton(
    //                 icon: const Icon(Icons.logout),
    //                 tooltip: 'Logout',
    //                 onPressed: () async {
    //                   final prefs = await SharedPreferences.getInstance();
    //                   await prefs.clear();
    //                   Navigator.pushReplacement(
    //                     context,
    //                     MaterialPageRoute(builder: (context) => const Login()),
    //                   );
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //
    //       ],
    //     ),
    //   ),
    //
    // );
  }

  Widget _buildNavCard(BuildContext context, String title, String icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 0.45.sw,
        height: 0.2.sh,
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                      color: Color(0xffFF811A),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(icon,height: 50,width: 50,color: Colors.white,),
                      )),
                  // Icon(icon, size: 40, color: Colors.blue),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}