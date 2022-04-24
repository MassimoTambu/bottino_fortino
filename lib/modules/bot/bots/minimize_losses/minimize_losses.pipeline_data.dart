part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesPipeLineData implements PipelineData {
  @override
  final OrdersHistory ordersHistory;
  @override
  @JsonKey()
  int pipelineCounter = 0;
  @override
  @JsonKey(ignore: true)
  var status = const BotStatus(BotPhases.offline, 'offline');
  @override
  @JsonKey(ignore: true)
  Timer? timer;

  @JsonKey(ignore: true)
  AveragePrice? lastAveragePrice;
  DateTime? buyOrderStartedAt;
  OrderNew? lastBuyOrder;
  OrderNew? lastSellOrder;

  /// TODO replace with check loss sell orders every day
  int lossSellOrderCounter = 0;

  MinimizeLossesPipeLineData({OrdersHistory? ordersHistory})
      : ordersHistory = ordersHistory == null
            ? ordersHistory = OrdersHistory([])
            : ordersHistory = ordersHistory;

  factory MinimizeLossesPipeLineData.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesPipeLineDataFromJson(json);

  Map<String, dynamic> toJson() => _$MinimizeLossesPipeLineDataToJson(this);
}