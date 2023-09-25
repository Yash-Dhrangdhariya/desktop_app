import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:windows_tile/models/dock_icon_position.dart';

class DockBar extends StatefulWidget {
  const DockBar({
    required this.items,
    super.key,
    this.dockSize = 70.0,
    this.dockPadding = 12.0,
    this.itemsSpacing = 20.0,
  });

  final double dockSize;
  final double dockPadding;
  final double itemsSpacing;
  final List<IconData> items;

  @override
  State<DockBar> createState() => _DockBarState();
}

class _DockBarState extends State<DockBar> {
  double innerBoxSize = 0;

  ValueNotifier<double> mousePointer = ValueNotifier(-1);
  final itemsPositions = <DockIconPosition>[];

  void scrollPosition() {
    innerBoxSize = widget.dockSize - (widget.dockPadding * 2);
    for (var i = 1; i <= widget.items.length; i++) {
      if (i == 1) {
        final itemPosition = i + innerBoxSize + widget.dockPadding;
        itemsPositions.add(
          DockIconPosition(
            begin: 0,
            end: itemPosition,
          ),
        );
      } else if (i == widget.items.length) {
        final itemPosition = itemsPositions[i - 2].end +
            widget.itemsSpacing +
            innerBoxSize +
            widget.dockPadding;
        itemsPositions.add(
          DockIconPosition(
            begin: itemsPositions[i - 2].end,
            end: itemPosition,
          ),
        );
      } else {
        final itemPosition =
            itemsPositions[i - 2].end + widget.itemsSpacing + innerBoxSize;
        itemsPositions.add(
          DockIconPosition(
            begin: itemsPositions[i - 2].end,
            end: itemPosition,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    scrollPosition();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      height: widget.dockSize,
      child: Center(
        child: MouseRegion(
          onHover: (hoverEvent) {
            mousePointer.value = hoverEvent.localPosition.dx;
          },
          onExit: (exitValue) {
            mousePointer.value = -1;
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: const ColoredBox(
                      color: Colors.white24,
                    ),
                  ),
                ),
              ),
              AnimatedList(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: widget.dockPadding,
                ),
                initialItemCount: widget.items.length,
                itemBuilder: (context, index, animation) {
                  final position = itemsPositions[index];
                  return Center(
                    child: ValueListenableBuilder(
                      valueListenable: mousePointer,
                      builder: (context, value, child) {
                        final active =
                            value >= position.begin && value <= position.end;
                        return AnimatedScale(
                          scale: active ? 1.5 : 1,
                          alignment: Alignment.bottomCenter,
                          duration: const Duration(
                            milliseconds: 160,
                          ),
                          // curve: Curves.easeIn,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: index == 0 ? 0 : widget.itemsSpacing / 2,
                              right: index == (widget.items.length - 1)
                                  ? 0
                                  : widget.itemsSpacing / 2,
                            ),
                            child: SizedBox(
                              height: innerBoxSize,
                              width: innerBoxSize,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ColoredBox(
                                  color: Colors.primaries.elementAt(index),
                                  child: Icon(
                                    widget.items[index],
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
