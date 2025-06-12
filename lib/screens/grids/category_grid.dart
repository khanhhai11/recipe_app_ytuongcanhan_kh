import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/services/network.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/router.dart';
class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});
  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}
class _CategoryGridState extends State<CategoryGrid> {
  List<Category> _categories = [];
  bool _isCategoriesLoading = true;
  List<dynamic> _areas = [];
  bool _isAreasLoading = true;
  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _fetchAreas();
  }
  Future<void> _fetchCategories() async {
    final rawCategories = await fetchCategories();
    final List<Category> categories = rawCategories.map<Category>((recipeCategories) {
      return Category(
        id: recipeCategories['idCategory'] ?? '',
        name: recipeCategories['strCategory'] ?? '',
        thumbnail: recipeCategories['strCategoryThumb'] ?? '',
        description: recipeCategories['strCategoryDescription'] ?? '',
      );
    }).toList();
    setState(() {
      _categories = categories;
      _isCategoriesLoading = false;
    });
  }
  Future<void> _fetchAreas() async {
    final rawAreas = await fetchAreas();
    setState(() {
      _areas = rawAreas;
      _isAreasLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFFEFF1F7),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Select Categories!',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 26,
              color: Colors.black87,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF475D),
            labelColor: Color(0xFFFF475D),
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: 'Categories'),
              Tab(text: 'Areas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _isCategoriesLoading
                ? Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin,
                  colors: [Color(0xFFFF475D)],
                  strokeWidth: 5.0,
                ),
              ),
            )
                : (_categories.isEmpty
                ? const Center(child: Text('No categories found.'))
                : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: _categories.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 2,
              ),
              itemBuilder: (context, index) {
                final category = _categories[index];
                return InkWell(
                  onTap: () {
                    context.goNamed(
                      Screen.search.name,
                      extra: {
                        'searchText': category.name,
                        'isFromCategory': true,
                        'isFromArea': false,
                        'isFromSuggestion': false,
                      },
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFFF475D),
                        width: 2,
                      ),
                    ),
                    elevation: 4,
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12)),
                            child: Image.network(
                              category.thumbnail,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            category.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
            _isAreasLoading
                ? Center(
              child: SizedBox(
                width: 50,
                height: 50,
                child: LoadingIndicator(
                  indicatorType: Indicator.circleStrokeSpin,
                  colors: [Color(0xFFFF475D)],
                  strokeWidth: 5.0,
                ),
              ),
            )
                : ( _areas.isEmpty
                ? const Center(child: Text('No areas found.'))
                : ListView.separated(
              padding: const EdgeInsets.all(10),
              itemCount: _areas.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 10, color: Colors.grey),
              itemBuilder: (context, index) {
                final area = _areas[index];
                final areaName = area['strArea'] ?? 'Unknown';
                return ListTile(
                  title: Text(areaName),
                  onTap: () {
                    context.goNamed(
                      Screen.search.name,
                      extra: {
                        'searchText': areaName,
                        'isFromCategory': false,
                        'isFromArea': true,
                        'isFromSuggestion': false,
                      },
                    );
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}