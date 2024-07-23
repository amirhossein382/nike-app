import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike/common/exceptions.dart';
import 'package:nike/data/data.dart';
import 'package:nike/data/repo/comment_repo.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final int id;
  CommentBloc(this.id) : super(CommentLoadingState()) {
    on<CommentEvent>((event, emit) async {
      if (event is CommentStartedEvent) {
        emit(CommentLoadingState());
        try {
          final comments = await commentRepository.getAll(id: id);
          emit(CommentSuccessState(comments: comments));
        } catch (e) {
          emit(CommentErrorState(exception: AppException(message: e.toString())));
        }
      }
    });
  }
}
