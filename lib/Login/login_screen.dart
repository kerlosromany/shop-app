import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Login/cubit/cubit.dart';
import 'package:shop_app/Login/cubit/states.dart';
import 'package:shop_app/register/register.dart';
import 'package:shop_app/shared_preferences.dart';

import '../components.dart';
import '../home_layout/screens/home_layout.dart';

class LoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState) {
            if (state.loginModel.status) {
              token = state.loginModel.data!.token;
              CacheHelper.saveData(
                      key: 'token', value: state.loginModel.data!.token)
                  .then((value) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => HomeLayout()));
              });
            } else {
              showsnackbar(context, state.loginModel.message, SNACKSTATE.ERROR);
            }
          }
        },
        builder: (context, state) => Scaffold(
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
                        "Login",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Text(
                        "Login now to browse our hot offers!",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
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
                            icon: Icon(ShopLoginCubit.get(context).suffixIcon),
                            onPressed: () {
                              ShopLoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: ShopLoginCubit.get(context).isPassword,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      ConditionalBuilder(
                        condition: state is! ShopLoginLoadingState,
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
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            child: const Text(
                              "Login",
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
                      Row(
                        children: [
                          const Text("Don\'t have an account ? "),
                          const SizedBox(
                            width: 10,
                          ),
                          TextButton(
                            child: const Text(
                              "Register now",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => RegisterScren()));
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
