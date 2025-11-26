import 'package:flutter_makeupiotheque/produit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/material.dart';

class AfficheProduit extends StatefulWidget {
  const AfficheProduit({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AfficheProduit> createState() => _AffichePageState();
}

class _AffichePageState extends State<AfficheProduit> {
  final _formKey = GlobalKey<FormState>();

  String txtButton = "Submit";
  bool _isLoading = false;

  Map<String, dynamic> dataMap = new Map();
  bool recupDataBool = false;
  int id = 1;

  Future<void> recupDataJson() async {
    String url = "http://makeup-api.herokuapp.com/api/v1/products.json?brand" +
        this.id.toString();
    var reponse = await http.get(Uri.parse(url));
    if (reponse.statusCode == 200) {
      dataMap = convert.jsonDecode(reponse.body);
      recupDataBool = true;
    } else {
      recupDataBool = false;
    }
  }

  startLoading() async {
    setState(() {
      _isLoading = true;
    });
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      await recupDataJson();
      if (recupDataBool) {
        Navigator.popAndPushNamed(context, '/affiche', arguments: dataMap);
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erreur dans recupération des informations."),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isNumeric(String s) {
    bool isnum = false;
    try {
      double.parse(s);
      isnum = true;
    } catch (e) {}
    return isnum;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "N° du Produit",
                    hintText: "Saisir l'id d'un Produit"),

                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value == null || value.isEmpty || !isNumeric(value)) {
                    return 'N° de Produit non valide !';
                  } else {
                    id = int.parse(value);
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: _isLoading ? null : startLoading,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
