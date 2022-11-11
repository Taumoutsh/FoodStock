abstract class DataFetcher<T> {

  Future<List> getData(int primaryKey);

  Future<List> getAllData();

  Future<List> getDataFromTableOrderBy(String label, bool byAsc);

  Future<int> removeData(String primaryKey);

  Future<String> addData(T t);

  Future<int> updateData(T t);

  String tableName();

  String primaryKeyName();

  String labelName();

}