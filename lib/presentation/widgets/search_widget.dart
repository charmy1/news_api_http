import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_api_http_flutter/application/news_bloc/news_bloc.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
  });

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 5, right: 10, bottom: 5),
      child: TextFormField(
        style: const TextStyle(color: Colors.black, fontSize: 18),
        controller: controller,
        onChanged: (value) {

          context.read<NewsBloc>()
              .add(const NewsEvent.pageCountEventReset());

          context
              .read<NewsBloc>()
              .add(NewsEvent.textChangedEvent(searchQuery: value));

          context
              .read<NewsBloc>()
              .add(const NewsEvent.searchQueryChangedEvent());
        },
        decoration:  InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 0,
              color: Colors.white,
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          prefixIcon:  const Icon(
            Icons.search,
            color: Colors.black,
          ),
          suffixIcon: IconButton(icon: const Icon(
            Icons.close,
            color: Colors.black,
          ), onPressed: (){
            controller.clear();
            context
                .read<NewsBloc>().add(const NewsEvent.readNewsEvent());
          },),
          fillColor: const Color(0xFFFAFAFA),
          hintStyle: const TextStyle(color: Colors.black, fontSize: 18),
          hintText: "Search",

        ),

      ),
    );
  }
}
