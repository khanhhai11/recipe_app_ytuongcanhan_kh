import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
class SearchRecipeBar extends StatefulWidget {
  final Future<void> Function(String) onSearch;
  final String initialText;
  const SearchRecipeBar({super.key, required this.onSearch, this.initialText = ''});
  @override
  State<SearchRecipeBar> createState() => _SearchRecipeBarState();
}
class _SearchRecipeBarState extends State<SearchRecipeBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialText;
  }
  void _handleSearch(String text) async {
    if (text.isEmpty || _isLoading == true) return;
    setState(() => _isLoading = true);
    await widget.onSearch(text);
    setState(() {
      _isLoading = false;
      _controller.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _controller,
            cursorColor: Color(0xFFFF475D),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              hintText: 'Search any recipes',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            maxLines: 1,
            onSubmitted: _handleSearch,
          ),
        ),
        if (_isLoading == true)
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: SizedBox(
              height: 24,
              width: 24,
              child: LoadingIndicator(
                indicatorType: Indicator.circleStrokeSpin,
                colors: [Colors.black],
              ),
            ),
          ),
      ],
    );
  }
}
