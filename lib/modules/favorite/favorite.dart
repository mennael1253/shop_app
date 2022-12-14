import 'package:e_commerce_payment/modeles/favorites_model/favorites_model.dart';
import 'package:e_commerce_payment/shared/cubits/ecommerce_cubit/ecommerce_cubit.dart';
import 'package:e_commerce_payment/shared/cubits/ecommerce_cubit/ecommerce_states.dart';
import 'package:e_commerce_payment/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';


class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ECommerceCubit, ECommerceStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional.single(
            context: context,
            conditionBuilder: (context) =>
                ECommerceCubit.get(context).favoriteModel != null,
            fallbackBuilder: (context) => Center(
                  child: CircularProgressIndicator(
                    color: defaultColor,
                  ),
                ),
            widgetBuilder: (context) {
              return (ECommerceCubit.get(context)
                      .favoriteModel!
                      .data
                      .data
                      .isEmpty)
                  ? const Center(
                      child: Text('No Favorites, add more'),
                    )
                  : ListView.separated(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => productBuilder(
                          ECommerceCubit.get(context)
                              .favoriteModel!
                              .data
                              .data[index],
                          context),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10,
                          ),
                      itemCount: ECommerceCubit.get(context)
                          .favoriteModel!
                          .data
                          .data
                          .length);
            });
      },
    );
  }
}

Widget productBuilder(FavoritesData model, context) => Container(
      height: 140,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomStart,
              children: [
                Image(
                  image: NetworkImage(model.product.image),
                  height: 140,
                  width: 140,
                ),
                if ((model.product.discount != 0))
                  Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        'Discount ',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                    " ${model.product.name} ",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Text(
                        '${model.product.price.round()}',
                        style: TextStyle(
                            fontSize: 12, height: 1.5, color: defaultColor),
                      ),
                      SizedBox(width: 5),
                      if (model.product.discount != 0)
                        Text(
                          '${model.product.oldPrice.round()}',
                          style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough),
                        ),
                      Spacer(),
                      CircleAvatar(
                        backgroundColor: ECommerceCubit.get(context)
                                    .favorite[model.product.id] !=
                                null
                            ? defaultColor
                            : Colors.grey,
                        radius: 15,
                        child: IconButton(
                          onPressed: () {
                            ECommerceCubit.get(context)
                                .changeFavorite(model.product.id);
                            print('model.id');
                          },
                          icon: Icon(
                            Icons.star_border_outlined,
                            color: Colors.white,
                          ),
                          iconSize: 14,
                        ),
                      ),
                    ],
                  )
                ]))
          ],
        ),
      ),
    );
