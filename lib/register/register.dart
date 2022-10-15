import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components.dart';
import 'package:shop_app/register/cubit/states.dart';
import 'package:shop_app/shared_preferences.dart';

import '../home_layout/screens/home_layout.dart';
import 'cubit/cubit.dart';

class RegisterScren extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterSuccessState) {
            if (state.registerModel.status!) {
              CacheHelper.saveData(
                key: 'token',
                value: state.registerModel.data!.token,
              ).then((value) {
                token = state.registerModel.data!.token;
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HomeLayout()));
              });
            } else {
              showsnackbar(
                  context, state.registerModel.message!, SNACKSTATE.ERROR);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Register",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text(
                          "Register now to browse our hot offers!",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: nameController,
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Name does not validate please try again";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("User Name"),
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return "Email does not validate please try again";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Email Address"),
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Password must be at least 8 characters";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: const Text("Password"),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(RegisterCubit.get(context).suffixIcon),
                              onPressed: () {
                                RegisterCubit.get(context).changePassword();
                              },
                            ),
                            border: const OutlineInputBorder(),
                          ),
                          obscureText: RegisterCubit.get(context).isPassword,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Phone does not validate please try again";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            label: Text("Phone"),
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! RegisterLoadingState,
                          builder: (context) => Container(
                            width: double.infinity,
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue,
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  RegisterCubit.get(context).userRegister(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    name: nameController.text,
                                    phone: phoneController.text,
                                  );
                                }
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          fallback: (context) =>
                              const Center(child: CircularProgressIndicator()),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
