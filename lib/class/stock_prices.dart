import 'dart:ffi';

class StockPrice {
  final String symbol;
  final String date;
  final Float open;
  final Float close;
  final Float high;
  final Float low;
  final Float splitFactor;
  final Float dividend;

  StockPrice(this.symbol, this.date, this.open, this.close, this.high, this.low,
      this.dividend, this.splitFactor);
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'symbol': symbol,
      'date': date,
      'open': open,
      'close': close,
      'high': high,
      'low': low,
      'splitFactor': splitFactor,
      'dividend': dividend
    };
  }

  factory StockPrice.fromJson(Map<String, dynamic> json) {
    return StockPrice(
      json['symbol'],
      json['date'],
      json['open'],
      json['close'],
      json['high'],
      json['low'],
      json['splitFactor'],
      json['dividend'],
    );
  }
}
