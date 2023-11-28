import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/community/controller/comminity_controller.dart';
import 'package:reddit_tutorial/features/post/controller/post_controller.dart';
import 'package:reddit_tutorial/models/community_model.dart';
import '../../../core/theme/pallet.dart';
import '../../../core/utils.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  const AddPostTypeScreen({super.key, required this.type});
  final String type;

  @override
  ConsumerState<AddPostTypeScreen> createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;

  File? bannerFile;
  late TextEditingController nameController;
  void selectBannerImage() async {
    final res = await filePicker();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void sharePost() {
    if (widget.type == "image" &&
        bannerFile != null &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareImagePost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          file: bannerFile);
    } else if (widget.type == "text" && titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareTextPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          description: descriptionController.text.trim());
    } else if (widget.type == "link" &&
        linkController.text.isNotEmpty &&
        titleController.text.isNotEmpty) {
      ref.read(postControllerProvider.notifier).shareLinkPost(
          context: context,
          title: titleController.text.trim(),
          selectedCommunity: selectedCommunity ?? communities[0],
          link: linkController.text.trim());
    }
    else
      {
        showSnackBar(context, "Please enter all fields");
      }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final isTypeImage = widget.type == "image";
    final isTypeText = widget.type == "text";
    final isTypeLink = widget.type == "link";
    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Post ${widget.type}"),
        centerTitle: true,
        actions: [TextButton(onPressed: () {
          sharePost();
        }, child: const Text("Share"))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                filled: true,
                hintText: "Enter Title here",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isTypeImage)
              GestureDetector(
                onTap: () => selectBannerImage(),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: bannerFile != null
                        ? Image.file(bannerFile!)
                        : const Center(
                            child: Icon((Icons.camera_alt_outlined), size: 40),
                          ),
                  ),
                ),
              ),
            if (isTypeText)
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Enter Description here",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
                maxLength: 30,
              ),
            if (isTypeLink)
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: "Enter Link here",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const Align(
                alignment: Alignment.topLeft, child: Text("Select Community")),
            ref.watch(userCommunitiesProvider).when(
              data: (data) {
                communities = data;
                if (data.isEmpty) {
                  return const SizedBox();
                }
                return DropdownButton(
                  value: selectedCommunity ?? data[0],
                  items: data
                      .map((e) =>
                          DropdownMenuItem(value: e, child: Text(e.name)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCommunity = val;
                    });
                  },
                );
              },
              error: (error, stackTrace) {
                return Text(error.toString());
              },
              loading: () {
                return Loader();
              },
            )
          ],
        ),
      ),
    );
  }
}
