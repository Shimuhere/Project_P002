import 'package:flutter/material.dart';
import 'package:cse464_p002_tictactoe/utility/constant.dart';

class MiniBoardWidget extends StatelessWidget {
  final List<String> board;
  final double size;

  const MiniBoardWidget({
    super.key,
    required this.board,
    this.size = 54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          final symbol = (index < board.length) ? board[index] : '';
          final isX = symbol == symbolX;
          final isO = symbol == symbolO;

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.center,
            child: symbol.isNotEmpty
                ? Text(
                    symbol,
                    style: TextStyle(
                      fontSize: size * 0.22,
                      fontWeight: FontWeight.w900,
                      color: isX ? colorPlayerX : (isO ? colorPlayerO : Colors.grey),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
