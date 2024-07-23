import 'package:nike/data/data.dart';
import 'package:nike/data/source/comment_source.dart';

final CommentRepository commentRepository =
    CommentRepository(commentDateSource: CommentDataSource());

abstract class ICommentRepository {
  Future<List<CommentJson>> getAll({required id});
}

class CommentRepository extends ICommentRepository {
  final CommentDataSource commentDateSource;

  CommentRepository({required this.commentDateSource});
  @override
  Future<List<CommentJson>> getAll({required id}) =>
      commentDateSource.getAll(id: id);
}
