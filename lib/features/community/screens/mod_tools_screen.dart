import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  const ModToolsScreen({super.key,required this.name});
  final String name;
  void navigateToEditCommunity(BuildContext context,cname)
  {
    Routemaster.of(context).push('/edit-community/$cname');
  }
  void navigateToAddMods(BuildContext context,cname)
  {
    Routemaster.of(context).push('/add_mods/${cname}');
  }
  @override
  Widget build(BuildContext context) {
    String cName = Uri.decodeComponent(name);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mod Tools"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text("Add Moderators"),
          onTap: () {
            navigateToAddMods(context,cName);
          },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit community"),
            onTap: (){
              navigateToEditCommunity(context,cName);
            }
          )
        ],
      ),
    );
  }
}
