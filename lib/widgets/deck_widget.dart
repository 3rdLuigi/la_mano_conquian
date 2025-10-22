import 'package:flutter/material.dart';

class DeckWidget extends StatelessWidget {
  final int cardCount;
  final VoidCallback? onTap; // A function to call when tapped

  const DeckWidget({
    super.key,
    required this.cardCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 60,
        height: 90,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black54, width: 1),
          gradient: const LinearGradient(
            colors: [Colors.deepPurple, Colors.blueGrey],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.style, color: Colors.white70, size: 30),
              const SizedBox(height: 4),
              Text(
                '$cardCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}