import 'package:flutter/material.dart';
import 'package:flutter_makeupiotheque/orly.dart';
import 'package:flutter_makeupiotheque/produit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_makeupiotheque/main.dart';
import 'package:flutter_makeupiotheque/maybelline.dart';
import 'package:flutter_makeupiotheque/nyx.dart';
import 'package:flutter_makeupiotheque/afficheProduit.dart';
import 'package:flutter_makeupiotheque/orly.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Container(
                  height: 150,
                  width: double.maxFinite,
                  color: const Color.fromARGB(255, 6, 124, 32),
                  child: Image.asset(
                    'images/makeup.png',
                  )),
            ),
            ListTile(
              title: const Text('Maybelline'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Maybelline(title: 'Maybelline'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Nyx'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nyx(title: 'Nyx'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Orly'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Orly(title: 'Orly'),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('afficher Produit'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AfficheProduit(title: 'Afficher Produit'),
                  ),
                );
              },
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'images/makeup.jpeg',
                )),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Maybelline(title: 'Maybelline'),
                  ),
                );
              },
              child: const Text('Maybelline'),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Nyx(title: 'Nyx'),
                  ),
                );
              },
              child: const Text('Nyx'),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Orly(title: 'Orly'),
                  ),
                );
              },
              child: const Text('Orly'),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AfficheProduit(title: 'Afficher Produit'),
                  ),
                );
              },
              child: const Text('Afficher Produit'),
            ),
          ],
        ),
      ),
    );
  }
}
