import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zezo/components/button.dart';
import 'package:zezo/screens/askfororder/controller.dart';

import '../../components/textfield.dart';
import 'state.dart';

class AskForOrderScreen extends StatelessWidget {
  const AskForOrderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AskForOrderController()..initialData(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Ask",
              style: TextStyle(
                  fontFamily: "One", fontSize: size.shortestSide * .09)),
          toolbarHeight: size.longestSide * .07,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Theme.of(context).primaryColor],
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                AwesomeDialog(
                  context: context,
                  body: Padding(
                    padding: EdgeInsets.all(size.shortestSide * .03),
                    child: Text(
                        "Write down your order and we will contact you as soon as possible.",
                        style: TextStyle(
                            fontSize: size.shortestSide * .055,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500)),
                  ),
                ).show();
              },
              icon: const Icon(
                Icons.help,
                color: Colors.white,
              ),
            ),
          ],
        ),
        body: BlocBuilder<AskForOrderController, AskForOrderState>(
          builder: (context, state) {
            final controller = AskForOrderController.get(context);
            return Form(
              key: controller.validation.formKey,
              child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.shortestSide * .04,
                      vertical: size.longestSide * .02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldItem(
                        onValid: (val) => controller.validation.ask(val),
                        controller: controller.orderController,
                        icon: Icons.backpack_rounded,
                        lable: "Order",
                        size: size,
                      ),
                      TextFieldItem(
                        onValid: (val) => controller.validation.name(val),
                        controller: controller.fullNameController,
                        icon: Icons.backpack_rounded,
                        lable: "Full Name",
                        size: size,
                      ),
                      TextFieldItem(
                        onValid: (val) => controller.validation.email(val),
                        controller: controller.emailController,
                        icon: Icons.email,
                        lable: "Email",
                        size: size,
                      ),
                      TextFieldItem(
                        onValid: (val) =>
                            controller.validation.phoneNumber(val),
                        controller: controller.phoneController,
                        type: TextInputType.number,
                        icon: Icons.phone,
                        lable: "Phone",
                        size: size,
                      ),
                      TextFieldItem(
                        lines: 3,
                        onValid: (val) => controller.validation.address(val),
                        controller: controller.addressController,
                        icon: Icons.home,
                        lable: "Address",
                        size: size,
                      ),
                      TextFieldItem(
                        onValid: (val) =>
                            controller.validation.descrtiption(val),
                        controller: controller.descriptionController,
                        icon: Icons.description,
                        lable: "Description",
                        lines: 3,
                        size: size,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: size.longestSide * .05),
                        child: controller.isClick
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ButtonItem(
                                onPressed: () {
                                  if (controller
                                      .validation.formKey.currentState!
                                      .validate()) {
                                    controller.addSpecialOrder();
                                  }
                                },
                                name: "Order Now",
                              ),
                      )
                    ],
                  )),
            );
          },
        ),
      ),
    );
  }
}
