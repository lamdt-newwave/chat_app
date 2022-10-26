import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/widgets/commons/app_failure.dart';
import 'package:chat_app/ui/widgets/commons/app_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalChatPage extends StatelessWidget {
  const PersonalChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PersonalChatCubit(
          userRepository: RepositoryProvider.of<UserRepository>(context),
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          chatRepository: RepositoryProvider.of<ChatRepository>(context)),
      child: const PersonalChatChildPage(),
    );
  }
}

class PersonalChatChildPage extends StatefulWidget {
  const PersonalChatChildPage({Key? key}) : super(key: key);

  @override
  State<PersonalChatChildPage> createState() => _PersonalChatChildPageState();
}

class _PersonalChatChildPageState extends State<PersonalChatChildPage> {
  late final PersonalChatCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<PersonalChatCubit>();
    _cubit.fetchRoomData();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              const SizedBox(
                height: 14,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                      onTap: Get.back,
                      child: AppAssets.svgs.icChevronLeft
                          .svg(height: 24.h, width: 24.w)),
                  SizedBox(
                    width: 8.w,
                  ),
                  BlocBuilder<PersonalChatCubit, PersonalChatState>(
                    builder: (context, state) {
                      if (state.fetchRoomDataStatus == LoadStatus.loading) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20)),
                          margin: const EdgeInsets.all(10),
                          child: AppShimmer(
                            height: 30.h,
                            width: 80.w,
                            cornerRadius: 20,
                          ),
                        );
                      } else if (state.fetchRoomDataStatus ==
                          LoadStatus.success) {
                        return Container(
                          alignment: Alignment.center,
                          height: 30.h,
                          child: Text(
                            "${state.chatUser!.firstName} ${state.chatUser!.lastName}",
                            style: textTheme.subtitle1,
                          ),
                        );
                      } else if (state.fetchRoomDataStatus ==
                          LoadStatus.failure) {
                        return Container(
                          alignment: Alignment.center,
                          height: 30.h,
                          child: Text(
                            "Not Found!!!",
                            style: textTheme.subtitle1,
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                  const Spacer(),
                  AppAssets.svgs.icSearch.svg(height: 24.h, width: 24.w),
                  SizedBox(
                    width: 8.w,
                  ),
                  AppAssets.svgs.icHamburger.svg(height: 24.h, width: 24.w),
                ],
              ),
              Expanded(
                child: BlocBuilder<PersonalChatCubit, PersonalChatState>(
                  builder: (context, state) {
                    if (state.fetchRoomDataStatus == LoadStatus.loading) {
                      return _buildLoadingChat();
                    } else if (state.fetchRoomDataStatus ==
                        LoadStatus.success) {
                      return _buildSuccessChat();
                    } else if (state.fetchRoomDataStatus ==
                        LoadStatus.failure) {
                      return _buildFailureChat();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessChat() {
    return BlocBuilder<PersonalChatCubit, PersonalChatState>(
      builder: (context, state) {
        return Chat(
          customMessageBuilder: (customMessage, {required messageWidth}) =>
              MessageWidget(
            customMessage: customMessage,
            messageWidth: messageWidth,
          ),
          messages: state.room!.messages
              .map((e) => types.CustomMessage(
                    id: e.messageId,
                    author: types.User(id: e.authorId),
                  ))
              .toList(),
          onSendPressed: (PartialText) {},
          user: types.User(
            id: state.user!.uId,
            createdAt: state.user!.createdTime.millisecondsSinceEpoch,
            lastName: state.user!.lastName,
            imageUrl: state.user!.avatarUrl,
          ),
        );
      },
    );
  }

  Widget _buildLoadingChat() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      itemBuilder: (_, index) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.all(10),
          child: const AppShimmer(
            height: 80,
            cornerRadius: 20,
          ),
        );
      },
    );
  }

  Widget _buildFailureChat() {
    return const AppFailure();
  }
}

class MessageWidget extends StatelessWidget {
  final types.CustomMessage customMessage;
  final int messageWidth;

  const MessageWidget({
    Key? key,
    required this.customMessage,
    required this.messageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
            "1231313123131231313324242342423123123131311231312312313131312312313123131313"));
  }
}
