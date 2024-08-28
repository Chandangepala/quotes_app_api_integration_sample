class QuoteModel{
  int id;
  String quote;
  String author;

  QuoteModel({required this.id, required this.quote, required this.author});

  factory QuoteModel.fromJson(Map<String, dynamic> jsonMap) => QuoteModel(id: jsonMap['id'], quote: jsonMap['quote'], author: jsonMap['author']);
}

class DataModel{
  int limit;
  int skip;
  int total;
  List<QuoteModel> quotes;

  DataModel({required this.limit, required this.skip, required this.total, required this.quotes});



  factory DataModel.fromJson(Map<String, dynamic> jsonMap) {
    List<QuoteModel> mQuoteList = [];
    for(Map<String,dynamic> eachQuote in jsonMap['quotes']){
      mQuoteList.add(QuoteModel.fromJson(eachQuote));
    }
    print("mQuoteListSize: ${mQuoteList.length}");
    return DataModel(limit: jsonMap['limit'], skip: jsonMap['skip'], total: jsonMap['total'], quotes: mQuoteList);
  }
}