import '../../model/article.dart';
import '../../model/inventaire.dart';

abstract class InventaireSpecialQueries {

  Future<int> removeInventoryItemFromTableWhereArticle(Article article);

  Future<Inventaire?> removeInventoryItemWhereArticle(Article article);

  Future<List<Inventaire>> addInventoryItems(article, quantity);
}