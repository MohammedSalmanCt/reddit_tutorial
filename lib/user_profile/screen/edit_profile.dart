import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/user_profile/controller/user_profile_controller.dart';

import '../../core/common/loader.dart';
import '../../core/contants/constants.dart';
import '../../core/theme/pallet.dart';
import '../../core/utils.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;
  void selectBannerImage() async {
    final res = await filePicker();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await filePicker();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editProfile(
        context: context,
        profileFile: profileFile,
        bannerFile: bannerFile,
        name: nameController.text.trim());
  }

  @override
  void initState() {
    // TODO: implement initState
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentheme=ref.watch(themeNotifierProvider);
    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (data) {
        return Scaffold(
          backgroundColor:currentheme.backgroundColor,
          appBar: AppBar(
            title: const Text("Edit Profile"),
            centerTitle: false,
            actions: [
              TextButton(
                  onPressed: () {
                    print("ssssssssssssssssssssssss");
                    save();
                    print("object");
                  },
                  child: const Text("Save"))
            ],
          ),
          body: isLoading
              ? const Loader()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Stack(children: [
                          GestureDetector(
                            onTap: () => selectBannerImage(),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              radius: const Radius.circular(10),
                              dashPattern: const [10, 4],
                              strokeCap: StrokeCap.round,
                              color: Pallete
                                  .darkModeAppTheme.textTheme.bodyText2!.color!,
                              child: Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                child: bannerFile != null
                                    ? Image.file(bannerFile!)
                                    : data.banner.isEmpty ||
                                            data.banner ==
                                                Constants.bannerDefault
                                        ? const Center(
                                            child: Icon(
                                                (Icons.camera_alt_outlined),
                                                size: 40),
                                          )
                                        : Image.network(data.banner),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: () => selectProfileImage(),
                              child: profileFile != null
                                  ? CircleAvatar(
                                      backgroundImage: FileImage(profileFile!),
                                      radius: 32,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(data.profilePic),
                                      radius: 32,
                                    ),
                            ),
                          )
                        ]),
                      ),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          filled: true,
                          hintText: "Name",
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                        ),
                      )
                    ],
                  ),
                ),
        );
      },
      error: (error, stackTrace) {
        return Text(error.toString());
      },
      loading: () {
        return Loader();
      },
    );
  }
}
