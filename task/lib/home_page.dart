import 'package:flutter/material.dart';
import 'package:task/widgets/product_list.dart';
import 'package:task/services/json_service.dart';
import 'models/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  List<Product> allProducts = [];
  List<String> cityFilter = [];
  List<String> categoryFilter = ["Shoes", "Bag", "Computer"];
  List<String> category = ["Shoes", "Bag", "Computer"];

  String? selectedValueCategory, selectedValueState, selectedValueCity;
  String defaultState = "states";
  String defaultCity = "cities";

  @override
  void setState(VoidCallback fn) async {
    allProducts.clear();
    allProducts = await getAllProductList();

    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: buildEndDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                height: 70,
                width: 400,
                color: Colors.green[100],
                alignment: Alignment.center,
                child: const Text("Product List"),
              ),
              buildCatalog(),
            ],
          ),
        ),
      ),
    );
  }

  buildCatalog() {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: categoryFilter.length,
        itemBuilder: (context, index) {
          return buildFiltermCatalog(
              cCategory: categoryFilter[index].toString());
        },
      ),
    );
  }

  buildFiltermCatalog({required String cCategory}) {
    return Column(
      children: [
        ListTile(
          title: Text(cCategory),
          tileColor: Colors.brown[100],
        ),
        SizedBox(
          height: 120,
          child: getProductListByCategories(
            allProduct: allProducts,
            category: selectedValueCategory ?? cCategory,
          ),
        ),
      ],
    );
  }

  buildEndDrawer() {
    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              buildCategoryFilter(),
              buildStateList(),
              buildCityList(state: selectedValueState),
              ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      categoryFilter.clear();
                      categoryFilter.addAll(category);
                      allProducts.clear();
                      selectedValueCity = defaultCity;
                      selectedValueState = defaultState;
                    });
                    allProducts = await getAllProductList();
                  },
                  child: const Text("clear filter")),
            ],
          ),
        ),
      ),
    );
  }

  buildCategoryFilter() {
    return DropdownButton(
      items: category
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        for (var element in category) {
          if (element.contains(selected.toString())) {
            setState(() {
              categoryFilter.clear();
              selectedValueCategory = selected.toString();
              categoryFilter.add(element);
            });
          }
        }
      },
      hint: Text(selectedValueCategory ?? "category"),
    );
  }

  builddropDownState(List<String> states) {
    return DropdownButton(
      items: states
          .map((e) => DropdownMenuItem(
                child: Text(e.toString()),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        for (var element in category) {
          if (element.contains(selected.toString())) {
            setState(() {
              categoryFilter.clear();
              selectedValueCategory = selected.toString();
              categoryFilter.add(element);
            });
          }
        }
        setState(() {
          selectedValueState = selected.toString();
          selectedValueCity = selected.toString() + " cities";
        });

        //empty
      },
      hint: Text(selectedValueState ?? defaultState),
    );
  }

  buildDropDownCity(List<String> list) {
    return DropdownButton(
      items: list
          .map((e) => DropdownMenuItem(
                child: Text(e),
                value: e,
              ))
          .toList(),
      onChanged: (selected) {
        setState(() {
          selectedValueCity = selected.toString();
        });

        for (var element in category) {
          if (element.contains(selected.toString())) {
            setState(() {
              categoryFilter.add(element);
            });
          }
        }
      },
      hint: Text(selectedValueCity ?? defaultCity),
    );
  }

  List<Product> filterState() {
    List<Product> fp = [];

    for (var item in allProducts) {
      if (item.state.contains(selectedValueState!)) {
        fp.add(item);
      }
    }

    return fp;
  }

  FutureBuilder<List> buildStateList({String? state}) {
    return FutureBuilder<List>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> states = [];
          for (int i = 0; i < snapshot.data!.length; i++) {
            states.add(snapshot.data[i].name);
          }

          return builddropDownState(states);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: getAllStateList(),
    );
  }

  FutureBuilder<List> buildCityList({String? state}) {
    return FutureBuilder<List>(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          List<String> cities = [];
          if (state != null || state?.isEmpty == true) {
            for (int i = 0; i < snapshot.data!.length; i++) {
              if (snapshot.data[i].name.contains(state)) {
                cities.addAll(snapshot.data[i].cities);
              }
            }
          } else {
            for (int i = 0; i < snapshot.data!.length; i++) {
              cities.addAll(snapshot.data[i].cities);
            }
          }
          return buildDropDownCity(cities);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(child: CircularProgressIndicator());
      },
      future: getAllStateList(),
    );
  }
}
