import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/screens/forgetpassword/controller.dart';

import '../../components/button.dart';
import '../../components/textfield.dart';
import 'states.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => ForgetPasswordController(),
      child: SafeArea(
          child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: size.shortestSide * .08,
                    )),
              ),
              body: BlocBuilder<ForgetPasswordController, ForgetPasswordStates>(
                builder: (context, state) {
                  final controller = ForgetPasswordController.get(context);
                  return Form(
                    key: controller.validation.formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: size.shortestSide * .04,
                          vertical: size.longestSide * .04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: size.longestSide * .09,
                          ),
                          SizedBox(
                            height: size.longestSide * .24,
                            child: Center(
                              child: Text(
                                "Forget Password",
                                style: TextStyle(
                                    fontSize: size.shortestSide * .09,
                                    fontFamily: "One"),
                              ),
                            ),
                          ),
                          TextFieldItem(
                            onValid: (val) => controller.validation.email(val),
                            controller: controller.emailController,
                            icon: Icons.email,
                            lable: "Email",
                            size: size,
                          ),
                          SizedBox(
                            height: size.longestSide * .05,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: size.longestSide * .01,
                              horizontal: size.shortestSide * .07,
                            ),
                            child: ButtonItem(
                              name: "Confirm",
                              onPressed: () {
                                if (controller.validation.formKey.currentState!
                                    .validate()) {
                                  controller.getPassword(context, size);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))),
    );
  }
}
