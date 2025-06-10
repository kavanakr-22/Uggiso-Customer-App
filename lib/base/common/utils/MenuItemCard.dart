import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:uggiso/Model/AddMenuItemToCart.dart';
import 'package:uggiso/base/common/utils/strings.dart';
import '../../../Bloc/MenuListBloc/MenuListBloc.dart';
import '../../../Bloc/MenuListBloc/MenuListEvent.dart';
import '../../../Bloc/MenuListBloc/MenuListState.dart';
import '../../../Model/MenuListModel.dart';
import '../../../Widgets/ui-kit/RoundedContainer.dart';
import 'Cart.dart';
import 'colors.dart';
import 'fonts.dart';

class MenuItemCard extends StatefulWidget {
  final Payload listData;
  final int itemLength;
  final VoidCallback onItemAdded;
  final ValueChanged<String> onEmptyCart;
  final ValueChanged<int> onQuantityChanged;
  final String userId;

  const MenuItemCard({
    required this.listData,
    required this.itemLength,
    required this.onItemAdded,
    required this.onEmptyCart,
    required this.onQuantityChanged,
    required this.userId,
  });

  @override
  _MenuItemCardState createState() => _MenuItemCardState();
}

class _MenuItemCardState extends State<MenuItemCard> {
  int _orderCount = 0;
  final Cart cart = Cart();
  final MenuListBloc _menuListBloc = MenuListBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _menuListBloc,
      child: Column(
        children: [
          Divider(color: AppColors.borderColor),
          RoundedContainer(
            width: MediaQuery.of(context).size.width,
            color: widget.listData.menuAvailable == 'AVAILABLE'
                ? AppColors.white
                : AppColors.bottomTabInactiveColor.withOpacity(0.3),
            cornerRadius: 10,
            borderColor: widget.listData.menuAvailable == 'AVAILABLE'
                ? AppColors.white
                : AppColors.bottomTabInactiveColor.withOpacity(0.3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT SIDE CONTENT
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.listData.bestSeller!)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: AppColors.appSecondaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(Strings.bestseller,
                              style: AppFonts.smallText),
                        ),
                      Gap(8),
                      Row(
                        children: [
                          Image.asset(
                            widget.listData.restaurantMenuType == 'VEG'
                                ? 'assets/ic_veg.png'
                                : 'assets/ic_non_veg.png',
                            height: 12,
                            width: 12,
                          ),
                          Gap(4),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              '${widget.listData.menuName}',
                              style: AppFonts.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      Gap(4),
                      Text(
                        '₹ ${widget.listData.price.toString()}',
                        style: AppFonts.smallText,
                      ),
                      Gap(4),
                      if (widget.listData.ratings != null)
                        Row(
                          children: [
                            Image.asset('assets/ic_star.png',
                                width: 12, height: 12),
                            Gap(4),
                            Text('${widget.listData.ratings}',
                                style: AppFonts.smallText.copyWith(
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      BlocBuilder<MenuListBloc, MenuListState>(
                        builder: (context, state) {
                          if (state is FetchingState) {
                            return CircularProgressIndicator(
                                color: AppColors.appPrimaryColor);
                          } else if (state is onFavMenuAddedState ||
                              widget.listData.favourite == true) {
                            return InkWell(
                              onTap: () {
                                _menuListBloc.add(OnDeleteFavMenu(
                                    userId: widget.userId,
                                    menuId: widget.listData.menuId));
                              },
                              child: Image.asset(
                                'assets/ic_heart_fill.png',
                                width: 22,
                                height: 22,
                                color: AppColors.appPrimaryColor,
                              ),
                            );
                          } else {
                            return InkWell(
                              onTap: () {
                                _menuListBloc.add(OnAddFavMenu(
                                    userId: widget.userId,
                                    menuId: widget.listData.menuId,
                                    restaurantId:
                                    widget.listData.restaurantId));
                              },
                              child: Image.asset(
                                'assets/ic_heart.png',
                                width: 22,
                                height: 22,
                                color: AppColors.appPrimaryColor,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                /// RIGHT SIDE IMAGE / UNAVAILABLE
                widget.listData.menuAvailable == 'AVAILABLE'
                    ? Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  child: Stack(
                    children: [
                      widget.listData.photo == null
                          ? RoundedContainer(
                          width: MediaQuery.of(context).size.width *
                              0.25,
                          height: MediaQuery.of(context).size.height *
                              0.1,
                          cornerRadius: 12,
                          borderColor: AppColors.appPrimaryColor,
                          child: Center(
                              child: Image.asset(
                                'assets/ic_no_image.png',
                                fit: BoxFit.fill,
                              )))
                          : RoundedContainer(
                          width: MediaQuery.of(context).size.width *
                              0.25,
                          height: MediaQuery.of(context).size.height *
                              0.1,
                          cornerRadius: 12,
                          borderColor: AppColors.appPrimaryColor,
                          padding: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              widget.listData.photo.toString(),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stack) =>
                                  Center(
                                    child: Image.asset(
                                        'assets/ic_no_image.png'),
                                  ),
                            ),
                          )),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.08,
                        left: 8,
                        right: 8,
                        child: RoundedContainer(
                          width: MediaQuery.of(context).size.width,
                          height:
                          MediaQuery.of(context).size.height * 0.04,
                          cornerRadius: 10,
                          padding: 0,
                          color: AppColors.white,
                          child: _orderCount == 0
                              ? Center(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _orderCount = 1;
                                });
                                widget.onItemAdded();
                              },
                              child: Text(
                                Strings.add,
                                style: AppFonts.title.copyWith(
                                    color:
                                    AppColors.appPrimaryColor),
                              ),
                            ),
                          )
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Gap(6),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _orderCount--;
                                  });
                                  if (_orderCount == 0) {
                                    widget.onEmptyCart(widget
                                        .listData.menuId
                                        .toString());
                                    cart.removeItem(
                                        AddMenuItemToCart(
                                            menuId: widget
                                                .listData.menuId
                                                .toString(),
                                            menuName: widget
                                                .listData.menuName
                                                .toString(),
                                            menuType: widget
                                                .listData.menuType
                                                .toString(),
                                            price: widget
                                                .listData.price!));
                                  } else {
                                    widget.onQuantityChanged(
                                        _orderCount);
                                  }
                                },
                                child: Icon(Icons.remove,
                                    color:
                                    AppColors.appPrimaryColor,
                                    size: 20),
                              ),
                              Gap(6),
                              Text(
                                '$_orderCount',
                                style: AppFonts.smallText.copyWith(
                                  color: AppColors.appPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              Gap(6),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _orderCount++;
                                  });
                                  widget.onQuantityChanged(
                                      _orderCount);
                                },
                                child: Icon(Icons.add,
                                    color:
                                    AppColors.appPrimaryColor,
                                    size: 20),
                              ),
                              Gap(6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Currently unavailable',
                      style: AppFonts.title
                          .copyWith(color: Colors.redAccent),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(12),
        ],
      ),
    );
  }
}
