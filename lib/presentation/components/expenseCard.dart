import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0), // Card near the top
        child: Container(
          width: screenWidth * 0.9, // Responsive card width
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              // Top Row: 15,500 kes on the left and Remove button on the right
              Positioned(
                top: 8,
                left: 8,
                child: Text(
                  '15,500 kes',
                  style: TextStyle(
                    fontSize: 32.6,
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: ElevatedButton.icon(
                  onPressed: () {}, // Add functionality
                  icon: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 12,
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
                    fixedSize: Size(80.61, 25), // Adjusted size
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              // Bottom Row: Date text on the left and Needs button at the center
              Positioned(
                bottom: 8,
                left: 8,
                child: Text(
                  'today 7th dec 20204',
                  style: TextStyle(
                    fontSize: 8.17,
                    fontFamily: 'SpaceGrotesk',
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                bottom: 8,
                left: (screenWidth * 0.9 - 72.34) / 2, // Center the button horizontally
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    'needs',
                    style: TextStyle(
                      fontSize: 8,
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2255D9),
                    fixedSize: Size(72.0, 23.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
