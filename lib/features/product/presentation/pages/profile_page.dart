import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengembang'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
              SizedBox(height: 20),
              Text(
                'Muhamad Taupik Anjana',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text('Universitas Teknologi Digital'),
              Text('Informatics - 6th Semester'),
            ],
          ),
        ),
      ),
    );
  }
}