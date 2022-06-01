import 'package:app/models/load_list.dart';
import 'package:app/models/exchange.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeList extends StateNotifier<List<Exchange>> {
  ExchangeList({required this.loadList}) : super([]);

  final LoadList loadList;

  void load() async {
    try {
      state = [];
      await loadList.loadExchange();
    } finally {
      state = loadList.exchanges;
    }
  }
}
