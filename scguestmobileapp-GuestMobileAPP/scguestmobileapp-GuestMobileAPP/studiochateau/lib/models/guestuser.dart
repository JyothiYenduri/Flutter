import 'package:studiochateau/models/plan.dart';

class GuestUser {
  int userAccountId;
  String fullName;
  int builderId;
  String builderName;
  int communityId;
  String communityName;
  String communityImage;
  List<Plan> guestUserPlans  = new List<Plan>();
}