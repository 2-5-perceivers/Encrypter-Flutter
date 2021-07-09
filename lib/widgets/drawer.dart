import 'package:flutter/material.dart';

import 'package:encrypter/widgets/waves.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Stack(children: [
              ClipRect(child: EncrypterWaves()),
              Container(
                alignment: AlignmentDirectional(-0.8, 0.8),
                child: Text(
                  "Encrypter",
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ]),
            padding: EdgeInsets.zero,
          ),
          ListTile(
            title: Text('Encrypt text'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            },
          ),
          ListTile(
            title: Text('Encrypt files'),
            onTap: () {},
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/about");
            },
          ),
        ],
      ),
    );
  }
}
