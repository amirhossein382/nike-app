import 'package:dio/dio.dart';
import 'package:nike/common/validators.dart';
import 'package:nike/data/data.dart';

abstract class ICommentDataSource {
  Future<List<CommentJson>> getAll({required id});
}

class CommentDataSource extends ICommentDataSource {
  final Dio httpclient = Dio();
  @override
  Future<List<CommentJson>> getAll({required id}) async {
    final response = await httpclient
        .get("http://expertdevelopers.ir/api/v1/comment/list?product_id=$id");
    validateResponse(response);
    final List<CommentJson> comments = [];
    for (var element in (response.data as List)) {
      comments.add(CommentJson.fromJson(element));
    }
    return comments;
  }
}
