import 'package:flutter/material.dart';
import 'package:new_api_http_flutter/presentation/widgets/home/top_menu_tiles.dart';

class TopSelection extends StatelessWidget {
  final List<String> list;

  const TopSelection({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        itemCount: list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return TopMenuTiles(
            name: list[index],
            index: index,
          );
        },
      ),
    );
  }
}