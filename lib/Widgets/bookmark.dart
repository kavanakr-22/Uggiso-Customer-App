import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uggiso/Bloc/FavouritesBloc/FavouritesBloc.dart';
import 'package:uggiso/base/common/utils/colors.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  Widget buildEmptyGrid() {
    return const Center(
      child: Text(
        "No bookmarks yet",
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  final FavouritesBloc _favoritesBloc = FavouritesBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=> _favoritesBloc,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back, // iOS-style back arrow
              color: AppColors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          title: const Text(
            "Your Collections",
            style: TextStyle(color: AppColors.black),
          ),
          titleSpacing: 16,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFFFB508),
                  Color(0xFFF6D365),
                ],
              ),
            ),
          ),
        ),
        body: buildEmptyGrid(),
      ),
    );
  }
}
