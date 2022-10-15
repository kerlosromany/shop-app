import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/shared_preferences.dart';

import 'Login/login_screen.dart';
import 'home_layout/cubits/shop_cubit/cubit.dart';
import 'models/get_favorites.dart';

void showsnackbar(context, String text, SNACKSTATE state) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: chooseColor(state),
    ));

enum SNACKSTATE { SUCCESS, ERROR, WARNING }

Color chooseColor(SNACKSTATE state) {
  Color color;
  switch (state) {
    case SNACKSTATE.SUCCESS:
      color = Colors.green;
      break;
    case SNACKSTATE.ERROR:
      color = Colors.red;
      break;
    case SNACKSTATE.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

String? token = '';

signOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  });
}

Widget buildFavSearchItem(model, context) => ConditionalBuilder(
      condition: model != null,
      builder: (context) => Container(
        height: 120,
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  image: NetworkImage("${model.image}"),
                  width: 120,
                  height: 120.0,
                  fit: BoxFit.cover,
                ),
                if (model.discount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: const Text(
                      "DISCOUNT",
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
              ],
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${model.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.3,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Text(
                        model.price.toString(),
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      if (model.discount != null)
                        Text(
                          model.oldPrice.toString(),
                          style: const TextStyle(
                            fontSize: 10.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          ShopCubit.get(context)
                              .changeFavorites(model.id as int);
                        },
                        icon: CircleAvatar(
                          backgroundColor:
                              ShopCubit.get(context).favorites[model.id]!
                                  ? Colors.deepOrange
                                  : Colors.grey,
                          radius: 15.0,
                          child: const Icon(
                            Icons.favorite_border,
                            size: 12.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      fallback: (context) => const Center(
          child: Text(
        "No Favourites Data",
        style: TextStyle(color: Colors.black),
      )),
    );
