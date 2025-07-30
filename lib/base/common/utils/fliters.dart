import 'package:flutter/material.dart';

class FoodTypeFilter extends StatefulWidget {
  final Function(String) onFilterSelected;

  const FoodTypeFilter({super.key, required this.onFilterSelected});

  @override
  State<FoodTypeFilter> createState() => _FoodTypeFilterState();
}

class _FoodTypeFilterState extends State<FoodTypeFilter> {
  String selected = 'All';

  Widget buildFilterChip({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? borderColor : Colors.grey.shade300,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(color: iconColor, width: 2),
                borderRadius: BorderRadius.circular(4), // square shape
              ),
              child: Center(
                child: Icon(icon, size: 12, color: iconColor),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          buildFilterChip(
            label: "Filters",
            icon: Icons.tune,
            iconColor: Colors.black,
            borderColor: Colors.black,
            isSelected: false,
            onTap: () => _openFilterModal(context),
          ),
          buildFilterChip(
            label: "Veg",
            icon: Icons.circle,
            iconColor: Colors.green,
            borderColor: Colors.green,
            isSelected: selected == 'Veg',
            onTap: () {
              setState(() => selected = 'Veg');
              widget.onFilterSelected('Veg');
            },
          ),
          buildFilterChip(
            label: "Non-veg",
            icon: Icons.circle,
            iconColor: Colors.red,
            borderColor: Colors.red,
            isSelected: selected == 'Non-Veg',
            onTap: () {
              setState(() => selected = 'Non-Veg');
              widget.onFilterSelected('Non-Veg');
            },
          ),
        ],
      ),
    );
  }

  void _openFilterModal(BuildContext context) {
    String tempSelectedType = selected;
    String tempSort = '';

    void applyFilters() {
      Navigator.pop(context);
      setState(() {
        selected = tempSelectedType;
      });
      widget.onFilterSelected(selected);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) {
          Widget chip({
            required String label,
            required bool isSelected,
            required VoidCallback onTap,
            required IconData icon,
            required Color color,
          }) {
            return GestureDetector(
              onTap: onTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? color : Colors.grey.shade300,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        border: Border.all(color: color, width: 2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Icon(icon, size: 12, color: color),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Filters and Sorting",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // Sort By Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Sort by",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text("Price - low to high"),
                      selected: tempSort == 'Low to High',
                      onSelected: (_) {
                        setModalState(() => tempSort = 'Low to High');
                      },
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text("Price - high to low"),
                      selected: tempSort == 'High to Low',
                      onSelected: (_) {
                        setModalState(() => tempSort = 'High to Low');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Veg/Non-veg Preference Section
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Veg/Non-veg preference",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Wrap(
                  children: [
                    chip(
                      label: 'All',
                      icon: Icons.lens,
                      color: Colors.blueGrey,
                      isSelected: tempSelectedType == 'All',
                      onTap: () =>
                          setModalState(() => tempSelectedType = 'All'),
                    ),
                    chip(
                      label: 'Veg',
                      icon: Icons.circle,
                      color: Colors.green,
                      isSelected: tempSelectedType == 'Veg',
                      onTap: () =>
                          setModalState(() => tempSelectedType = 'Veg'),
                    ),
                    chip(
                      label: 'Non-Veg',
                      icon: Icons.change_history,
                      color: Colors.red,
                      isSelected: tempSelectedType == 'Non-Veg',
                      onTap: () =>
                          setModalState(() => tempSelectedType = 'Non-Veg'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Clear / Apply Buttons
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selected = 'All'; // Update the main state
                        });
                        widget.onFilterSelected('All'); // Notify parent
                        Navigator.pop(context); // Close the modal
                      },
                      child: const Text(
                        "Clear All",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: applyFilters,
                      child: const Text("Apply"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
