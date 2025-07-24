// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:uggiso/Model/GetNearByResaturantModel.dart';
// import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
// import 'package:uggiso/base/common/utils/colors.dart';
// import '../../Bloc/HomeBloc/HomeBloc.dart';
// import '../../Bloc/HomeBloc/HomeEvent.dart';
// import '../../Bloc/HomeBloc/HomeState.dart';
// import '../../app_routes.dart';
// import '../../base/common/utils/MenuListArgs.dart';
// import '../../base/common/utils/fonts.dart';

// class HotelListGrid extends StatelessWidget {
//   final List<dynamic>? payload;
//   final String? userId;
//   final double? lat;
//   final double? lng;
//   final String? travelMode;
//   final double? distance;

//   HotelListGrid(this.payload,this.userId, this.lat,this.lng,this.travelMode,this.distance,{super.key});

//   final List<String> items = List.generate(10, (index) => 'Item $index');
//   final HomeBloc _homeBloc = HomeBloc();
//   bool _isFavAdded = false;

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => _homeBloc,
//       child: BlocListener<HomeBloc,HomeState>(
//         listener: (BuildContext context, HomeState state) {
//           if(state is onFavHotelAddedState){
//             print('fav hotel added form grid  lat ');

//             updateHotelData(userId!, lat!, lng!, distance!, travelMode!);
//           }
//           if(state is onFavHotelDeleteState){
//             print('fav hotel deleted form grid  lat ');
//             updateHotelData(userId!, lat!, lng!, distance!, travelMode!);

//           }
//           if(state is onLoadedHotelState){
//             print('this is loaded state : ${state.data.payload?.first.favourite}');
//           }
//         },
//         child: BlocBuilder<HomeBloc,HomeState>(
//           builder: (context,state) {
//             if(state is LoadingHotelState){
//               return Center(child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),);
//             }
//             else if(state is onLoadedHotelState){
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.9,
//                 ),
//                 itemCount:state.data.payload?.length,
//                 itemBuilder: (context, index) {
//                   return GridItem(context, state.data.payload?[index]);
//                 },
//               );
//             }
//               else{
//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 10,
//                   mainAxisSpacing: 10,
//                   childAspectRatio: 0.9,
//                 ),
//                 itemCount: payload?.length,
//                 itemBuilder: (context, index) {
//                   return GridItem(context, payload?[index]);
//                 },
//               );
//             }

