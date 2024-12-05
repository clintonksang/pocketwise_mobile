import 'package:flutter/material.dart';
import 'package:pockets/utils/constants/colors.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController nameController =
      TextEditingController(text: 'Clinton Sang');
  final TextEditingController ageController = TextEditingController(text: '28');
  final TextEditingController professionController =
      TextEditingController(text: 'Software Engineer');
  FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Profile',
                style: TextStyle(
                  fontSize: 24,
                  // fontFamily: 'Playfair'
                  // color: Colors.red
                  // fontWeight: FontWeight.bold,
                ),
              ),
              
              Stack(
                children: [
                  const SizedBox(height: 30),
                  ClipOval(
                    child: Image.network(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSj8sKRgBGHeqyyzcVzby3YrHH_s0KVk-PozzvgrCdsueqkbhorjmZ0cByvks-Oy9tK38M&usqp=CAU', // Ensure the image is in the assets folder.
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: primaryColor,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Clinton Sang',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 32),
              buildEditableCard(
                title: 'Full Name',
                controller: nameController,
              ),
              const SizedBox(height: 16),
              buildEditableCard(
                title: 'Age',
                controller: ageController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              buildEditableCard(
                title: 'Profession',
                controller: professionController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEditableCard({
    required String title,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      keyboardType: keyboardType,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter value',
                      ),
                    ),
                  ),
                  Focus(
                    child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        child: Text('Edit')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
