import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/generated/common/fonts.gen.dart';
import 'package:chat_app/ui/pages/chats/chats_page.dart';
import 'package:chat_app/ui/pages/contacts/contacts_page.dart';
import 'package:chat_app/ui/pages/home/home_cubit.dart';
import 'package:chat_app/ui/pages/more/more_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(),
      child: const HomeChildPage(),
    );
  }
}

class HomeChildPage extends StatefulWidget {
  const HomeChildPage({Key? key}) : super(key: key);

  @override
  State<HomeChildPage> createState() => _HomeChildPageState();
}

class _HomeChildPageState extends State<HomeChildPage> {
  late final HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<HomeCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutralWhite,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: SafeArea(
        child: Center(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return IndexedStack(
                index: state.selectedIndex,
                children: const [
                  ContactsPage(),
                  ChatsPage(),
                  MorePage(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Container(
          height: 84.h,
          decoration: const BoxDecoration(
            color: AppColors.neutralWhite,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () => _cubit.onChangeSelectedIndex(0),
                child: SizedBox(
                  width: 58.w,
                  height: 44.h,
                  child: state.selectedIndex == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Contacts",
                              style: TextStyle(
                                  fontFamily: FontFamily.lato,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.r,
                                  color: AppColors.neutralActive),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Container(
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                  color: AppColors.neutralActive,
                                  shape: BoxShape.circle),
                            )
                          ],
                        )
                      : Center(
                          child: AppAssets.svgs.icGroup
                              .svg(width: 32.w, height: 32.h)),
                ),
              ),
              InkWell(
                onTap: () => _cubit.onChangeSelectedIndex(1),
                child: SizedBox(
                  width: 44.w,
                  height: 58.h,
                  child: state.selectedIndex == 1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Chats",
                              style: TextStyle(
                                  fontFamily: FontFamily.lato,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.r,
                                  color: AppColors.neutralActive),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Container(
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                  color: AppColors.neutralActive,
                                  shape: BoxShape.circle),
                            )
                          ],
                        )
                      : Center(
                          child: AppAssets.svgs.icMessageCircle
                              .svg(width: 32.w, height: 32.h),
                        ),
                ),
              ),
              InkWell(
                onTap: () => _cubit.onChangeSelectedIndex(2),
                child: SizedBox(
                  width: 44.w,
                  height: 58.h,
                  child: state.selectedIndex == 2
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "More",
                              style: TextStyle(
                                  fontFamily: FontFamily.lato,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.r,
                                  color: AppColors.neutralActive),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Container(
                              width: 4.w,
                              height: 4.h,
                              decoration: const BoxDecoration(
                                  color: AppColors.neutralActive,
                                  shape: BoxShape.circle),
                            )
                          ],
                        )
                      : Center(
                          child: AppAssets.svgs.icMoreHorizontal
                              .svg(width: 32.w, height: 32.h),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
