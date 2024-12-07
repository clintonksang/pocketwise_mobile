import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 375,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(8.0), // Minimal padding
      child: Stack(
        children: [
          // Top-left content
          Positioned(
            top: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '15,500 kes',
                  style: TextStyle(
                    fontSize: 32.6,
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4), // Space between two texts
                Text(
                  'today 7th dec 20204',
                  style: TextStyle(
                    fontSize: 8.17,
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Top-right button
          Positioned(
            top: 8,
            right: 8,
            child: ElevatedButton.icon(
              onPressed: () {}, // Add your functionality
              icon: Icon(
                Icons.delete,
                color: Colors.white,
                size: 10,
              ),
              label: Text(
                'remove',
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'SpaceGrotesk',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF585858),
                fixedSize: Size(80.61, 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          // Bottom-center button
          Positioned(
            bottom: 8,
            right: 8,
            child: ElevatedButton(
              onPressed: () {}, // Add your functionality
              child: Text(
                'needs',
                style: TextStyle(
                  fontSize: 10, // Adjusted for size balance
                  fontFamily: 'SpaceGrotesk',
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2255D9),
                fixedSize: Size(72.34, 23.09),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
