import 'package:flutter/material.dart';

const String matchesCollection = 'matches';

const String symbolX = 'X';
const String symbolO = 'O';
const String symbolEmpty = '';
const String resultTie = 'Tie';

const List<List<int>> winningPatterns = [
  // Horizontal Rows
  [0, 1, 2],
  [3, 4, 5],
  [6, 7, 8],
  // Vertical Columns
  [0, 3, 6],
  [1, 4, 7],
  [2, 5, 8],
  // Diagonals
  [0, 4, 8],
  [2, 4, 6],
];

// Color palette constants
const Color colorPlayerX = Color(0xFF6366F1); // Indigo / Violet
const Color colorPlayerO = Color(0xFFEC4899); // Pink / Coral
const Color colorTie = Color(0xFFF59E0B);     // Amber
