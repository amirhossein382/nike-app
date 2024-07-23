part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object> get props => [];
}

final class CommentLoadingState extends CommentState {}

final class CommentSuccessState extends CommentState {
  final List<CommentJson> comments;

  const CommentSuccessState({required this.comments});

  @override
  List<Object> get props => [comments];
}

final class CommentErrorState extends CommentState {
  final AppException exception;

  const CommentErrorState({required this.exception});
  @override
  List<Object> get props => [exception];
}
