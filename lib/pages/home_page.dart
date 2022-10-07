import 'dart:async';
import 'dart:io';

import 'package:aljaami_test/bloc/country/country_list_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/countries.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CountryListBloc _countryListBloc = CountryListBloc();

  @override
  void initState() {
    _countryListBloc.add(GetCountriesList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('List of Countries')),
        body: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: _buildCountryList(),
        ));
  }

  Widget _buildCountryList() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (_) => _countryListBloc,
        child: BlocListener<CountryListBloc, CountryListState>(
          listener: (context, state) {
            if (state is CountryListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message!),
                ),
              );
            }
          },
          child: BlocBuilder<CountryListBloc, CountryListState>(
            builder: (context, state) {
              if (state is CountryListInitial) {
                return _buildLoading();
              } else if (state is CountryListLoading) {
                return _buildLoading();
              } else if (state is CountryListLoaded) {
                return _buildCard(context, state.countries!.data!.countries);
              } else if (state is CountryListError) {
                return GestureDetector(
                    onTap: () {
                      _countryListBloc.add(GetCountriesList());
                    },
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.refresh),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Tap to refresh'),
                      ],
                    )));
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Country>? countries) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(height: 1);
      },
      itemCount: countries!.length,
      itemBuilder: (BuildContext context, index) {
        Country country = countries[index];
        return Container(
          color: Colors.white30,
          child: ListTile(
            leading: Image.network(
              country.image!,
              height: 25,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.error,
                  size: 30,
                );
              },
            ),
            title: Text(
              country.countryName!,
              style: const TextStyle(fontSize: 22.0, color: Colors.black),
            ),
            subtitle: Text(
              '+${country.phoneCode!}',
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
            ),
          ),
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    _countryListBloc.add(GetCountriesList());
    Timer.periodic(const Duration(seconds: 10), (timer) {
      _countryListBloc.add(RemoveCountriesList());
      if (_countryListBloc.state.props == 0) {
        timer.cancel();
      }
    });
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
