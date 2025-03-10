import 'package:flutter/material.dart';
import 'package:pocketwise/utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? phoneNumber = prefs.getString('phone');

      if (phoneNumber != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('phoneNumber', isEqualTo: phoneNumber)
            .get();

        if (userDoc.docs.isNotEmpty) {
          final userData = userDoc.docs.first.data();
          setState(() {
            firstNameController.text = userData['firstname'] ?? '';
            lastNameController.text = userData['lastname'] ?? '';
            emailController.text = userData['email'] ?? '';
            phoneController.text = userData['phoneNumber'] ?? '';
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        const SizedBox(height: 30),
                        ClipOval(
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSj8sKRgBGHeqyyzcVzby3YrHH_s0KVk-PozzvgrCdsueqkbhorjmZ0cByvks-Oy9tK38M&usqp=CAU',
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
                    Text(
                      '${firstNameController.text} ${lastNameController.text}',
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 32),
                    buildEditableCard(
                      title: 'First Name',
                      controller: firstNameController,
                    ),
                    const SizedBox(height: 16),
                    buildEditableCard(
                      title: 'Last Name',
                      controller: lastNameController,
                    ),
                    const SizedBox(height: 16),
                    buildEditableCard(
                      title: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    buildEditableCard(
                      title: 'Phone Number',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      readOnly: true,
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
    bool readOnly = false,
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
                      readOnly: readOnly,
                      style: TextStyle(
                        color: readOnly ? Colors.grey : Colors.black,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter value',
                        suffixIcon: readOnly
                            ? const Icon(Icons.lock_outline,
                                size: 16, color: Colors.grey)
                            : null,
                      ),
                    ),
                  ),
                  if (!readOnly)
                    Focus(
                      child: GestureDetector(
                        onTap: () {
                          FocusScope.of(context).requestFocus(_focusNode);
                        },
                        child: const Text('Edit'),
                      ),
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
