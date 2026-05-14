import 'package:arti_stone_crusher/data/repo/login_repo.dart';
import 'package:arti_stone_crusher/utils/Images.dart';
import 'package:arti_stone_crusher/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/login_bloc/login_bloc.dart';
import '../../bloc/login_bloc/login_event.dart';
import '../../bloc/login_bloc/login_state.dart';
import '../../network/network_config.dart';
import '../../utils/enum.dart';
import '../../utils/utils.dart';
import '../../widget/appButton.dart';
import '../home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late LoginBloc loginBloc;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Username and password required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0
      );
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => const Home()),
      // );
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text("Username and password required")),
      // );
      return;
    }
    setState(() {
      isLoading = true;
    });

    try {
      final dio = Dio();
      final response = await dio.post(
        NetworkConfig.baseUrl + NetworkConfig.loginEndpoint,
        data: FormData.fromMap({
          'username': username,
          'password': password,
        }),
      );

      final data = response.data;
      if (data['result']['success'] == 1) {
        final userData = data['result']['user_data'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('logged_in', true);
        await prefs.setString('user_id', userData['userid']);
        await prefs.setString('user_name', userData['first_name']);
        await prefs.setString('user_email', userData['email']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        Fluttertoast.showToast(msg: data['result']['error_msg'] ?? 'Login failed');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(data['result']['error_msg'] ?? 'Login failed')),
        // );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error: \${e.toString()}");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text("Error: \${e.toString()}")),
      // );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    loginBloc = LoginBloc( loginRepo: LoginRepo());
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('logged_in') ?? false;
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context)=>loginBloc,
        child: Container(
          height: 1.sh,
          width: 1.sw,
          decoration: BoxDecoration(
              image: DecorationImage(image:  AssetImage(Images.loginBg),fit: BoxFit.cover )
          ),
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
            Positioned(
              left: 0.22.sw,
              child: Center(
                child: Padding(
                  padding:  EdgeInsets.only(top: 0.2.sh),
                  child: Text(
                  'Abhay Stone Crusher',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),),
                ),
              ),
            ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 0.7.sh,
                  width: 1.sw,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Container(
                    decoration:  BoxDecoration(
                        image: DecorationImage(image: AssetImage(Images.loginBg),fit: BoxFit.cover)
                    ),

                    child: Container(
                      height: 0.7.sh,
                      width: 1.sw,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Image.asset(
                            Images.logo,
                            height: 100,
                          ),
                          const SizedBox(height: 40),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Column(
                              children: [
                                BlocBuilder<LoginBloc, LoginState>(
                                  buildWhen: (previous,current)=>previous.emailId != current.emailId,
                                    builder: (context, state) {
                                    return  _buildInputField(_usernameController, 'EMAIL ADDRESS', Icons.email,onChanged: (value) {
                                      loginBloc.add(EmailChange(emailId: value));
                                    },
                                    );
                                    },)
                               ,
                                const SizedBox(height: 20),

                                BlocBuilder<LoginBloc, LoginState>(
                                  buildWhen: (previous,current)=>previous.password != current.password,
                                  builder: (context, state) {
                                    return  _buildInputField(_passwordController, 'PASSWORD', Icons.lock,
                                        obscure: !isPasswordVisible,
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.orange),
                                          onPressed: () {
                                            setState(() => isPasswordVisible = !isPasswordVisible);
                                          },
                                        ),
                                    onChanged: (value) {
                                      loginBloc.add(PasswordChange(password: value));
                                      },
                                    );
                                  },),


                                // const SizedBox(height: 10),
                                // Align(
                                //   alignment: Alignment.centerRight,
                                //   child: Text(
                                //     'Forget Password?',
                                //     style: TextStyle(color: Colors.grey[600]),
                                //   ),
                                // ),
                                const SizedBox(height: 30),
                                BlocListener<LoginBloc, LoginState>(
                                  listenWhen: (previous, current) => previous.loginApiStatus != current.loginApiStatus,
                                  listener: (context, state) {
                                    if(state.loginApiStatus == ApiStatus.error){
                                      Utils.showFlushBar(state.error, FlushBarType.error, context);
                                    }
                                    if(state.loginApiStatus == ApiStatus.success){
                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home()), (route) => false);
                                      Utils.showFlushBar(state.successMsg, FlushBarType.success, context);
                                    }
                                  },
                                  child: BlocBuilder<LoginBloc, LoginState>(
                                    buildWhen: (previous, current) => previous.loginApiStatus != current.loginApiStatus,
                                    builder: (context, state) {
                                      return AppButton(
                                        text: "Login",
                                        onPressed: () {
                                          loginBloc.add(LoginWithEmailPassword());
                                        },
                                        isLoading: state.loginApiStatus == ApiStatus.loading,
                                      );
                                    },
                                  ),
                                  //
                                  // SizedBox(
                                  //   width: double.infinity,
                                  //   height: 50,
                                  //   child: ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //       backgroundColor: K.darkOrange,
                                  //       shape: RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.circular(10),
                                  //       ),
                                  //     ),
                                  //     onPressed: isLoading ? null : _login,
                                  //     child: isLoading
                                  //         ? const CircularProgressIndicator(color: Colors.white)
                                  //         : const Text('Log In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white)),
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )



            ],
          ),
        ),
      )

      // Container(
      //   height: 1.sh,
      //   width: 1.sw,
      //   decoration:  BoxDecoration(
      //       image: DecorationImage(image: AssetImage(Images.loginBg),fit: BoxFit.cover)
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //        SizedBox(height: 0.2.sh),
      //       const Text(
      //         'Arti Stone Crusher',
      //         style: TextStyle(
      //           fontSize: 24,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.white,
      //         ),
      //       ),
      //
      //     ],
      //   ),
      // ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon,
      {bool obscure = false, Widget? suffixIcon,ValueChanged<String>? onChanged }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: K.darkOrange),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: K.darkOrange),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:  BorderSide(color: K.darkOrange),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
