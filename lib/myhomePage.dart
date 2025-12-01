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
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'images/makeup.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Makeupothèque',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('Maybelline'),
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
              title: Text('Nyx'),
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
              title: Text('Orly'),
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
              title: Text('Afficher Produit'),
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
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Image principale sur toute la largeur
            Container(
              height: 250,
              width: double.infinity,
              child: Image.asset(
                'images/makeup.jpeg',
                fit: BoxFit.cover,
              ),
            ),

            // Titre de bienvenue
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Bienvenue dans votre Makeupothèque',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Découvrez notre collection de produits de maquillage et gérez vos favoris',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 30),

            // Grille de boutons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Première ligne de boutons
                  Row(
                    children: [
                      Expanded(
                        child: _buildBrandCard(
                          context,
                          'Maybelline',
                          Colors.pink,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const Maybelline(title: 'Maybelline'),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildBrandCard(
                          context,
                          'Nyx',
                          Colors.purple,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Nyx(title: 'Nyx'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 15),

                  // Deuxième ligne de boutons
                  Row(
                    children: [
                      Expanded(
                        child: _buildBrandCard(
                          context,
                          'Orly',
                          Colors.orange,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Orly(title: 'Orly'),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: _buildBrandCard(
                          context,
                          'Mes Produits',
                          Colors.blue,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AfficheProduit(
                                    title: 'Afficher Produit'),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget pour les cartes de marques (sans icônes)
  Widget _buildBrandCard(
      BuildContext context, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 100,
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
