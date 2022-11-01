import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/entities/message_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/personal_chat/personal_chat_cubit.dart';
import 'package:chat_app/ui/pages/personal_chat/widgets/chat_widget.dart';
import 'package:chat_app/ui/widgets/commons/app_failure.dart';
import 'package:chat_app/ui/widgets/commons/app_shimmer.dart';
import 'package:chat_app/utils/app_stream.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late final ChatUser user;
  late final AppStream appStream;

  @override
  void initState() {
    super.initState();
    appStream = AppStream();
    appStream.startStream();
    _cubit = context.read<PersonalChatCubit>();
    _cubit.fetchInitData(appStream);
    user = ChatUser(id: context.read<AppCubit>().state.user!.uId);
  }

  @override
  void dispose() {
    super.dispose();
    _cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<PersonalChatCubit, PersonalChatState>(
          bloc: _cubit,
          builder: (context, state) {
            return Column(
              children: [
                buildHeadPage(),
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
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildHeadPage() {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          const SizedBox(
            height: 14,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                ],
              ),
              Row(
                children: [
                  AppAssets.svgs.icSearch.svg(height: 24.h, width: 24.w),
                  SizedBox(
                    width: 8.w,
                  ),
                  AppAssets.svgs.icHamburger.svg(height: 24.h, width: 24.w),
                ],
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildSuccessChat() {
    return BlocBuilder<PersonalChatCubit, PersonalChatState>(
      bloc: _cubit,
      builder: (context, state) {
        return Container(
          color: AppColors.neutralOffWhite,
          child: ChatWidget(
            chatUser: state.chatUser!,
            author: state.room.participants
                .firstWhere((element) => element.uId != state.chatUser!.uId),
            messages: List<MessageEntity>.from(state.messages.reversed),
            onSend: (newMessage) {
              _cubit.onSendTextMessage(newMessage);
            },
            onAttachFile: _cubit.onUploadFile,
            onReplyMessage: _cubit.onReplyMessage,
            replyingMessageId: state.replyingMessageId,
          ),
        );
      },
    );
  }
}
