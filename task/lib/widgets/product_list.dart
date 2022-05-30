import 'package:flutter/material.dart';
import 'package:task/services/json_service.dart';
import 'package:task/models/product.dart';

FutureBuilder getProductListByCategories(
    {List<Product>? allProduct, String? category}) {
  return FutureBuilder<List<Product>>(
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData) {
        List<Product> products = <Product>[];

        if (category != null) {
          for (int i = 0; i < snapshot.data!.length; i++) {
            if (snapshot.data[i].category.contains(category)) {
              products.add(snapshot.data[i]);
            }
          }
          allProduct = products;
        } else {
          products.clear();
          products.addAll(snapshot.data);
        }
        return buildProductList(products);
      } else if (snapshot.hasError) {
        return Text("${snapshot.error}");
      }
      return const Center(child: CircularProgressIndicator());
    },
    future: getAllProductList(),
  );
}

Widget buildProductList(List<Product> cproducts) {
  return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: cproducts.length,
      itemBuilder: (_, index) {
        return Container(
          margin: const EdgeInsets.all(10),
          width: 150,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            color: Colors.blue[100 * (index + 1)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text("${index + 1}"),
                  ),
                  Text(cproducts[index].name.toString()),
                ],
              ),
              Text(cproducts[index].company.toString()),
              Text(cproducts[index].state.toString() +
                  " / " +
                  cproducts[index].city.toString()),
            ],
          ),
        );
      });
}
