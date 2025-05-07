import 'package:flutter/material.dart';

class CustomCategoryTabBar extends StatefulWidget {
  final List<String> categories;
  final Function(int) onTagSelected;
  final int initialSelectedIndex;

  const CustomCategoryTabBar({
    super.key,
    required this.categories,
    required this.onTagSelected,
    this.initialSelectedIndex = 0,
  });

  @override
  _CustomCategoryTabBarState createState() => _CustomCategoryTabBarState();
}

class _CustomCategoryTabBarState extends State<CustomCategoryTabBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  @override
  void didUpdateWidget(CustomCategoryTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedIndex != oldWidget.initialSelectedIndex) {
      setState(() {
        _selectedIndex = widget.initialSelectedIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
              widget.onTagSelected(index);
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.purple : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.purple : Colors.grey.shade300,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                widget.categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}