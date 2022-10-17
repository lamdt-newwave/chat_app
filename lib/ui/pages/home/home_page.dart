import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Home"),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthRepository>().signOut();
                },
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
