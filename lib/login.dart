import 'dart:convert';
import 'package:flutter_dealxemay_2024/home.dart';
import 'package:flutter_dealxemay_2024/navigator.dart';
import 'package:flutter_dealxemay_2024/services/toastCustom.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './services/globals.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  late bool _rememberMe = false;
  late bool _obscureText = true;
  late String token = '';

  @override
  void initState() {
    super.initState();
    loadUserCredentials();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> loadUserCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      username.text = prefs.getString('username') ?? '';
      password.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('remember_me') ?? false;
    });
  }

  // ham login
  void login() {
    String userName = username.text;
    String passWord = password.text;
    if (userName.isNotEmpty && passWord.isNotEmpty) {
      authLogin(userName, passWord);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: const Text('Vui lòng nhập đầy đủ thông tin.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> authLogin(username, password) async {
    var queryParameters = {
      'username': username,
      'password': password,
      'token': token
    };

    var uri =
        Uri.parse('${urlApi}login').replace(queryParameters: queryParameters);

    try {
      var response =
          await http.get(uri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (!mounted) return;
        if (data['isError'] == false) {        
          saveUserCredentials(username, password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavigatorWiget()),
          );
        } else {      
          ToastsCustom.showToastError(data['message'], context);
        }
      } else {
        if (!mounted) return;    
        ToastsCustom.showToastError('Không thể đăng nhập vào tài khoản', context);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: ${error.toString()}')),
      );
       ToastsCustom.showToastError('Lỗi: ${error.toString()}', context);
    }
  }

  Future<void> saveUserCredentials(username, password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
    if (_rememberMe) {
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.setBool('remember_me', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: width * 0.1),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
              height: height * 0.35,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: height * 0.3,
                    child: Image.asset('assets/images/login.jpg'),
                  ),
                  const Positioned(
                    bottom: 0,
                    child: Column(
                      children: [
                        Text("WELCOME BACK !!!",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            )),
                        Text(
                          "Vui lòng đăng nhập để sử dụng phần mềm",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: height * 0.03),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: height * 0.07,
              child: TextFormField(
                controller: username,
                decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 173, 218, 255),
                    filled: true,
                    hintText: "Tài khoản",
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    prefixIcon: const Icon(
                      Icons.people,
                      color: Colors.white,
                      size: 18,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white))),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: height * 0.07,
              child: TextFormField(
                obscureText: _obscureText,
                controller: password,
                decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 173, 218, 255),
                    filled: true,
                    hintText: "Mật khẩu",
                    hintStyle:
                        const TextStyle(color: Colors.white, fontSize: 16),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40),
                        borderSide: const BorderSide(color: Colors.white))),
              ),
            ),
          ),
          SizedBox(height: height * 0.01),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                    value: _rememberMe,
                    onChanged: (value) {
                      setState(() {
                        _rememberMe = value!;
                      });
                    }),
                const Text("Lưu đăng nhập")
              ],
            ),
          ),        
          SizedBox(height: height * 0.01),
          SizedBox(
            height: 55,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: MaterialButton(
                  onPressed: login,
                  color: const Color.fromARGB(255, 1, 149, 247),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                        size: 22,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        child: Text(
                          "ĐĂNG NHẬP",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
        ],
      ),
    );
  }
}
