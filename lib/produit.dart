import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_makeupiotheque/myhomePage.dart';

class Produit {
  final int id;
  final String brand;
  final String name;
  final String price;
  final String price_sign;
  final String currency;
  final String image_link;
  final String product_link;
  final String website_link;
  final String description;
  final String category;
  final String product_type;
  final List<dynamic> tag_list;
  final String created_at;
  final String updated_at;
  final String product_api_url;
  final String api_featured_image;
  Produit({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    required this.price_sign,
    required this.currency,
    required this.image_link,
    required this.product_link,
    required this.website_link,
    required this.description,
    required this.category,
    required this.product_type,
    required this.tag_list,
    required this.created_at,
    required this.updated_at,
    required this.product_api_url,
    required this.api_featured_image,
  });

  Produit copyWith({
    int? id,
    String? brand,
    String? name,
    String? price,
    String? price_sign,
    String? currency,
    String? image_link,
    String? product_link,
    String? website_link,
    String? description,
    String? category,
    String? product_type,
    List<dynamic>? tag_list,
    String? created_at,
    String? updated_at,
    String? product_api_url,
    String? api_featured_image,
  }) {
    return Produit(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      name: name ?? this.name,
      price: price ?? this.price,
      price_sign: price_sign ?? this.price_sign,
      currency: currency ?? this.currency,
      image_link: image_link ?? this.image_link,
      product_link: product_link ?? this.product_link,
      website_link: website_link ?? this.website_link,
      description: description ?? this.description,
      category: category ?? this.category,
      product_type: product_type ?? this.product_type,
      tag_list: tag_list ?? this.tag_list,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      product_api_url: product_api_url ?? this.product_api_url,
      api_featured_image: api_featured_image ?? this.api_featured_image,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'brand': brand,
      'name': name,
      'price': price,
      'price_sign': price_sign,
      'currency': currency,
      'image_link': image_link,
      'product_link': product_link,
      'website_link': website_link,
      'description': description,
      'category': category,
      'product_type': product_type,
      'tag_list': tag_list,
      'created_at': created_at,
      'updated_at': updated_at,
      'product_api_url': product_api_url,
      'api_featured_image': api_featured_image,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      id: (map['id'] is int)
          ? map['id']
          : int.tryParse(map['id'].toString()) ?? 0,
      brand: map['brand'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toString() ?? '0.0',
      price_sign: map['price_sign'],
      currency: map['currency'],
      image_link: map['image_link'] ?? '',
      product_link: map['product_link'] ?? '',
      website_link: map['website_link'] ?? '',
      description: map['description'] ?? '',
      category: map['category'],
      product_type: map['product_type'] ?? '',
      tag_list: List<dynamic>.from(map['tag_list'] ?? []),
      created_at: map['created_at'] ?? '',
      updated_at: map['updated_at'] ?? '',
      product_api_url: map['product_api_url'] ?? '',
      api_featured_image: map['api_featured_image'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Produit.fromJson(String source) =>
      Produit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Produit(id: $id, brand: $brand, name: $name, price: $price, price_sign: $price_sign, currency: $currency, image_link: $image_link, product_link: $product_link, website_link: $website_link, description: $description, category: $category, product_type: $product_type, tag_list: $tag_list, created_at: $created_at, updated_at: $updated_at, product_api_url: $product_api_url, api_featured_image: $api_featured_image,)';
  }

  @override
  bool operator ==(covariant Produit other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.brand == brand &&
        other.name == name &&
        other.price == price &&
        other.price_sign == price_sign &&
        other.currency == currency &&
        other.image_link == image_link &&
        other.product_link == product_link &&
        other.website_link == website_link &&
        other.description == description &&
        other.category == category &&
        other.product_type == product_type &&
        listEquals(other.tag_list, tag_list) &&
        other.created_at == created_at &&
        other.updated_at == updated_at &&
        other.product_api_url == product_api_url &&
        other.api_featured_image == api_featured_image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        brand.hashCode ^
        name.hashCode ^
        price.hashCode ^
        price_sign.hashCode ^
        currency.hashCode ^
        image_link.hashCode ^
        product_link.hashCode ^
        website_link.hashCode ^
        description.hashCode ^
        category.hashCode ^
        product_type.hashCode ^
        tag_list.hashCode ^
        created_at.hashCode ^
        updated_at.hashCode ^
        product_api_url.hashCode ^
        api_featured_image.hashCode;
  }
}
