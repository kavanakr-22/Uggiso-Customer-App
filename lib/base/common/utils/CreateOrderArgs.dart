class CreateOrderArgs {
  final List<Map<String, dynamic>> orderlist;
  final String? restaurantId;
  final String? restaurantName;
  final double? restaurantLat;
  final double? restaurantLng;
  final double? gstPercent;

  CreateOrderArgs({required this.orderlist, required this.restaurantId,required this.restaurantName,
    required this.restaurantLat,required this.restaurantLng, required this.gstPercent});
}

class OrderSuccessArgs {
  final double? restLat;
  final double? restLng;
  OrderSuccessArgs({required this.restLat,required this.restLng});
}
