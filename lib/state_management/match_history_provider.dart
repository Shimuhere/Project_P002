import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:cse464_p002_tictactoe/models/match_model.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class MatchHistoryProvider with ChangeNotifier {
  final FirebaseFirestore? _customFirestore;

  CollectionReference? get _matchesCollection {
    try {
      final fs = _customFirestore ?? FirebaseFirestore.instance;
      return fs.collection(matchesCollection);
    } catch (_) {
      return null;
    }
  }

  StreamSubscription<QuerySnapshot>? _subscription;

  List<MatchModel> _matches = [];
  bool _isLoading = true;
  String? _error;

  List<MatchModel> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get error => _error;

  MatchHistoryProvider({FirebaseFirestore? firestore, bool autoInit = true})
      : _customFirestore = firestore {
    if (autoInit) {
      _initStream();
    } else {
      _isLoading = false;
    }
  }

  void _initStream() {
    _subscription?.cancel();
    _isLoading = true;
    _error = null;

    final col = _matchesCollection;
    if (col == null) {
      _isLoading = false;
      return;
    }

    _subscription = col
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snapshot) {
        _matches = snapshot.docs
            .map(
              (doc) => MatchModel.fromJson(
                doc.id,
                doc.data() as Map<String, dynamic>,
              ),
            )
            .toList();
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (err) {
        _isLoading = false;
        _error = 'Failed to load match history: ${err.toString()}';
        notifyListeners();
      },
    );
  }

  Future<void> saveMatch(MatchModel match) async {
    final col = _matchesCollection;
    if (col == null) return;
    try {
      await col.add(match.toJson());
    } catch (e) {
      _error = 'Failed to save match result: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> deleteMatch(String matchId) async {
    final col = _matchesCollection;
    if (col == null) return;
    try {
      await col.doc(matchId).delete();
    } catch (e) {
      _error = 'Failed to delete match: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> clearAllMatches() async {
    final col = _matchesCollection;
    if (col == null) return;
    try {
      final snapshot = await col.get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      _error = 'Failed to clear match history: ${e.toString()}';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
