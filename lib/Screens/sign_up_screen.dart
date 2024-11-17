import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/Screens/login_screen.dart';
import 'package:insta_clone/Widgets/text_input_field.dart';
import 'package:insta_clone/responsive/mobile_screen_layout.dart';
import 'package:insta_clone/responsive/responsive_layout_screen.dart';
import 'package:insta_clone/responsive/web_screen_layout.dart';
import 'package:insta_clone/utils/colors.dart';
import 'package:insta_clone/resources/auth_methods.dart';
import 'package:insta_clone/utils/utils.dart';
import 'package:snackbar/snackbar.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  Uint8List? _image;
  bool _isloading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _userNameController.dispose();
    _bioController.dispose();
  }

  void SelectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  signup() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _userNameController.text.isEmpty ||
        _bioController.text.isEmpty ||
        _image == null) {
      showSnackbar("Please fill all fields and select an image", context);
      return;
    }
    if (!isValidEmail(_emailController.text)) {
      showSnackbar("Enter a valid email", context);
      return;
    }
    setState(() {
      _isloading = true;
    });

    String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _userNameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    if (res == "success") {
      showSnackbar(res, context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout()),
        ),
      );
    } else {
      showSnackbar(res, context);
    }

    setState(() {
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 54,
              ),
              const SizedBox(height: 32),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: _image != null
                        ? MemoryImage(_image!)
                        : const AssetImage("assets/userAvt.png")
                            as ImageProvider,
                  ),
                  Positioned(
                    bottom: -10,
                    right: -5,
                    child: IconButton(
                      onPressed: SelectImage,
                      icon: Icon(
                        Icons.add_a_photo,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              TextInputField(
                textEditingController: _userNameController,
                isPass: false,
                hintText: 'Enter your Username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              TextInputField(
                textEditingController: _emailController,
                isPass: false,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextInputField(
                textEditingController: _passwordController,
                isPass: true,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              TextInputField(
                textEditingController: _bioController,
                isPass: false,
                hintText: 'Enter your bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: signup,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    color: blueColor,
                  ),
                  child: _isloading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have an account?",
                    style: TextStyle(color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    child: const Text(
                      " Log in.",
                      style: TextStyle(
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
