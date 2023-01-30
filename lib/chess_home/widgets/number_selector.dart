import 'package:flutter/material.dart';

typedef NumberChangedFunction = void Function(int);

/// Widget for choosing a number from a generated list of numbers.
class NumberSelector extends StatelessWidget {
  /// How many numbers to generate. Numbers start from 0.
  final int itemCount;

  /// Function which decides what happens to the selected number.
  final NumberChangedFunction onSelected;

  NumberSelector(
      {super.key, required this.itemCount, required this.onSelected});

  final ScrollController _scrollController = FixedExtentScrollController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 60,
      child: ListWheelScrollView.useDelegate(
        diameterRatio: 2,
        clipBehavior: Clip.hardEdge,
        onSelectedItemChanged: onSelected,
        controller: _scrollController,
        physics: const FixedExtentScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        itemExtent: 50,
        childDelegate: ListWheelChildListDelegate(
          children: List.generate(
            itemCount,
            (index) => Text(
              // Formats numbers less than 10.
              index < 10 ? "0$index" : index.toString(),
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
      ),
    );
  }
}
