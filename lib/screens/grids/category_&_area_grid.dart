import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_app/models/category.dart';
import 'package:recipe_app/router.dart';
import 'package:recipe_app/widgets/settings_button.dart';
import 'package:recipe_app/data/categories.dart';
import 'package:recipe_app/data/areas.dart';
import 'package:country_flags/country_flags.dart';
class CategoryAndAreaGrid extends StatefulWidget {
  const CategoryAndAreaGrid({super.key});
  @override
  State<CategoryAndAreaGrid> createState() => _CategoryAndAreaGridState();
}
class _CategoryAndAreaGridState extends State<CategoryAndAreaGrid> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Category> categories = Categories;
  final List<String> areas = Areas;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState((){});
    });
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFEFF1F7),
        elevation: 0,
        centerTitle: true,
        title: Text(
          _tabController.index == 0? 'Select Categories!': 'Select Areas!',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 26,
            color: Colors.black87,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: SettingsButton(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) {
            setState((){});
          },
          indicatorColor: const Color(0xFFFF475D),
          labelColor: const Color(0xFFFF475D),
          unselectedLabelColor: Colors.black54,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Areas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          categories.isEmpty
              ? const Center(child: Text('No categories found.'))
              : GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (context, index) {
              final category = categories[index];
              return InkWell(
                onTap: () {
                  context.goNamed(Screen.category_details.name, extra: category);
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          areas.isEmpty
              ? const Center(child: Text('No areas found.'))
              : ListView.separated(
            padding: const EdgeInsets.all(10),
            itemCount: areas.length,
            separatorBuilder: (_, __) => const Divider(height: 10, color: Colors.grey),
            itemBuilder: (context, index) {
              final areaName = areas[index];
              return ListTile(
                leading: CountryFlag.fromCountryCode(
                  _getCountryCode(areaName),
                  height: 32,
                  width: 48,
                  shape: RoundedRectangle(6),
                ),
                title: Text(areaName),
                onTap: () {
                  context.goNamed(
                    Screen.search.name,
                    extra: {
                      'searchText': areaName,
                      'isFromArea': true,
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
  String _getCountryCode(String areaName) {
    final areaCode = {
      'American': 'us',
      'British': 'gb',
      'Canadian': 'ca',
      'Chinese': 'cn',
      'Croatian': 'hr',
      'Dutch': 'nl',
      'Egyptian': 'eg',
      'Filipino': 'ph',
      'French': 'fr',
      'Greek': 'gr',
      'Indian': 'in',
      'Irish': 'ie',
      'Italian': 'it',
      'Jamaican': 'jm',
      'Japanese': 'jp',
      'Kenyan': 'ke',
      'Malaysian': 'my',
      'Mexican': 'mx',
      'Moroccan': 'ma',
      'Polish': 'pl',
      'Portuguese': 'pt',
      'Russian': 'ru',
      'Spanish': 'es',
      'Thai': 'th',
      'Tunisian': 'tn',
      'Turkish': 'tr',
      'Ukrainian': 'ua',
      'Uruguayan': 'uy',
      'Vietnamese': 'vn',
      'Unknown': 'xx',
    };
    return areaCode[areaName] ?? 'xx';
  }
}