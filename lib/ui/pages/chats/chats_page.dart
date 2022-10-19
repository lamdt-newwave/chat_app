import 'package:chat_app/ui/pages/chats/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(),
      child: const ChatsChildPage(),
    );
  }
}

class ChatsChildPage extends StatefulWidget {
  const ChatsChildPage({Key? key}) : super(key: key);

  @override
  State<ChatsChildPage> createState() => _ChatsChildPageState();
}

class _ChatsChildPageState extends State<ChatsChildPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("Chats"),
        ),
      ),
    );
  }
}
