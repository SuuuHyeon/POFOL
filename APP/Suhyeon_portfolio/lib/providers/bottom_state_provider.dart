import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomState extends StateNotifier<int> {
  BottomState() : super(1);

  @override
  int get state => super.state;

  void changeState(int index) {
    state = index;
  }
}

final bottomStateProvider = StateNotifierProvider<BottomState, int>((ref) => BottomState());
