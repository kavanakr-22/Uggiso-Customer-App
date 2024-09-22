import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileBloc.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileEvent.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileState.dart';
import 'package:uggiso/base/common/utils/colors.dart';
import 'package:uggiso/base/common/utils/fonts.dart';
import 'package:uggiso/base/common/utils/strings.dart';

class ReferralHistory extends StatefulWidget {
  const ReferralHistory({super.key});

  @override
  State<ReferralHistory> createState() => _ReferralHistoryState();
}

class _ReferralHistoryState extends State<ReferralHistory> {
  ProfileBloc _profileBloc = ProfileBloc();
  String? userId = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAcceptors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.appPrimaryColor,
        title: Text(
          Strings.my_referrals,
          style: AppFonts.appBarText.copyWith(color: AppColors.black),
        ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: IconButton(
            iconSize: 18,
            icon: Image.asset('assets/ic_back_arrow.png'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: BlocProvider(
          create: (context) => _profileBloc,
          child: BlocListener<ProfileBloc,ProfileState>(
              listener: (BuildContext context, state) {
                if(state is onAcceptorsDataFetched){
                  print('this is acceptors details : ${state.data.payload}');
                }
              },
              child: BlocBuilder<ProfileBloc,ProfileState>(
                builder: (context,state) {
                  if(state is ErrorState){
                    return Center(
                      child: Text('${state.message}'),
                    );
                  }
                  else if(state is LoadingState){
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
                    );
                  }
                  return Center(
                    child: Text('No referals Found'),
                  );
                }
              ))),
    );
  }

  void getAcceptors() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    print('this is userId : 65ec7660-e8a9-4253-bbcd-ed8154b602b8');
    _profileBloc.add(OnGetAcceptors(userId:"65ec7660-e8a9-4253-bbcd-ed8154b602b8"));
  }
}
