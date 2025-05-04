import 'package:flutter/material.dart';

class CustomCategoryTabBar extends StatefulWidget {
  final List<String> categories;
  final Function(int) onCategorySelected;
  final int initialSelectedIndex;

  const CustomCategoryTabBar({
    super.key,
    required this.categories,
    required this.onCategorySelected,
    this.initialSelectedIndex = 0,
  });

  @override
  State<CustomCategoryTabBar> createState() => _CustomCategoryTabBarState();
}

class _CustomCategoryTabBarState extends State<CustomCategoryTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Row(
            children: List.generate(
              widget.categories.length,
              (index) => _buildTabItem(index),
            ),
          ),
          
        ],
      ),
    );
  }

  Widget _buildTabItem(int index) {
    final bool isSelected = index == _selectedIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
          widget.onCategorySelected(index);
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 10.0,
              ),
              child: Text(
                widget.categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.purple : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            // Linha indicadora
            Container(
              height: 3,
              width: 40, // Largura fixa ou pode ser ajustada com base no texto
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple : Colors.transparent,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
