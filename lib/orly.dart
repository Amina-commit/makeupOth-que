import 'dart:math';

import 'package:flutter_makeupiotheque/produit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_makeupiotheque/myhomePage.dart';

class Orly extends StatefulWidget {
  const Orly({super.key, required this.title});

  final String title;

  @override
  State<Orly> createState() => _Orly();
}

class _Orly extends State<Orly> {
  List<Map<String, dynamic>> dataMap = [];
  int id = 0;
  bool recupDataBool = false;
  bool auto = false;
  Produit? produitCourant;

  @override
  void initState() {
    super.initState();

    recupData();
  }

  void randomID() async {
    while (auto) {
      await Future.delayed(const Duration(seconds: 3));
      if (mounted && dataMap.isNotEmpty) {
        setState(() {
          id = Random().nextInt(dataMap.length);
        });
        updateProduitCourant();
      }
    }
  }

  void toggleAuto() {
    setState(() {
      auto = !auto;
    });
    if (auto) {
      randomID();
    }
  }

  Future<void> recupData() async {
    await recupDataJson();
    if (mounted && dataMap.isNotEmpty) {
      setState(() {
        updateProduitCourant();
      });
    }
  }

  // mettre à jour produitCourant
  void updateProduitCourant() {
    if (dataMap.isNotEmpty && id >= 0 && id < dataMap.length) {
      var produitData = dataMap[id];
      produitCourant = Produit(
        id: produitData['id'] ?? '',
        name: produitData['name']?.toString() ?? 'Sans nom',
        brand: produitData['brand']?.toString() ?? 'Marque inconnue',
        price: produitData['price']?.toString() ?? '0.0',
        price_sign: produitData['price_sign']?.toString() ?? '\$',
        image_link: produitData['image_link']?.toString() ?? '',
        product_type: produitData['product_type']?.toString() ?? '',
        description: produitData['description']?.toString() ?? '',
        // Ajoutez les autres champs nécessaires selon votre classe Produit
        currency: produitData['currency']?.toString() ?? '',
        product_link: produitData['product_link']?.toString() ?? '',
        website_link: produitData['website_link']?.toString() ?? '',
        category: produitData['category']?.toString() ?? '',
        tag_list: List<String>.from(produitData['tag_list'] ?? []),
        created_at: produitData['created_at']?.toString() ?? '',
        updated_at: produitData['updated_at']?.toString() ?? '',
        product_api_url: produitData['product_api_url']?.toString() ?? '',
        api_featured_image: produitData['api_featured_image']?.toString() ?? '',
      );
    } else {
      produitCourant = null;
    }
  }

  Future<void> recupDataJson() async {
    try {
      String url =
          "http://makeup-api.herokuapp.com/api/v1/products.json?brand=orly";
      var reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        List<dynamic> jsonList = convert.jsonDecode(reponse.body);
        dataMap = jsonList.cast<Map<String, dynamic>>();
        recupDataBool = true;

        if (dataMap.isNotEmpty && id >= dataMap.length) {
          id = 0;
        }
      } else {
        recupDataBool = false;
        print('Erreur HTTP: ${reponse.statusCode}');
      }
    } catch (e) {
      recupDataBool = false;
      print('Erreur lors du chargement: $e');
    }
  }

  Widget attente() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Text('En attente des données',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          CircularProgressIndicator(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(auto ? Icons.pause : Icons.play_arrow),
            onPressed: toggleAuto,
            tooltip: auto ? 'Arrêter auto' : 'Démarrer auto',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Affichage du produit
            if (recupDataBool && produitCourant != null) ...[
              // Image du produit
              if (produitCourant!.image_link.isNotEmpty)
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(produitCourant!.image_link),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Nom du produit
              Text(
                produitCourant!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              // Marque et prix
              Text(
                '${produitCourant!.brand} • ${produitCourant!.price}${produitCourant!.price_sign}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              // Type de produit
              Chip(
                label: Text(produitCourant!.product_type),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
              ),

              const SizedBox(height: 15),

              // Description
              if (produitCourant!.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    produitCourant!.description.length > 150
                        ? '${produitCourant!.description.substring(0, 150)}...'
                        : produitCourant!.description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),

              const SizedBox(height: 20),

              // ID actuel et position dans la liste
              Text(
                'Produit ${id + 1} sur ${dataMap.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else if (!recupDataBool) ...[
              // Indicateur de chargement
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Chargement des produits...'),
            ] else if (recupDataBool && dataMap.isEmpty) ...[
              // Aucun produit trouvé
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Aucun produit trouvé'),
            ] else ...[
              // Données chargées mais produitCourant null
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text('Aucun produit trouvé à l\'index: $id'),
            ],

            const SizedBox(height: 30),

            // Boutons de contrôle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (id > 0) {
                      setState(() {
                        id--;
                        updateProduitCourant();
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Précédent'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (dataMap.isNotEmpty && id < dataMap.length - 1) {
                      setState(() {
                        id++;
                        updateProduitCourant();
                      });
                    }
                  },
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Suivant'),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: recupData,
        tooltip: 'Recharger',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
