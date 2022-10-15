import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/cubit.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/states.dart';

import '../../components.dart';
import '../../models/get_favorites.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavoritesStates,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildFavSearchItem(
                ShopCubit.get(context).getFavoritesModel!.data!.data![index].product as Product,
                context),
            separatorBuilder: (context, index) =>
                const Divider(color: Colors.grey),
            itemCount:
                ShopCubit.get(context).getFavoritesModel!.data!.data!.length,
          ),
          fallback: (context) =>const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

}
