abstract class DataFetcher<T> {

  Future<List> getData(int primaryKey);

  Future<List> getDataOrderBy(int primaryKey, String orderByColumn);

  Future<List> getDataFromTable();

  Future<List> getDataFromTableOrderBy(String label, bool byAsc);

  Future<void> removeDataFromTable(int primaryKey);

  Future<int> updateData(T t);

  String tableName();

  String primaryKeyName();

  String labelName();

}