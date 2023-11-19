import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';

import '../controller/comminity_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();
  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    communityNameController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading=ref.watch(communityControllerProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Create a community"),
      ),
      body: isLoading?Loader():Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.topLeft, child: Text("Community Name")),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                  hintText: "Community name",
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18)),
              maxLength: 21,
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                createCommunity();
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              child: const Text("Create community"),
            )
          ],
        ),
      ),
    );
  }
}
