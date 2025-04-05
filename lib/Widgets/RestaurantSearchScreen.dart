import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Bloc/SearchBloc/search_bloc.dart';
import 'package:uggiso/Bloc/SearchBloc/search_event.dart';
import 'package:uggiso/Bloc/SearchBloc/search_state.dart';
import 'package:uggiso/Model/RestaurantSearchModel.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
import 'package:uggiso/app_routes.dart';
import 'package:uggiso/base/common/utils/MenuListArgs.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class Restaurantsearchscreen extends StatefulWidget {
  final double? lat;
  final double? lag;
  final String? userId;

  const Restaurantsearchscreen({super.key, required this.lat,
    required this.lag,
    required this.userId,});

  @override
  State<Restaurantsearchscreen> createState() => _RestaurantsearchscreenState();
}

class _RestaurantsearchscreenState extends State<Restaurantsearchscreen> {
  final FocusNode _focusNode = FocusNode();
  SearchBloc _searchBloc = SearchBloc();
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String previousText = '';
  bool _isRestaurantsExpanded = true;
  bool _isMenusExpanded = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      _focusNode.requestFocus(); // Auto-focus the text field
    });

    _searchController.addListener(() {
      _onSearchChanged();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text;

    // Prevent API call if the text hasn't changed
    if (query == previousText) return;

    previousText = query;  // Update previous query

    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(Duration(milliseconds: 500), () {
      if (query.length > 2) {
        _searchBloc.add(OnSearchInitiated(querry: query,lat:widget.lat!,lag:widget.lag!,userId: widget.userId!));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.textFieldBg,
      appBar: AppBar(
          backgroundColor: AppColors.appPrimaryColor,
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          leadingWidth: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20), // Adjust curve radius
            ),
          ),
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RoundedContainer(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.05,
              color: AppColors.white,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 22,
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: TextFormField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      maxLines: 1,
                      style: AppFonts.title,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: 'Search Restaurant',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              cornerRadius: 50,
            ),
          ),
          leading: Container()),
      body: BlocProvider(
        create: (context) => _searchBloc,
        child: BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
          if (state is LoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.appPrimaryColor,
              ),
            );
          } else if (state is onLoadedState) {
            return showSearchResults(state.data);
          } else {
            return Center(
              child: Text(Strings.something_went_wrong),
            );
          }
        }),
      ),
    );
  }

  Widget showSearchResults(ResaturantSearchModel data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 12.0),
      child: ListView(
        children: [
          // Restaurants Expandable
          data.payload!.restaurants!.isEmpty?Container():ExpansionTile(
            initiallyExpanded: _isRestaurantsExpanded,
            onExpansionChanged: (expanded) {
              setState(() => _isRestaurantsExpanded = expanded);
            },
            tilePadding: EdgeInsets.zero,        // Removes padding around the tile
            collapsedShape: RoundedRectangleBorder(
              side: BorderSide.none,              // Removes the border line
            ),
            shape: RoundedRectangleBorder(
              side: BorderSide.none,              // Removes border when expanded
            ),
            title: _sectionHeader('Restaurants'),
            children: [
              RoundedContainer(
                width: double.infinity,
                cornerRadius: 12,
                color: Colors.white,
                borderColor: AppColors.white,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.payload!.restaurants!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        print('this isrestaurant id  from restaurants: ${data.payload!.restaurants![index].restaurantId}');
                        Navigator.pushNamed(
                          context,
                          AppRoutes.menuList,
                          arguments: MenuListArgs(
                            restaurantId: data.payload!.restaurants![index].restaurantId,
                            name: data.payload!.restaurants![index].restaurantName,
                            foodType: data.payload!.restaurants![index].restaurantMenuType,
                            ratings: data.payload!.restaurants![index].ratings,
                            landmark: data.payload!.restaurants![index].landmark,
                            distance: data.payload!.restaurants![index].distance,
                            duration: data.payload!.restaurants![index].duration
                          ),
                        );
                      },
                        child: _restaurantCard(data.payload!.restaurants![index]));
                  },
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey[300],   // Divider color
                    thickness: 1,              // Line thickness
                    height: 16,                // Space between items
                  ),
                ),
              ),
            ]
          ),
          // Menus Expandable
          // data.payload!.menus!.isEmpty?Container():ExpansionTile(
          //   initiallyExpanded: _isMenusExpanded,
          //   onExpansionChanged: (expanded) {
          //     setState(() => _isMenusExpanded = expanded);
          //   },
          //   tilePadding: EdgeInsets.zero,        // Removes padding around the tile
          //   collapsedShape: RoundedRectangleBorder(
          //     side: BorderSide.none,              // Removes the border line
          //   ),
          //   shape: RoundedRectangleBorder(
          //     side: BorderSide.none,              // Removes border when expanded
          //   ),
          //   title: _sectionHeader('Menus'),
          //   children: [
          //     RoundedContainer(
          //       width: double.infinity,
          //       cornerRadius: 12,
          //       color: Colors.white,
          //       borderColor: AppColors.white,
          //       child: ListView.separated(
          //         shrinkWrap: true,
          //         physics: NeverScrollableScrollPhysics(),
          //         itemCount: data.payload!.menus!.length,
          //         itemBuilder: (context, index) {
          //           return InkWell(
          //             onTap: (){
          //               print('this isrestaurant id  from restaurants: ${data.payload!.menus![index].restaurantId}');
          //
          //             },
          //               child: _menuCard(data.payload!.menus![index]));
          //         },
          //         separatorBuilder: (context, index) => Divider(
          //           color: Colors.grey[300],   // Divider color
          //           thickness: 1,              // Line thickness
          //           height: 16,                // Space between items
          //         ),
          //       ),
          //     ),
          //   ]
          // ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _restaurantCard(Restaurants restaurant) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image on the left side
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              restaurant.imageUrl ?? '',
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.2,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/ic_no_image.png', height: 80, width: 80, fit: BoxFit.cover),  // Fallback image
            ),
          ),
          SizedBox(width: 12),  // Spacing between image and content
          Expanded(              // To prevent overflow and ensure content takes remaining space
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                restaurant.restaurantName!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(4),
                  Text("${restaurant.address}"),
                  Gap(4),
                  Row(
                    children: [
                      restaurant.restaurantMenuType == 'VEG'
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("${restaurant.restaurantMenuType}"),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _menuCard(Menus menu) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image on the left side
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              menu.photo ?? '',
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.2,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/ic_no_image.png', height: 80, width: 80, fit: BoxFit.cover),  // Fallback image
            ),
          ),
          SizedBox(width: 12),  // Spacing between image and content
          Expanded(              // Ensure the content takes remaining space
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                menu.menuName!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      menu.restaurantMenuType == 'VEG'
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("${menu.restaurantMenuType}"),
                      ),

                    ],
                  ),
                  Text("Price: ₹${menu.price}"),
                  if (menu.bestSeller ?? false)
                    Text(
                      "⭐ Best Seller",
                      style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
