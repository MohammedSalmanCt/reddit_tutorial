import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/theme/pallet.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeigthandWidth=120;
    double iconSize=60;
    final currentTheme=ref.watch(themeNotifierProvider);
    return Wrap(
      children: [
         GestureDetector(
           onTap: () {

           },
           child: SizedBox(
             height: cardHeigthandWidth,
             width: cardHeigthandWidth,
             child: Card(
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
               ),
               color: currentTheme.backgroundColor,
               elevation: 16,
               child:  Center(child: Icon(Icons.image_outlined,size: iconSize,)),
             ),
           ),
         ),
        GestureDetector(
           onTap: () {

           },
           child: SizedBox(
             height: cardHeigthandWidth,
             width: cardHeigthandWidth,
             child: Card(
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
               ),
               color: currentTheme.backgroundColor,
               elevation: 16,
               child:  Center(child: Icon(Icons.download_outlined,size: iconSize,)),
             ),
           ),
         ),
        GestureDetector(
           onTap: () {

           },
           child: SizedBox(
             height: cardHeigthandWidth,
             width: cardHeigthandWidth,
             child: Card(
               shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)
               ),
               color: currentTheme.backgroundColor,
               elevation: 16,
               child:  Center(child: Icon(Icons.link_outlined,size: iconSize,)),
             ),
           ),
         ),
      ],
    );
  }
}
