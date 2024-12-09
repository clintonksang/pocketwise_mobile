import 'package:flutter/material.dart';

class ExpenseCard extends StatelessWidget {
    final String ? title;
  final String ? date;
  final bool ? small;
  const ExpenseCard ({
    super.key,
    required this.title,
    required this.date,
    required this.small,
  });
  // const Expensecard({super.key});

  @override

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return             Column(
      children: [
        Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * .2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Text(
                          title!,
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
                          onPressed: () {},
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
                            minimumSize: small!
                                ? Size(MediaQuery.of(context).size.width * 0.30, 20) 
                                : Size(MediaQuery.of(context).size.width * 0.32, 30), 
                            padding: EdgeInsets.zero, 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10), 
                            ),
                          ),
                        ),
                      ),
        
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Text(
                          date!,
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
                        left: (screenWidth * 0.9 - 72.34) / 2, 
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
                            minimumSize: small!
                                ? Size(MediaQuery.of(context).size.width * 0.16, 24) 
                                : Size(MediaQuery.of(context).size.width * 0.32, 30),
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
                         SizedBox(height: 20),
      ],
    
    );
      }
}