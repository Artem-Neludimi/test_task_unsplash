import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_unsplash/ui/pages/photo/photo_page.dart';

import '../../../constants.dart';
import '../../../networking/client/photo_client.dart';
import '../../widgets/photo_widget.dart';
import '/networking/models/photo_models.dart';
import 'bloc/home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = ScrollController();
  late HomeBloc bloc;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        bloc.add(HomeNewPageEvent());
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bloc = HomeBloc(PhotoClient());
    List<PhotoModel>? photos;
    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ErrorState) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          if (state is HomeInitial || state is ErrorState) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (state is HomeLoadPhotosState) {
            photos = state.photos;
            if (_controller.hasClients && state.isChangedTitle) {
              _controller.jumpTo(_controller.position.minScrollExtent);
            }
          }
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              title: const Text(Constants.unsplashGallery),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              actions: [
                PopupMenuButton(
                  onSelected: (value) {
                    bloc.add(HomeChangeTitleEvent(value));
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 0,
                      child: Text(Constants.titles[0]),
                    ),
                    PopupMenuItem(
                      value: 1,
                      child: Text(Constants.titles[1]),
                    ),
                    PopupMenuItem(
                      value: 2,
                      child: Text(Constants.titles[2]),
                    ),
                  ],
                )
              ],
            ),
            body: Center(
              child: ListView.builder(
                controller: _controller,
                shrinkWrap: true,
                itemCount: photos!.length + 1,
                itemBuilder: (context, index) {
                  if (index < photos!.length) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PhotoPage(
                            photoUrl: photos![index].urls!['full'],
                          ),
                        ));
                      },
                      child: Stack(
                        children: [
                          PhotoWidget(
                              photoUrl: photos![index].urls!['regular']),
                          if (photos![index].user!['name'] != null)
                            Positioned(
                              right: 20,
                              bottom: 10,
                              child: Text(
                                photos![index].user!['name'],
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                              ),
                            ),
                          if (photos![index].description != null)
                            Positioned(
                              left: 10,
                              right: 10,
                              top: 10,
                              child: Wrap(
                                children: [
                                  Text(
                                    photos![index].description!,
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  } else {
                    return Container(
                      height: 64,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
