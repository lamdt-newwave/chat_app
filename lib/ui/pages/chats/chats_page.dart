import 'package:chat_app/blocs/app/app_cubit.dart';
import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/models/entities/user_entity.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/auth_repository.dart';
import 'package:chat_app/repositories/chat_repository.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/chats/chats_cubit.dart';
import 'package:chat_app/ui/pages/chats/widgets/room_item.dart';
import 'package:chat_app/ui/pages/contacts/widgets/contacts_item.dart';
import 'package:chat_app/ui/widgets/commons/app_failure.dart';
import 'package:chat_app/ui/widgets/commons/app_shimmer.dart';
import 'package:chat_app/ui/widgets/text_field/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatsCubit(
          appCubit: context.read<AppCubit>(),
          userRepository: RepositoryProvider.of<UserRepository>(context),
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          chatRepository: RepositoryProvider.of<ChatRepository>(context)),
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
  late final ChatsCubit _cubit;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ChatsCubit>();
    _cubit.fetchStories();
    _cubit.fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(
                height: 14.h,
              ),
              SizedBox(
                height: 30.h,
                child: Row(
                  children: [
                    Text(
                      "Chats",
                      style: textTheme.subtitle1,
                    ),
                    const Spacer(),
                    AppAssets.svgs.icMessagePlusAlt
                        .svg(width: 24.w, height: 24.h),
                    SizedBox(
                      width: 8.w,
                    ),
                    AppAssets.svgs.icListCheck.svg(width: 24.w, height: 24.h),
                  ],
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              _buildStoryList(),
              SizedBox(
                height: 16.h,
              ),
              SearchTextFormField(
                  onChanged: (newValue) {},
                  onCloseSearch: () {},
                  controller: _controller,
                  hintText: "Search"),
              _buildRoomList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryList() {
    return BlocBuilder<ChatsCubit, ChatsState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state.fetchStoriesStatus == LoadStatus.loading) {
          return _buildLoadingStoryList();
        } else if (state.fetchStoriesStatus == LoadStatus.success) {
          return _buildSuccessStoryList();
        } else if (state.fetchStoriesStatus == LoadStatus.failure) {
          return _buildFailureStoryList();
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _buildLoadingStoryList() {
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

  Widget _buildFailureStoryList() {
    return const AppFailure();
  }

  Widget _buildSuccessStoryList() {
    return SizedBox(
      height: 84.h,
      child: BlocBuilder<ChatsCubit, ChatsState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: state.stories.length + 1,
                  itemBuilder: (_, index) {
                    if (index == 0) {
                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 56.h,
                              width: 56.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: AppColors.neutralOffWhite,
                                  border: Border.all(
                                      color: AppColors.neutralDisabled,
                                      width: 2.w)),
                              child: Center(
                                child: AppAssets.svgs.icPlus.svg(
                                    width: 24.w,
                                    height: 24.h,
                                    color: AppColors.neutralDisabled),
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(
                              "Your Story",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 10.r,
                                  fontFamily: FontFamily.mulish,
                                  color: AppColors.neutralActive),
                            )
                          ],
                        ),
                      );
                    } else {
                      final story = state.stories[index - 1];
                      return Padding(
                        padding: EdgeInsets.only(right: 16.w),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AvatarWidget(
                              user: story.user,
                              isOnline: false,
                              offLineWithinDay: true,
                              showDot: false,
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            SizedBox(
                              width: 56.w,
                              child: Text(
                                  "${story.user.firstName} ${story.user.lastName}",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10.r,
                                      fontFamily: FontFamily.mulish,
                                      color: AppColors.neutralActive)),
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoomList(BuildContext context) {
    return Expanded(
      child: BlocBuilder<ChatsCubit, ChatsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.fetchRoomsStatus == LoadStatus.loading) {
            return _buildLoadingRoomList();
          } else if (state.fetchRoomsStatus == LoadStatus.failure) {
            return const AppFailure();
          } else if (state.fetchRoomsStatus == LoadStatus.success) {
            return _buildSuccessRoomList();
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildLoadingRoomList() {
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

  Widget _buildSuccessRoomList() {
    return BlocBuilder<ChatsCubit, ChatsState>(
      bloc: _cubit,
      builder: (context, state) {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: state.rooms.length,
          itemBuilder: (_, index) {
            final room = state.rooms[index];
            final UserEntity user = room.participants.firstWhere((element) =>
                element.uId !=
                RepositoryProvider.of<AuthRepository>(context).getUid());
            return RoomItem(user: user, room: room);
          },
        );
      },
    );
  }
}
