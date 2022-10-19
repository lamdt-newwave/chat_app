import 'package:chat_app/generated/common/assets.gen.dart';
import 'package:chat_app/generated/common/colors.gen.dart';
import 'package:chat_app/models/enums/load_status.dart';
import 'package:chat_app/repositories/user_repository.dart';
import 'package:chat_app/ui/pages/contacts/contacts_cubit.dart';
import 'package:chat_app/ui/pages/contacts/widgets/contacts_item.dart';
import 'package:chat_app/ui/widgets/commons/app_failure.dart';
import 'package:chat_app/ui/widgets/commons/app_shimmer.dart';
import 'package:chat_app/ui/widgets/text_field/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactsPage extends StatelessWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactsCubit(
          userRepository: RepositoryProvider.of<UserRepository>(context)),
      child: const ContactsChildPage(),
    );
  }
}

class ContactsChildPage extends StatefulWidget {
  const ContactsChildPage({Key? key}) : super(key: key);

  @override
  State<ContactsChildPage> createState() => _ContactsChildPageState();
}

class _ContactsChildPageState extends State<ContactsChildPage> {
  late final ContactsCubit _cubit;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = context.read<ContactsCubit>();
    _cubit.fetchUsers();
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 30.h,
                      child: Text("Contacts", style: textTheme.subtitle1)),
                  const Spacer(),
                  AppAssets.svgs.icPlus.svg(width: 24.w, height: 24.h),
                ],
              ),
              SizedBox(
                height: 30.h,
              ),
              SearchTextFormField(
                hintText: 'Search',
                onCloseSearch: () {},
                onChanged: _cubit.onTextSearchChanged,
                controller: _controller,
              ),
              Expanded(
                child: BlocBuilder<ContactsCubit, ContactsState>(
                  builder: (context, state) {
                    if (state.fetchUsersStatus == LoadStatus.loading) {
                      return _buildLoadingUserList(context);
                    } else if (state.fetchUsersStatus == LoadStatus.success) {
                      return _buildSuccessUserList(context);
                    } else if (state.fetchUsersStatus == LoadStatus.failure) {
                      return const AppFailure();
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingUserList(BuildContext context) {
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

  Widget _buildSuccessUserList(BuildContext context) {
    return BlocBuilder<ContactsCubit, ContactsState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.users.length,
          shrinkWrap: true,
          itemBuilder: (_, index) {
            final user = state.users[index];
            return ContactsItem(
              user: user,
              onPressed: () {},
              isOnline: user.status == 1,
              offLineWithinDay: (DateTime.now().millisecondsSinceEpoch -
                      user.lastTime.millisecondsSinceEpoch) <=
                  const Duration(days: 1).inMilliseconds,
            );
          },
        );
      },
    );
  }
}
