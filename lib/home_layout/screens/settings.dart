import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/components.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/cubit.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/states.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessUserDataStates) {}
      },
      builder: (context, state) {
        var model = ShopCubit.get(context).userData;
        nameController.text = model!.data!.name as String;
        emailController.text = model.data!.email as String;
        phoneController.text = model.data!.phone as String;

        return ConditionalBuilder(
          condition: ShopCubit.get(context).userData != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  if(state is ShopLoadingUpdateDataStates)
                    const LinearProgressIndicator(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("User Name"),
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Name must be not empty";
                      }
                      return null;
                    },
                    controller: nameController,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Email Address"),
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Email must be not empty";
                      }
                      return null;
                    },
                    controller: emailController,
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Phone"),
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Phone must be not empty";
                      }
                      return null;
                    },
                    controller: phoneController,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blueAccent,
                    ),
                    child: MaterialButton(
                      child: const Text(
                        "Update",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          ShopCubit.get(context).updateUserData(
                            name: nameController.text,
                            email: emailController.text,
                            phone: phoneController.text,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 40.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.blueAccent,
                    ),
                    child: MaterialButton(
                      child: const Text(
                        "LogOut",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        signOut(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
