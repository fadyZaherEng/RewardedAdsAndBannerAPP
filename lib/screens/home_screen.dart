import 'package:ads_and_banner_app/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = context.watch<HomeBloc>();
        return Scaffold(
          appBar: AppBar(title: const Text('Flutter ADS')),
          body: Column(
            children: [
              const Text("Rewarded Ad"),
              Text(bloc.credits.toString()),
              ElevatedButton(
                onPressed:
                    bloc.isRewardedAdReady ? () => bloc.showRewardedAd() : null,
                child: const Text('Watch Ad'),
              ),
              const SizedBox(height: 20),
              const Text("Banner Ad"),
              const Spacer(),
              bloc.buildBannerAd(),
              const SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }
}
