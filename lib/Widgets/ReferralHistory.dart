import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileBloc.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileEvent.dart';
import 'package:uggiso/Bloc/ProfileBloc/profileState.dart';
import 'package:uggiso/Widgets/ui-kit/RoundedContainer.dart';
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
      backgroundColor: AppColors.textFieldBorderColor,
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
                      child: Text('${state.message}',style: AppFonts.smallText,),
                    );
                  }
                  else if(state is LoadingState){
                    return Center(
                      child: CircularProgressIndicator(color: AppColors.appPrimaryColor,),
                    );
                  }
                  else if(state is onAcceptorsDataFetched){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundedContainer(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: AppColors.white,
                        borderColor: AppColors.white,
                        cornerRadius: 10,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name',style: AppFonts.smallText.copyWith(fontWeight: FontWeight.w600),),
                                // Text('Points Received',style: AppFonts.smallText.copyWith(fontWeight: FontWeight.w600),),
                                // Text('Reference',style: AppFonts.smallText.copyWith(fontWeight: FontWeight.w600),),
                                Text('Date',style: AppFonts.smallText.copyWith(fontWeight: FontWeight.w600),)

                              ],
                            ),
                            Divider(color: AppColors.grey,),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.data.payload?.length,
                                  itemBuilder: (BuildContext context, int count){
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('${state.data.payload?[count].acceptorName}',
                                              style: AppFonts.smallText.copyWith(color: state.data.payload?[count].addedToWallet==true?Colors.green:Colors.black),),
                                            // Text('${state.data.payload?[count].referenceType}',style: AppFonts.smallText.copyWith(color: state.data.payload?[count].addedToWallet==true?Colors.green:Colors.black),),
                                            Text(dateConvert('${state.data.payload?[count].referedDate}'),style: AppFonts.smallText.copyWith(color: state.data.payload?[count].addedToWallet==true?Colors.green:Colors.black),)

                                          ],
                                        ),
                                      ),
                                      Divider(color: AppColors.grey,),
                                    ],
                                  );

                              }),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: Text('${Strings.something_went_wrong}',style: AppFonts.smallText,),
                  );
                }
              ))),
    );
  }

  String dateConvert(String date){

    DateTime parsedDate = DateTime.parse(date);
    String formattedDate = DateFormat('dd/MM/yyyy').format(parsedDate);
    return formattedDate.toString();
  }

  void getAcceptors() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    _profileBloc.add(OnGetAcceptors(userId:userId!));
  }

}
