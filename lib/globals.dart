import 'package:shared_preferences/shared_preferences.dart';

String Logistic_global_User_Id = "";
var Logistic_Global_Route_Area = null;
String StartTimeAreaLocation = "";
String ReachedTimeAreaLocation = "";
String CompletedTimeAreaLocartion = "";
String Total_SampleColectedByArea = "";
String CompletedAreaID = "";
int SubmitTotalSamples = 0;
String SubmitLocationID = "";
String Submit_Location_Name = "";
String LocationSubmitShiftFromTimeStart = "";
String LocationSubmitShiftTotimeEnd = "";
var ShowReachedCompletedStartedData = null;
String StartAreaTime = "";
String Login_User_Name = "";
var CompleteddataLastIndex = null;
var SubmitteddataLastIndex = null;
String TRFImgPath="";

String Global_Logistic_Api_URL = '';
String Logistic_App_Connection_String = "";
String All_Client_Logo = "";
String Global_All_Client_Api_URL = "https://mobileappjw.softmed.in";

String pendingTripShiftId = "";

late SharedPreferences logindata;

void main() async {
  logindata = await SharedPreferences.getInstance();
}