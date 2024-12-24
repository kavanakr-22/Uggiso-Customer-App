import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import '../../Bloc/HomeBloc/HomeBloc.dart';
import '../../Bloc/HomeBloc/HomeEvent.dart';
import '../../Bloc/HomeBloc/HomeState.dart';
import '../../app_routes.dart';
import '../../base/common/utils/MenuListArgs.dart';
import '../../base/common/utils/fonts.dart';

class HotelListGrid extends StatelessWidget {
  final List<dynamic>? payload;
  final String? userId;
  final double? lat;
  final double? lng;
  final String? travelMode;
  final double? distance;

  HotelListGrid(this.payload,this.userId, this.lat,this.lng,this.travelMode,this.distance,{super.key});

  final List<String> items = List.generate(10, (index) => 'Item $index');
  final HomeBloc _homeBloc = HomeBloc();
  bool _isFavAdded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _homeBloc,
      child: BlocListener<HomeBloc,HomeState>(
        listener: (BuildContext context, HomeState state) {
          if(state is onFavHotelAddedState){
            print('fav hotel added form grid  lat ');

            updateHotelData(userId!, lat!, lng!, distance!, travelMode!);
          }
          if(state is onFavHotelDeleteState){
            print('fav hotel deleted form grid  lat ');
            updateHotelData(userId!, lat!, lng!, distance!, travelMode!);

          }
          if(state is onLoadedHotelState){
            print('this is loaded state : ${state.data.payload?.first.favourite}');
          }
        },
        child: BlocBuilder<HomeBloc,HomeState>(
          builder: (context,state) {
            if(state is LoadingHotelState){
              return Center(child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),);
            }
            else if(state is onLoadedHotelState){
              return GridView.builder(

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount:state.data.payload?.length,
                itemBuilder: (context, index) {
                  return GridItem(context, state.data.payload?[index]);
                },
              );
            }
              else{
              return GridView.builder(

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemCount: payload?.length,
                itemBuilder: (context, index) {
                  return GridItem(context, payload?[index]);
                },
              );
            }

          }
        ),
      ),
    );
  }
  Widget GridItem(BuildContext c, Payload? item) => RoundedContainer(
      width: MediaQuery.of(c).size.width * 0.5,
      color: AppColors.white,
      borderColor: AppColors.white,
      cornerRadius: 8,
      padding: 0,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          c,
          AppRoutes.menuList,
          arguments: MenuListArgs(
            restaurantId: item!.restaurantId,
            name: item.restaurantName,
            foodType: item.restaurantMenuType,
            ratings: item.ratings,
            landmark: item.landmark,
            distance: item.distance,
            duration: item.duration,
            payload: item,
          ),
        ),
        child: Column(
          children: [
            // Using Stack for the image and the top-right icon
            Stack(
              children: [
                // Image
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(c).size.height * 0.1,
                  child: Image.network(
                    item!.imageUrl.toString(),
                    fit: BoxFit.fitWidth,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.2,
                        height: MediaQuery.of(context).size.height * 0.08,
                        child: Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 60,
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Top-right icon
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      // Handle icon click event
                      print('Top-right icon clicked for ${item.restaurantName}');
                    },
                    child: item.favourite == true
                        ? IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _homeBloc.add(OnDeleteFavRestaurant(
                            userId: userId,
                            restaurantId: item.restaurantId));
                      },
                      icon: Image.asset(
                        'assets/ic_heart_fill.png',
                        width: 24,
                        height: 24,
                        color: AppColors.appPrimaryColor,
                      ),
                    )
                        : IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        _homeBloc.add(OnAddFavRestaurant(
                            userId: userId,
                            restaurantId: item?.restaurantId));
                      },
                      icon: Image.asset(
                        'assets/ic_heart.png',
                        width: 24,
                        height: 24,
                        color: AppColors.appPrimaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Details Section
            Container(
              width: MediaQuery.of(c).size.width * 0.42,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(4),
                  item?.restaurantName == null
                      ? Container()
                      : Text(
                    '${item?.restaurantName}',
                    style: AppFonts.title.copyWith(
                        color: AppColors.bottomTabInactiveColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(4),
                  Row(
                    children: [
                      item?.restaurantMenuType == null
                          ? Container()
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          item?.restaurantMenuType == 'VEG'
                              ? Image.asset(
                            'assets/ic_veg.png',
                            height: 12,
                            width: 12,
                          )
                              : Image.asset(
                            'assets/ic_non_veg.png',
                            height: 12,
                            width: 12,
                          ),
                          const Gap(4),
                          Text(
                            '${item?.restaurantMenuType}',
                            style: AppFonts.smallText
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          item?.ratings == null
                              ? Container()
                              : Row(
                            children: [
                              Image.asset(
                                'assets/ic_star.png',
                                height: 14,
                                width: 14,
                              ),
                              Text('${item?.ratings}',
                                  style: AppFonts.smallText.copyWith(
                                      color: AppColors.textColor)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(8),
                  item?.distance == null || item?.duration == null
                      ? Container()
                      : Row(
                    children: [
                      Image.asset(
                        'assets/ic_small_marker.png',
                        height: 12,
                        width: 12,
                      ),
                      Gap(4),
                      Text('${item?.distance} | ',
                          style: AppFonts.smallText
                              .copyWith(color: AppColors.textGrey)),
                      Gap(4),
                      Image.asset(
                        'assets/ic_clock.png',
                        height: 12,
                        width: 12,
                      ),
                      Gap(4),
                      Text('${item?.duration}',
                          style: AppFonts.smallText
                              .copyWith(color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ));

  updateHotelData(String userId,double lat, double lng, double distance,String mode){
    _homeBloc.add(
        OnUpdateFavOrder(userId:userId,lat: lat, lag: lng, distance: distance,mode: mode));  }
}
