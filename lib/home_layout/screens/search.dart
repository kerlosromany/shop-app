import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/home_data.dart';
import 'package:shop_app/search/cubit/states.dart';
import 'package:shop_app/search/search_model.dart';

import '../../components.dart';
import '../../models/get_favorites.dart';
import '../../search/cubit/cubit.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        label: Text("Search"),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "enter a text to search";
                        }
                        return null;
                      },
                      onFieldSubmitted: (String text) {
                        SearchCubit.get(context).getSearchData(text);
                      },
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    if (state is SearchLoadingStates)
                      const LinearProgressIndicator(),
                    if (state is SearchSuccessStates)
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) => buildFavSearchItem(
                              SearchCubit.get(context)
                                  .searchModel!
                                  .data!
                                  .data![index],
                              context),
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.grey),
                          itemCount: SearchCubit.get(context)
                              .searchModel!
                              .data!
                              .data!
                              .length,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
