import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    // Define `small` locally
    bool small = screenWidth < 600; // Example: Treat small screens as small buttons

    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // First Container
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * .2,
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
                        fontSize: 20.6,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 8,
                    child: ElevatedButton.icon(
                      onPressed: () {}, // Add functionality
                      label: Text(
                        'remove',
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'SpaceGrotesk',
                          color: Colors.white,
                        ),
                      ),
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 12,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF585858),
                        minimumSize: small
                            ? Size(MediaQuery.of(context).size.width * 0.30, 20) // Match small size
                            : Size(MediaQuery.of(context).size.width * 0.32, 30), // Match default size
                        padding: EdgeInsets.zero, // Removes default button padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Match `CardButtons` radius
                        ),
                      ),
                    ),
                  ),

                  // Bottom Row: Date text on the left and Needs button at the center
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Text(
                      'today-7th dec 2024',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: (screenWidth * 0.9 - 72.34) / 2, // Center the button horizontally
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'needs',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'SpaceGrotesk',
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2255D9),
                        minimumSize: small
                            ? Size(MediaQuery.of(context).size.width * 0.16, 24) // Match small size
                            : Size(MediaQuery.of(context).size.width * 0.32, 30), // Match default size
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20), // Add spacing between containers

            // Second Container (customizable)
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width * .2,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  // Top Row: 20,000 kes on the left and Edit button on the right
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Text(
                      'Salary',
                      style: TextStyle(
                        fontSize: 20.6,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                      ),
                    ),
                  ),
                                    Positioned(
                    top: 8,
                    right: 12,
                    child: Text(
                      '20,000',
                      style: TextStyle(
                        fontSize: 20.6,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.black,
                      ),
                    ),
                  ),

                  // Bottom Row: Date text on the left and Done button at the center
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Text(
                      'remove',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontFamily: 'SpaceGrotesk',
                        color: Colors.red[700],
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12, // Center the button horizontally
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'monthly',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: 'SpaceGrotesk',
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2255D9),
                        minimumSize: small
                            ? Size(MediaQuery.of(context).size.width * 0.16, 24) // Match small size
                            : Size(MediaQuery.of(context).size.width * 0.32, 30), // Match default size
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
