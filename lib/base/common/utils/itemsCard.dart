import 'package:flutter/material.dart';
import 'package:uggiso/base/common/utils/colors.dart';

class ItemsCard extends StatefulWidget {
  final String id; // NEW
  final String title;
  final String subtitle;
  final double price;
  final String type;
  final VoidCallback? onAdd;
  final double? rating;
  final void Function(Map<String, dynamic> item)? onQuantityChanged; // UPDATED

  const ItemsCard({
    Key? key,
    required this.id, // NEW
    required this.title,
    required this.subtitle,
    required this.price,
    required this.type,
    this.onAdd,
    this.rating,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ItemsCard> createState() => _ItemsCardState();
}

class _ItemsCardState extends State<ItemsCard> {
  bool isBookmarked = false;
  int quantity = 0;

  void _updateQuantity(int change) {
    setState(() {
      quantity += change;
      if (quantity < 0) quantity = 0;
    });

    widget.onQuantityChanged?.call({
      'id': widget.id,
      'quantity': quantity,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: widget.type == 'veg'
                                ? Colors.green
                                : Colors.red,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Icon(
                            widget.type == 'veg' ? Icons.circle : Icons.circle,
                            size: 12,
                            color: widget.type == 'veg'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        "₹${widget.price.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 60),
                      if (widget.rating != null && widget.rating! > 0)
                        Row(
                          children: [
                            Text(
                              widget.rating!.toStringAsFixed(1),
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
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey[700], fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isBookmarked = !isBookmarked;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFF2F2F2),
                          ),
                          child: Icon(
                            isBookmarked
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            size: 20,
                            color: isBookmarked ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFF2F2F2),
                        ),
                        child: const Icon(Icons.share,
                            size: 20, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
            Stack(
              clipBehavior: Clip.none,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/idli.png',
                    width: 120,
                    height: 120,
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  bottom: -15,
                  right: 12,
                  child: quantity == 0
                      ? GestureDetector(
                          onTap: () {
                            _updateQuantity(1);
                            widget.onAdd?.call();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.appSecondaryColor,
                              border:
                                  Border.all(color: AppColors.appPrimaryColor),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: const [
                                Text(
                                  "ADD",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 6, 6, 6),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.add,
                                    size: 16,
                                    color: Color.fromARGB(255, 11, 11, 11)),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.appSecondaryColor,
                            border:
                                Border.all(color: AppColors.appPrimaryColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (quantity > 0) {
                                    _updateQuantity(-1);
                                  }
                                },
                                child: const Icon(Icons.remove,
                                    color: Color.fromARGB(255, 9, 9, 9),
                                    size: 18),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                quantity.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 16, 16, 16),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  _updateQuantity(1);
                                },
                                child: const Icon(Icons.add,
                                    color: Color.fromARGB(255, 13, 13, 13),
                                    size: 18),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
