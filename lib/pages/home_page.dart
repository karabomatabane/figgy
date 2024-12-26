import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../bloc/gif_bloc.dart';
import '../models/gif.model.dart';
import '../widgets/gif_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final Map<GifClient, String> _lastFetchedQueries = {};
  final Map<GifClient, List<Gif>> _gifCache = {
    GifClient.giphy: [],
    GifClient.tenor: [],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 50.0,
            height: 50.0,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          // bottom border indicator
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(width: 2.0, color: Colors.black),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: (index) {
            if (_searchController.text.isNotEmpty) {
              final query = _searchController.text;
              final provider = (index == 0) ? GifClient.giphy : GifClient.tenor;

              // Only fetch if the query has changed for this provider
              if (_lastFetchedQueries[provider] != query) {
                context.read<GifBloc>().add(SearchGifs(
                      query: query,
                      provider: provider,
                    ));
                _lastFetchedQueries[provider] = query; // Update last query
              }
            }
          },
          tabs: const [
            Tab(text: 'Giphy'),
            Tab(text: 'Tenor'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0,
          vertical: 20.0,
        ),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for gifs',
                prefixIcon: const Icon(Icons.search),
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.black, width: 2.0),
                ),
              ),
              onSubmitted: (value) {
                final provider = (_tabController.index == 0)
                    ? GifClient.giphy
                    : GifClient.tenor;
                context
                    .read<GifBloc>()
                    .add(SearchGifs(query: value, provider: provider));
                _lastFetchedQueries[provider] = value; // Update last query
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Giphy Tab
                  _buildGifGrid(GifClient.giphy),
                  // Tenor Tab
                  _buildGifGrid(GifClient.tenor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGifGrid(GifClient provider) {
    return BlocBuilder<GifBloc, GifState>(
      builder: (context, state) {
        if (state is GifLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GifSuccess) {
          // Display the GIFs dynamically in a GridView
          _gifCache[provider] = (state.gifs
                  .where((gif) => gif.source == provider)
                  .toList()
                  .isNotEmpty
              ? state.gifs.where((gif) => gif.source == provider).toList()
              : _gifCache[provider])!;

          // Display the cached GIFs dynamically in a GridView
          final gifs = _gifCache[provider] ?? [];
          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            itemBuilder: (context, index) {
              return GifCard(gif: gifs[index]);
            },
            itemCount: gifs.length,
          );
        } else if (state is GifFailure) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Search for GIFs!'));
      },
    );
  }
}
