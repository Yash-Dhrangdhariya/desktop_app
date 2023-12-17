import 'package:flutter/material.dart';

class WindowsTile extends StatefulWidget {
  const WindowsTile({
    required this.tileColor,
    required this.size,
    required this.primaryChild,
    required this.secondChild,
    required this.label,
    required this.delayInSec,
    super.key,
  });

  final Color tileColor;
  final double size;
  final Widget primaryChild;
  final Widget secondChild;
  final String label;
  final int delayInSec;

  @override
  State<WindowsTile> createState() => _WindowsTileState();
}

class _WindowsTileState extends State<WindowsTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _transitionAnimation;
  bool isTileLive = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    _transitionAnimation = Tween<double>(
      begin: widget.size,
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller
      ..reset()
      ..forward()
      ..addStatusListener(
        (status) async {
          if (isTileLive) {
            if (status == AnimationStatus.completed) {
              await Future.delayed(
                Duration(
                  seconds: widget.delayInSec,
                ),
                () {
                  _controller.reverse().then(
                        (value) => _controller.forward(),
                      );
                },
              );
            }
          }
        },
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
      child: SizedBox.square(
        dimension: widget.size,
        child: ColoredBox(
          color: widget.tileColor,
          child: Stack(
            fit: StackFit.expand,
            children: [
              widget.primaryChild,
              if (isTileLive)
                AnimatedBuilder(
                  animation: _controller,
                  builder: (_, child) {
                    if (child != null) {
                      return Positioned.fill(
                        top: _transitionAnimation.value,
                        child: child,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  child: ColoredBox(
                    color: widget.tileColor,
                    child: widget.secondChild,
                  ),
                ),
              Positioned(
                left: 10,
                bottom: 10,
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: PopupMenuButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: 0,
                        child: Text(
                          isTileLive ? 'Turn Off' : 'Turn On',
                        ),
                        onTap: () {
                          if (isTileLive) {
                            _controller.stop();
                            isTileLive = false;
                          } else {
                            _controller.forward(
                              from: 0,
                            );
                            isTileLive = true;
                          }
                          setState(() {});
                        },
                      ),
                    ];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
