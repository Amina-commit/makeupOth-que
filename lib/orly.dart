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
  State<Orly> createState() => _OrlyState();
}

class _OrlyState extends State<Orly> {
  List<Map<String, dynamic>> dataMap = [];
  int id = 0;
  bool recupDataBool = false;
  bool auto = false;
  Produit? produitCourant;

  List<Produit> mesProduits = [];

  // AJOUT: Controller pour le champ de saisie d'ID
  final TextEditingController _idController = TextEditingController();

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

  // NOUVEAU: Méthode pour récupérer un produit spécifique par ID depuis l'API
  Future<Map<String, dynamic>?> recupererProduitParID(String productId) async {
    try {
      String url =
          "http://makeup-api.herokuapp.com/api/v1/products/$productId.json";
      var reponse = await http.get(Uri.parse(url));
      if (reponse.statusCode == 200) {
        return convert.jsonDecode(reponse.body);
      }
    } catch (e) {
      print('Erreur lors de la récupération du produit $productId: $e');
    }
    return null;
  }

  // AJOUT: Méthode pour ajouter le produit à la collection
  void ajouterProduit() {
    if (produitCourant != null) {
      setState(() {
        // Vérifier si le produit n'est pas déjà dans la collection
        bool existeDeja = mesProduits.any((p) => p.id == produitCourant!.id);
        if (!existeDeja) {
          mesProduits.add(produitCourant!);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${produitCourant!.name} ajouté à ma collection'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  '${produitCourant!.name} est déjà dans votre collection'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    }
  }

  // MODIFICATION: Méthode pour supprimer le produit affiché de l'API (dataMap)
  void supprimerProduitAffiche() {
    if (produitCourant != null && dataMap.isNotEmpty) {
      setState(() {
        // Sauvegarder le nom du produit pour le message
        String nomProduit = produitCourant!.name;

        // Supprimer le produit de dataMap
        dataMap.removeWhere((produit) => produit['id'] == produitCourant!.id);

        // Ajuster l'ID si nécessaire
        if (id >= dataMap.length) {
          id = dataMap.length > 0 ? dataMap.length - 1 : 0;
        }

        // Mettre à jour le produit courant
        if (dataMap.isNotEmpty) {
          updateProduitCourant();
        } else {
          produitCourant = null;
          recupDataBool = false;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$nomProduit supprimé de la liste'),
            backgroundColor: Colors.red,
          ),
        );
      });
    }
  }

  // AJOUT: Méthode pour supprimer un produit par ID de l'API (dataMap)
  void supprimerProduitParID() {
    String idText = _idController.text.trim();
    if (idText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez saisir un ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      // Trouver le produit par ID
      Map<String, dynamic>? produitASupprimer;
      try {
        produitASupprimer = dataMap.firstWhere(
          (produit) => produit['id']?.toString() == idText,
        );
      } catch (e) {
        produitASupprimer = null;
      }

      if (produitASupprimer != null) {
        String nomProduit =
            produitASupprimer['name']?.toString() ?? 'Produit inconnu';

        // Supprimer le produit de dataMap
        dataMap.removeWhere((produit) => produit['id']?.toString() == idText);

        // Ajuster l'ID si nécessaire
        if (id >= dataMap.length) {
          id = dataMap.length > 0 ? dataMap.length - 1 : 0;
        }

        // Mettre à jour le produit courant
        if (dataMap.isNotEmpty) {
          updateProduitCourant();
        } else {
          produitCourant = null;
          recupDataBool = false;
        }

        _idController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$nomProduit supprimé de la liste'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aucun produit trouvé avec l\'ID $idText'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  // MODIFICATION: Méthode pour ajouter un produit par ID à dataMap
  void ajouterProduitParID() async {
    String idText = _idController.text.trim();
    if (idText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez saisir un ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Vérifier si le produit existe déjà dans dataMap
    bool existeDeja =
        dataMap.any((produit) => produit['id']?.toString() == idText);
    if (existeDeja) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le produit avec l\'ID $idText est déjà dans la liste'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Afficher un indicateur de chargement
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(width: 10),
            Text('Recherche du produit...'),
          ],
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 5),
      ),
    );

    // Récupérer le produit depuis l'API
    Map<String, dynamic>? nouveauProduitData =
        await recupererProduitParID(idText);

    if (nouveauProduitData != null) {
      setState(() {
        // Ajouter le nouveau produit à dataMap
        dataMap.add(nouveauProduitData);

        // Mettre à jour l'ID courant pour pointer vers le nouveau produit
        id = dataMap.length - 1;
        updateProduitCourant();

        _idController.clear();

        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${nouveauProduitData['name']} ajouté à la liste'),
            backgroundColor: Colors.green,
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aucun produit trouvé avec l\'ID $idText'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // NOUVEAU: Méthode pour ajouter le produit affiché à dataMap (dupliquer)
  void dupliquerProduitAffiche() {
    if (produitCourant != null) {
      setState(() {
        // Créer une copie du produit courant avec un nouvel ID
        var nouveauProduit = Map<String, dynamic>.from(dataMap[id]);
        String nouvelID =
            '${produitCourant!.id}_copy_${DateTime.now().millisecondsSinceEpoch}';
        nouveauProduit['id'] = nouvelID;
        nouveauProduit['name'] = '${produitCourant!.name} (Copie)';

        // Ajouter à dataMap
        dataMap.add(nouveauProduit);

        // Mettre à jour l'ID courant pour pointer vers le nouveau produit
        id = dataMap.length - 1;
        updateProduitCourant();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${produitCourant!.name} dupliqué dans la liste'),
            backgroundColor: Colors.blue,
          ),
        );
      });
    }
  }

  // AJOUT: Méthode pour ajouter un produit à la collection personnelle
  void ajouterProduitCollectionParID() {
    String idText = _idController.text.trim();
    if (idText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veuillez saisir un ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Rechercher le produit dans dataMap
    Map<String, dynamic>? produitData;
    try {
      produitData = dataMap.firstWhere(
        (produit) => produit['id']?.toString() == idText,
      );
    } catch (e) {
      produitData = null;
    }

    if (produitData != null) {
      Produit nouveauProduit = Produit(
        id: produitData['id'] ?? '',
        name: produitData['name']?.toString() ?? 'Sans nom',
        brand: produitData['brand']?.toString() ?? 'Marque inconnue',
        price: produitData['price']?.toString() ?? '0.0',
        price_sign: produitData['price_sign']?.toString() ?? '\$',
        image_link: produitData['image_link']?.toString() ?? '',
        product_type: produitData['product_type']?.toString() ?? '',
        description: produitData['description']?.toString() ?? '',
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

      setState(() {
        bool existeDeja = mesProduits.any((p) => p.id == nouveauProduit.id);
        if (!existeDeja) {
          mesProduits.add(nouveauProduit);
          _idController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${nouveauProduit.name} ajouté à ma collection'),
              backgroundColor: const Color.fromARGB(255, 116, 22, 66),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('${nouveauProduit.name} est déjà dans votre collection'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Aucun produit trouvé avec l\'ID $idText dans la liste actuelle'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // AJOUT: Méthode pour supprimer un produit de la collection
  void supprimerProduit(Produit produit) {
    setState(() {
      mesProduits.remove(produit);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${produit.name} supprimé de la collection'),
          backgroundColor: const Color.fromARGB(255, 204, 47, 170),
        ),
      );
    });
  }

  // AJOUT: Méthode pour voir la collection
  void voirCollection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ma Collection (${mesProduits.length})'),
        content: mesProduits.isEmpty
            ? Text('Aucun produit dans la collection')
            : Container(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: mesProduits.length,
                  itemBuilder: (context, index) {
                    Produit produit = mesProduits[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        leading: produit.image_link.isNotEmpty
                            ? Image.network(produit.image_link,
                                width: 40, height: 40, fit: BoxFit.cover)
                            : Icon(Icons.photo),
                        title: Text(produit.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${produit.id}'),
                            Text(
                                '${produit.brand} • ${produit.price}${produit.price_sign}'),
                          ],
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete,
                              color: const Color.fromARGB(255, 119, 20, 94)),
                          onPressed: () => supprimerProduit(produit),
                        ),
                      ),
                    );
                  },
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fermer'),
          ),
        ],
      ),
    );
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
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.collections),
                onPressed: voirCollection,
                tooltip: 'Ma collection',
              ),
              if (mesProduits.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      mesProduits.length.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
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
            // MODIFICATION: Champ pour saisir l'ID avec boutons multiples
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: "ID du produit",
                      border: OutlineInputBorder(),
                      hintText: "Saisir l'ID",
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Bouton pour ajouter à dataMap
                      ElevatedButton(
                        onPressed: ajouterProduitParID,
                        child: Text('Ajouter à liste'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 199, 47, 153),
                          foregroundColor: Colors.white,
                        ),
                      ),

                      // Bouton pour supprimer
                      ElevatedButton(
                        onPressed: supprimerProduitParID,
                        child: Text('Supprimer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

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

              Text(
                produitCourant!.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                'ID: ${produitCourant!.id}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '${produitCourant!.brand} • ${produitCourant!.price}${produitCourant!.price_sign}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 15),

              Chip(
                label: Text(produitCourant!.product_type),
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
              ),

              const SizedBox(height: 15),

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

              Text(
                'Produit ${id + 1} sur ${dataMap.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 20),

              // MODIFICATION: Boutons pour gérer le produit affiché
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: ajouterProduit,
                        icon: Icon(Icons.add),
                        label: Text('Ajouter collection'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 175, 76, 142),
                          foregroundColor: Colors.white,
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: supprimerProduitAffiche,
                        icon: Icon(Icons.delete),
                        label: Text('Supprimer liste'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (produitCourant != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    mesProduits.any((p) => p.id == produitCourant!.id)
                        ? '✓ Dans votre collection'
                        : '✗ Pas dans votre collection',
                    style: TextStyle(
                      color: mesProduits.any((p) => p.id == produitCourant!.id)
                          ? Colors.green
                          : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ] else if (!recupDataBool) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Chargement des produits...'),
            ] else if (recupDataBool && dataMap.isEmpty) ...[
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              const Text('Aucun produit trouvé'),
            ] else ...[
              const Icon(Icons.error_outline, size: 50, color: Colors.red),
              const SizedBox(height: 20),
              Text('Aucun produit trouvé à l\'index: $id'),
            ],

            const SizedBox(height: 30),

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

            Column(
              children: [
                Text(
                  '${dataMap.length} produit(s) dans la liste',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  '${mesProduits.length} produit(s) dans ma collection',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
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

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }
}
