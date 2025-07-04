class UserFeedback {
  UserFeedback({
    required this.userId,
    required this.recipeId,
    required this.rating,
    required this.comment,
  });
  int userId;
  int recipeId;
  double rating;
  String comment;
}