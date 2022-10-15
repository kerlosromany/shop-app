import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/cubit.dart';
import 'package:shop_app/home_layout/cubits/shop_cubit/states.dart';

import '../../components.dart';
import '../../models/categories_model.dart';
import '../../models/home_data.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesStates) {
          if (!state.model.status!) {
            showsnackbar(context, state.model.message!, SNACKSTATE.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeDataModel != null &&
              ShopCubit.get(context).categoriesModel != null,
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
          builder: (context) => productBuilder(
              ShopCubit.get(context).homeDataModel as HomeDataModel,
              ShopCubit.get(context).categoriesModel as CategoriesModel,
              context),
        );
      },
    );
  }

  Widget productBuilder(
      HomeDataModel model, CategoriesModel categoriesModel, context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CarouselSlider(
            items: model.data!.banners
                .map((e) => Image(
                      image: NetworkImage(e.image),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ))
                .toList(),
            options: CarouselOptions(
              height: 230.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(seconds: 1),
              enableInfiniteScroll: true,
              autoPlayCurve: Curves.easeInOut,
              initialPage: 0,
              viewportFraction: 1.0,
              reverse: false,
              scrollDirection: Axis.horizontal,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Categories",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20.0),
                Container(
                  height: 120,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ListView.separated(
                    itemBuilder: (context, index) =>
                        buildCategoryProduct(categoriesModel.data!.data[index]),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10.0),
                    itemCount: categoriesModel.data!.data.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  "New Products",
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10.0),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              children: List.generate(
                  model.data!.products.length,
                  (index) =>
                      buildGridProduct(model.data!.products[index], context)),
              childAspectRatio: 1 / 1.5,
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGridProduct(Products model, context) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Image(
                  height: 200,
                  image: NetworkImage(model.image),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                if (model.discount != null)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(5.0),
                    child: const Text(
                      "DISCOUNT",
                      style: TextStyle(fontSize: 10.0),
                    ),
                  ),
              ],
            ),
            Text(
              model.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
              ),
            ),
            Row(
              children: [
                Text(
                  '${model.price}',
                  style: const TextStyle(
                      fontSize: 14, height: 1.4, color: Colors.blueAccent),
                ),
                const SizedBox(
                  width: 8.0,
                ),
                if (model.discount != null)
                  Text(
                    '${model.oldPrice}',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough),
                  ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    ShopCubit.get(context).changeFavorites(model.id);
                  },
                  icon: CircleAvatar(
                    radius: 15.0,
                    backgroundColor: ShopCubit.get(context).favorites[model.id]!
                        ? Colors.blueAccent
                        : Colors.grey,
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget buildCategoryProduct(Datamodel model) => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Image(
            image: NetworkImage(model.image),
            width: 120,
            height: 120,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              model.name,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
}
