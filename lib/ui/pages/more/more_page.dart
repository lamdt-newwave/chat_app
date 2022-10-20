import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/routes/app_routes.dart';
import 'package:chat_app/ui/pages/more/more_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class MorePage extends StatelessWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoreCubit(),
      child: const MoreChildPage(),
    );
  }
}

class MoreChildPage extends StatefulWidget {
  const MoreChildPage({Key? key}) : super(key: key);

  @override
  State<MoreChildPage> createState() => _MoreChildPageState();
}

class _MoreChildPageState extends State<MoreChildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<AppCubit>().signOut();
                  Get.offNamed(AppRoutes.signUpWithPhone);
                },
                child: Text("Sign Out"),
              ),
              Text("More"),
            ],
          ),
        ),
      ),
    );
  }
}
