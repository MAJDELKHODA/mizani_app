import 'package:flutter/material.dart';

class SelectionItem {
  final String name;
  final IconData icon;
  final Color color;

  const SelectionItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}


class SelectionGrid extends StatelessWidget {
  final String title;
  final List<SelectionItem> items;
  final String selectedValue;
  final ValueChanged<String> onSelected;
  final int crossAxisCount;

  const SelectionGrid({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,

            physics:
            const NeverScrollableScrollPhysics(),

            itemCount: items.length,

            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1,
            ),

            itemBuilder: (context, index) {
              final item = items[index];

              final bool selected =
                  selectedValue == item.name;

              return InkWell(
                onTap: () {
                  onSelected(item.name);
                },

                borderRadius:
                BorderRadius.circular(14),

                child: Container(
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xffF0E9FF)
                        : const Color(0xffFAF9FE),

                    border: Border.all(
                      color: selected
                          ? const Color(0xff6D3CE8)
                          : Colors.transparent,
                    ),

                    borderRadius:
                    BorderRadius.circular(14),
                  ),

                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,

                    children: [
                      Icon(
                        item.icon,
                        color: item.color,
                        size: 23,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}