//           }
//         ),
//       ),
//     );
//   }
//   Widget GridItem(BuildContext c, Payload? item) => RoundedContainer(
//       width: MediaQuery.of(c).size.width * 0.5,
//       color: AppColors.white,
//       borderColor: AppColors.white,
//       cornerRadius: 8,
//       padding: 0,
//       child: InkWell(
//         onTap: () => Navigator.pushNamed(
//           c,
//           AppRoutes.menuList,
//           arguments: MenuListArgs(
//             restaurantId: item!.restaurantId,
//             name: item.restaurantName,
//             foodType: item.restaurantMenuType,
//             ratings: item.ratings,
//             landmark: item.landmark,
//             distance: item.distance,
//             duration: item.duration,
//             payload: item,
//           ),
//         ),
//         child: Column(
//           children: [
//             // Using Stack for the image and the top-right icon
//             Stack(
//               children: [
//                 // Image
//                 Container(
//                   width: double.infinity,
//                   height: MediaQuery.of(c).size.height * 0.1,
//                   child: Image.network(
//                     item!.imageUrl.toString(),
//                     fit: BoxFit.fitWidth,
//                     errorBuilder: (BuildContext context, Object exception,
//                         StackTrace? stackTrace) {
//                       return SizedBox(
//                         width: MediaQuery.of(context).size.width * 0.2,
//                         height: MediaQuery.of(context).size.height * 0.08,
//                         child: Center(
//                           child: Icon(
//                             Icons.broken_image,
//                             size: 60,
//                             color: AppColors.grey,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // Top-right icon
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: InkWell(
//                     onTap: () {
//                       // Handle icon click event
//                       print('Top-right icon clicked for ${item.restaurantName}');
//                     },
//                     child: item.favourite == true
//                         ? IconButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         _homeBloc.add(OnDeleteFavRestaurant(
//                             userId: userId,
//                             restaurantId: item.restaurantId));
//                       },
//                       icon: Image.asset(
//                         'assets/ic_heart_fill.png',
//                         width: 24,
//                         height: 24,
//                         color: AppColors.appPrimaryColor,
//                       ),
//                     )
//                         : IconButton(
//                       padding: EdgeInsets.zero,
//                       onPressed: () {
//                         _homeBloc.add(OnAddFavRestaurant(
//                             userId: userId,
//                             restaurantId: item?.restaurantId));
//                       },
//                       icon: Image.asset(
//                         'assets/ic_heart.png',
//                         width: 24,
//                         height: 24,
//                         color: AppColors.appPrimaryColor,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             // Details Section
//             Container(
//               width: MediaQuery.of(c).size.width * 0.42,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Gap(4),
//                   item?.restaurantName == null
//                       ? Container()
//                       : Text(
//                     '${item?.restaurantName}',
//                     style: AppFonts.title.copyWith(
//                         color: AppColors.bottomTabInactiveColor),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const Gap(4),
//                   Row(
//                     children: [
//                       item?.restaurantMenuType == null
//                           ? Container()
//                           : Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           item?.restaurantMenuType == 'VEG'
//                               ? Image.asset(
//                             'assets/ic_veg.png',
//                             height: 12,
//                             width: 12,
//                           )
//                               : Image.asset(
//                             'assets/ic_non_veg.png',
//                             height: 12,
//                             width: 12,
//                           ),
//                           const Gap(4),
//                           Text(
//                             '${item?.restaurantMenuType}',
//                             style: AppFonts.smallText
//                                 .copyWith(fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           item?.ratings == null
//                               ? Container()
//                               : Row(
//                             children: [
//                               Image.asset(
//                                 'assets/ic_star.png',
//                                 height: 14,
//                                 width: 14,
//                               ),
//                               Text('${item?.ratings}',
//                                   style: AppFonts.smallText.copyWith(
//                                       color: AppColors.textColor)),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Gap(8),
//                   item?.distance == null || item?.duration == null
//                       ? Container()
//                       : Row(
//                     children: [
//                       Image.asset(
//                         'assets/ic_small_marker.png',
//                         height: 12,
//                         width: 12,
//                       ),
//                       Gap(4),
//                       Text('${item?.distance} | ',
//                           style: AppFonts.smallText
//                               .copyWith(color: AppColors.textGrey)),
//                       Gap(4),
//                       Image.asset(
//                         'assets/ic_clock.png',
//                         height: 12,
//                         width: 12,
//                       ),
//                       Gap(4),
//                       Text('${item?.duration}',
//                           style: AppFonts.smallText
//                               .copyWith(color: AppColors.textGrey)),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ));

//   updateHotelData(String userId,double lat, double lng, double distance,String mode){
//     _homeBloc.add(
//         OnUpdateFavOrder(userId:userId,lat: lat, lag: lng, distance: distance,mode: mode));  }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:gap/gap.dart';
// import 'package:uggiso/Model/GetNearByResaturantModel.dart';
// import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
// import 'package:uggiso/base/common/utils/colors.dart';
// import '../../Bloc/HomeBloc/HomeBloc.dart';
// import '../../Bloc/HomeBloc/HomeEvent.dart';
// import '../../app_routes.dart';
// import '../../base/common/utils/MenuListArgs.dart';
// import '../../base/common/utils/fonts.dart';

// class HotelListGrid extends StatelessWidget {
//   final List<Payload>? restaurantList;
//   final String? userId;
//   final double? lat;
//   final double? lng;
//   final String? travelMode;
//   final double? distance;
//   final ScrollController? scrollController;

//   const HotelListGrid(
//     this.restaurantList,
//     this.userId,
//     this.lat,
//     this.lng,
//     this.travelMode,
//     this.distance, {
//     this.scrollController,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       controller: scrollController,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         childAspectRatio: 0.9,
//       ),
//       itemCount: restaurantList?.length ?? 0,
//       itemBuilder: (context, index) {
//         return _buildGridItem(context, restaurantList![index]);
//       },
//     );
//   }

//   Widget _buildGridItem(BuildContext context, Payload item) {
//     return RoundedContainer(
//       width: MediaQuery.of(context).size.width * 0.5,
//       color: AppColors.white,
//       borderColor: AppColors.white,
//       cornerRadius: 8,
//       padding: 0,
//       child: InkWell(
//         onTap: () => Navigator.pushNamed(
//           context,
//           AppRoutes.menuList,
//           arguments: MenuListArgs(
//             restaurantId: item.restaurantId,
//             name: item.restaurantName,
//             foodType: item.restaurantMenuType,
//             ratings: item.ratings,
//             landmark: item.landmark,
//             distance: item.distance,
//             duration: item.duration,
//             payload: item,
//           ),
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: double.infinity,
//                   height: MediaQuery.of(context).size.height * 0.1,
//                   child: Image.network(
//                     item.imageUrl ?? '',
//                     fit: BoxFit.fitWidth,
//                     errorBuilder: (context, error, stackTrace) => Center(
//                       child: Icon(
//                         Icons.broken_image,
//                         size: 60,
//                         color: AppColors.grey,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: item.favourite == true
//                       ? IconButton(
//                           padding: EdgeInsets.zero,
//                           onPressed: () {
//                             BlocProvider.of<HomeBloc>(context).add(
//                               OnDeleteFavRestaurant(
//                                   userId: userId,
//                                   restaurantId: item.restaurantId),
//                             );
//                           },
//                           icon: Image.asset(
//                             'assets/ic_heart_fill.png',
//                             width: 24,
//                             height: 24,
//                             color: AppColors.appPrimaryColor,
//                           ),
//                         )
//                       : IconButton(
//                           padding: EdgeInsets.zero,
//                           onPressed: () {
//                             BlocProvider.of<HomeBloc>(context).add(
//                               OnAddFavRestaurant(
//                                   userId: userId,
//                                   restaurantId: item.restaurantId),
//                             );
//                           },
//                           icon: Image.asset(
//                             'assets/ic_heart.png',
//                             width: 24,
//                             height: 24,
//                             color: AppColors.appPrimaryColor,
//                           ),
//                         ),
//                 ),
//               ],
//             ),
//             Container(
//               width: MediaQuery.of(context).size.width * 0.42,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Gap(4),
//                   Text(
//                     item.restaurantName ?? '',
//                     style: AppFonts.title.copyWith(
//                         color: AppColors.bottomTabInactiveColor),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const Gap(4),
//                   Row(
//                     children: [
//                       item.restaurantMenuType == 'VEG'
//                           ? Image.asset('assets/ic_veg.png', height: 12, width: 12)
//                           : Image.asset('assets/ic_non_veg.png', height: 12, width: 12),
//                       const Gap(4),
//                       Text(
//                         item.restaurantMenuType ?? '',
//                         style: AppFonts.smallText
//                             .copyWith(fontWeight: FontWeight.w500),
//                       ),
//                       const Spacer(),
//                       Image.asset('assets/ic_star.png', height: 14, width: 14),
//                       const Gap(2),
//                       Text('${item.ratings ?? ''}',
//                           style: AppFonts.smallText.copyWith(
//                               color: AppColors.textColor)),
//                     ],
//                   ),
//                   const Gap(8),
//                   Row(
//                     children: [
//                       Image.asset('assets/ic_small_marker.png',
//                           height: 12, width: 12),
//                       const Gap(4),
//                       Text('${item.distance ?? ''} | ',
//                           style: AppFonts.smallText
//                               .copyWith(color: AppColors.textGrey)),
//                       const Gap(4),
//                       Image.asset('assets/ic_clock.png', height: 12, width: 12),
//                       const Gap(4),
//                       Text('${item.duration ?? ''}',
//                           style: AppFonts.smallText
//                               .copyWith(color: AppColors.textGrey)),
//                     ],
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import '../../Bloc/HomeBloc/HomeBloc.dart';
import '../../Bloc/HomeBloc/HomeEvent.dart';
import '../../app_routes.dart';
import '../../base/common/utils/MenuListArgs.dart';
import '../../base/common/utils/fonts.dart';

class HotelListGrid extends StatelessWidget {
  final List<Payload>? restaurantList;
  final String? userId;
  final double? lat;
  final double? lng;
  final String? travelMode;
  final double? distance;
  final ScrollController? scrollController;

  const HotelListGrid(
    this.restaurantList,
    this.userId,
    this.lat,
    this.lng,
    this.travelMode,
    this.distance, {
    this.scrollController,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.75,
      ),
      itemCount: restaurantList?.length ?? 0,
      itemBuilder: (context, index) {
        return _buildGridItem(context, restaurantList![index]);
      },
    );
  }

  // Builds individual restaurant card in the grid
  Widget _buildGridItem(BuildContext context, Payload item) {
    return RoundedContainer(
      width: MediaQuery.of(context).size.width * 0.5,
      
      color: AppColors.white,
      borderColor: AppColors.white,
      cornerRadius: 8,
      padding: 0,
      child: InkWell(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.menuList,
          arguments: MenuListArgs(
            restaurantId: item.restaurantId,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Restaurant image with fallback
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  child: Image.network(
                    item.imageUrl ?? '',
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.16,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: MediaQuery.of(context).size.height * 0.14,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image,
                          color: Colors.grey, size: 40),
                    ),
                  ),
                ),
                // Favorite icon top-right
                // Positioned(
                //   top: 8,
                //   right: 8,
                //   child: item.favourite == true
                //       ? IconButton(
                //           padding: EdgeInsets.zero,
                //           onPressed: () {
                //             BlocProvider.of<HomeBloc>(context).add(
                //               OnDeleteFavRestaurant(
                //                   userId: userId,
                //                   restaurantId: item.restaurantId),
                //             );
                //           },
                //           icon: Image.asset(
                //             'assets/ic_heart_fill.png',
                //             width: 24,
                //             height: 24,
                //             color: AppColors.appPrimaryColor,
                //           ),
                //         )
                //       : IconButton(
                //           padding: EdgeInsets.zero,
                //           onPressed: () {
                //             BlocProvider.of<HomeBloc>(context).add(
                //               OnAddFavRestaurant(
                //                   userId: userId,
                //                   restaurantId: item.restaurantId),
                //             );
                //           },
                //           icon: Image.asset(
                //             'assets/ic_heart.png',
                //             width: 24,
                //             height: 24,
                //             color: AppColors.appPrimaryColor,
                //           ),
                //         ),
                // ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(), // Removes default constraints
                    visualDensity:
                        VisualDensity.compact, // Reduces internal spacing
                    splashRadius: 10, // Optional: smaller splash circle
                    onPressed: () {
                      if (item.favourite == true) {
                        BlocProvider.of<HomeBloc>(context).add(
                          OnDeleteFavRestaurant(
                            userId: userId,
                            restaurantId: item.restaurantId,
                          ),
                        );
                      } else {
                        BlocProvider.of<HomeBloc>(context).add(
                          OnAddFavRestaurant(
                            userId: userId,
                            restaurantId: item.restaurantId,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      item.favourite == true
                          ? Icons.bookmark
                          : Icons.bookmark_outline,
                      color: item.favourite == true ? Colors.red : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),

            // Restaurant details section
            Padding(
              padding: const EdgeInsets.only(
                top: 6,
                left: 8,
                right: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.restaurantName ?? '',
                          style: AppFonts.title.copyWith(
                            color: AppColors.bottomTabInactiveColor,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          item.restaurantMenuType == 'VEG'
                              ? Image.asset('assets/ic_veg.png',
                                  height: 12, width: 12)
                              : Image.asset('assets/ic_non_veg.png',
                                  height: 12, width: 12),
                          const Gap(4),
                          Text(
                            item.restaurantMenuType ?? '',
                            style: AppFonts.smallText
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                          const Gap(2),
                          Text(
                            '${item.ratings ?? ''}',
                            style: AppFonts.smallText
                                .copyWith(color: AppColors.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Gap(4),

                  // Food type & ratings row
                  const Gap(4),

                  // Distance & duration row
                  Row(
                    children: [
                      Image.asset('assets/ic_small_marker.png',
                          height: 12, width: 12),
                      const Gap(4),
                      Text('${item.distance ?? ''} | ',
                          style: AppFonts.smallText
                              .copyWith(color: AppColors.textGrey)),
                      const Gap(4),
                      Image.asset('assets/ic_clock.png', height: 12, width: 12),
                      const Gap(4),
                      Text('${item.duration ?? ''}',
                          style: AppFonts.smallText
                              .copyWith(color: AppColors.textGrey)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
