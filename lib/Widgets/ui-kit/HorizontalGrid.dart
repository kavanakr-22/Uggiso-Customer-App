import 'package:flutter/material.dart';
import 'package:uggiso/Model/GetNearByResaturantModel.dart';

class HorizontalRestaurantSlider extends StatefulWidget {
  final String title;
  final List<Payload> restaurants;
  final VoidCallback onTap;

  const HorizontalRestaurantSlider({
    super.key,
    required this.title,
    required this.restaurants,
    required this.onTap,
  });

  @override
  State<HorizontalRestaurantSlider> createState() =>
      _HorizontalRestaurantSliderState();
}

class _HorizontalRestaurantSliderState
    extends State<HorizontalRestaurantSlider> {
  final Set<int> _bookmarkedIndexes = {};

  void _toggleBookmark(int index) {
    setState(() {
      if (_bookmarkedIndexes.contains(index)) {
        _bookmarkedIndexes.remove(index);
      } else {
        _bookmarkedIndexes.add(index);
      }
    });
  }

  bool isVeg(Payload r) {
    final type = (r.type ?? '').toLowerCase();
    return type.contains('veg') && !type.contains('non');
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: widget.onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 10.0),
                child: Icon(Icons.arrow_forward_ios,
                    size: 20, color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.restaurants.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final r = widget.restaurants[index];
              final isBookmarked = _bookmarkedIndexes.contains(index);
              final bool veg = isVeg(r);

              return Container(
                width: cardWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            'assets/restuarant_img.png',
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _toggleBookmark(index),
                            child: Icon(
                              isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: isBookmarked ? Colors.red : Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  r.restaurantName ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: veg ? Colors.green : Colors.red,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: veg ? Colors.green : Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                veg ? 'VEG' : 'NONVEG',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: veg ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '₹${r.price ?? '150'}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    r.rating ?? '4.2',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(Icons.star,
                                      size: 14, color: Colors.orange),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              const Text(
                                '9 m',
                                style: TextStyle(fontSize: 11),
                              ),
                              const SizedBox(width: 12),
                              const Icon(Icons.access_time,
                                  size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(
                                r.duration ?? '1 min',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
