import 'package:flutter/material.dart';

class DockTile extends StatefulWidget {
  const DockTile({
    required this.size,
    required this.position,
    super.key,
  });

  final double size;
  final double position;

  @override
  State<DockTile> createState() => _DockTileState();
}

class _DockTileState extends State<DockTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 400,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        width: widget.size,
        height: widget.size,
        duration: const Duration(milliseconds: 400),
        child: const ColoredBox(
          color: Colors.black,
        ),
      ),
    );
  }
}
