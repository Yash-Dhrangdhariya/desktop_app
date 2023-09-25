import 'package:flutter/material.dart';
import 'package:windows_tile/resource/images.dart';
import 'package:windows_tile/widgets/dock_bar.dart';
import 'package:windows_tile/widgets/windows_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Home'),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Images.desktopBackground,
              fit: BoxFit.cover,
            ),
          ),
          WindowsTile(
            tileColor: const Color(0xff006DB3),
            size: 200,
            primaryChild: const Center(
              child: Icon(
                Icons.sunny,
                color: Colors.white,
                size: 80,
              ),
            ),
            secondChild: ListView(
              padding: const EdgeInsets.all(10),
              children: const [
                Text(
                  '74',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Temple\nClear\n75/97',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white38,
                  ),
                ),
              ],
            ),
            label: 'Weather',
            delayInSec: 5,
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: DockBar(
                dockPadding: 14,
                itemsSpacing: 14,
                dockSize: 80,
                items: [
                  Icons.person,
                  Icons.search,
                  Icons.flutter_dash,
                  Icons.backup_sharp,
                  Icons.calendar_today,
                  Icons.settings,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
