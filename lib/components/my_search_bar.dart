import 'package:flutter/material.dart';

class MySearchBar extends StatefulWidget {
  void Function(String?) onTextChanged;

  MySearchBar({super.key,required this.onTextChanged});

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    controller.addListener(onTextChanged);
  }
  void onTextChanged() {
      widget.onTextChanged(controller.text);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey, width: 0.8),
        borderRadius: BorderRadius.circular(10),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Icon(Icons.search,size: 30),
            const SizedBox(width: 10,),
            Expanded(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}