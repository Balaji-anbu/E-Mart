// import 'dart:convert';
// import 'package:e_mart/constants/colors.dart';
// import 'package:e_mart/products/product_model.dart';
// import 'package:e_mart/widgets/cart_model.dart';
// import 'package:e_mart/widgets/product_model.dart';
// import 'package:flutter/material.dart';
// import 'package:e_mart/constants/sizes.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';

// class SearchTextBar extends StatefulWidget {
//   const SearchTextBar({super.key});

//   @override
//   _SearchTextBarState createState() => _SearchTextBarState();
// }

// class _SearchTextBarState extends State<SearchTextBar> {
//   List<String> searchHistory = [];

//   Future<List<Product>> fetchProducts() async {
//     final String response = await rootBundle.loadString('asset/json_files/samplej.json');
//     final data = await json.decode(response);
//     return (data['products'] as List)
//         .map((productJson) => Product.fromJson(productJson))
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: GSizes.md, right: GSizes.md, bottom: GSizes.sm),
//       child: Form(
//         child: TextFormField(
//           onTap: () async {
//             List<Product> products = await fetchProducts();
//             showSearch(
//               context: context,
//               delegate: ProductSearchDelegate(
//                 products: products,
//                 searchHistory: searchHistory,
//               ),
//             ).then((_) {
//               // Update the search history after the search is closed
//               setState(() {});
//             });
//           },
//           decoration: const InputDecoration(
//             suffixIcon: Icon(Icons.search),
//             labelText: 'Search here',
//             iconColor: GColors.iconPrimary
//           ),
//         ),
//       ),
//     );
//   }
// }


// class ProductSearchDelegate extends SearchDelegate<Product?> {
//   final List<Product> products;
//   final List<String> searchHistory;

//   ProductSearchDelegate({required this.products, required this.searchHistory});

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(
//         onPressed: () {
//           query = '';
//           showSuggestions(context); // Show recent searches after clearing the query
//         },
//         icon: Icon(Icons.clear,color: GColors.iconPrimary,size: GSizes.iconMd1,),
//       ),
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         close(context, null);
//       },
//       icon:  Icon(Icons.arrow_back,color: GColors.iconPrimary,size: GSizes.iconMd1,),
//     );
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     List<Product> matchQuery = products
//         .where((product) =>
//         product.title.toLowerCase().startsWith(query.toLowerCase()))
//         .toList();

//     if (matchQuery.isEmpty) {
//       return Center(
//         child: Text(
//           'No products found for "$query"',
//           style:  TextStyle(fontSize: GSizes.fontSizeLg, color: GColors.textDisabled,fontWeight: FontWeight.w500),
//         ),
//       );
//     }

//     // Add the query to the search history
//     if (query.isNotEmpty && !searchHistory.contains(query)) {
//       searchHistory.insert(0, query);
//       if (searchHistory.length > 5) {
//         searchHistory.removeLast();
//       }
//     }

//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: GSizes.md, vertical: GSizes.sm),
//           child: ListTile(
//             leading: Image.asset(result.images.first, width: 50, height: 50),
//             title: Text(result.title),
//             subtitle: Text('\$${result.options.first.price.toStringAsFixed(1)}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon:  Icon(Icons.favorite_border),
//                   onPressed: () {},
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final cart = Provider.of<Cart>(context, listen: false);
//                     cart.addItem(
//                       result.id as Product,
//                       result.title,
//                       result.images.first,
//                       result.options.first.price,
//                       result.description,
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('${result.title} added to cart'),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   },

//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(horizontal: GSizes.md),
//                   ),
//                   child: const Text('Add'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     if (query.isEmpty) {
//       // Display search history when the query is empty
//       return ListView.builder(
//         itemCount: searchHistory.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             leading:  Icon(Icons.history,color: GColors.iconPrimary,size: GSizes.iconMd1,),
//             title: Text(searchHistory[index],style: TextStyle(color: GColors.textPrimary,fontSize: GSizes.fontSizeMd),),
//             trailing: IconButton(onPressed: (){}, icon: Icon(Icons.clear_sharp,size: GSizes.iconSm1,color: GColors.iconPrimary,)),
//             onTap: () {
//               query = searchHistory[index];
//               showResults(context);
//             },
//           );
//         },
//       );
//     }

//     List<Product> matchQuery = products
//         .where((product) =>
//         product.title.toLowerCase().startsWith(query.toLowerCase()))
//         .toList();

//     if (matchQuery.isEmpty) {
//       return Center(
//         child: Text(
//           'No suggestions found for "$query"',
//           style:  TextStyle(fontSize: GSizes.fontSizeLg, color: GColors.textDisabled,fontWeight: FontWeight.w500),
//         ),
//       );
//     }

//     return ListView.builder(
//       itemCount: matchQuery.length,
//       itemBuilder: (context, index) {
//         var result = matchQuery[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: GSizes.md, vertical: GSizes.sm),
//           child: ListTile(
//             leading: Image.asset(result.images.first, width: 50, height: 50),
//             title: Text(result.title),
//             subtitle: Text('\$${result.options.first.price.toStringAsFixed(2)}'),
//             trailing: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.favorite_border),
//                   onPressed: () {},
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     final cart = Provider.of<Cart>(context, listen: false);
//                     cart.addItem(
//                       result.id,
//                       result.title,
//                       result.images.first,
//                       result.options.first.price,
//                       result.description,
//                     );
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text('${result.title} added to cart'),
//                         duration: const Duration(seconds: 2),
//                       ),
//                     );
//                   },

//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.symmetric(horizontal: GSizes.md),
//                   ),
//                   child: const Text('Add'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }






// // onTap: () {
// // query = result.title;
// // showResults(context);
// // },