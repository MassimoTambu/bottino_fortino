part of minimize_losses_bot;

@JsonSerializable()
class MinimizeLossesBot implements Bot {
  @override
  late final String uuid;
  @override
  late final BotTypes type;
  @override
  late final bool testNet;
  @override
  late final MinimizeLossesConfig config;
  @override
  final String name;

  @JsonKey(ignore: true)
  Ref? ref;
  @JsonKey(ignore: true)
  Timer? timer;
  @JsonKey(ignore: true)
  var botStatus = BotStatus(BotPhases.offline, 'offline');
  double? buyOrderPrice;
  double? lastOrderPrice;
  dynamic? cryptoInfo;

  MinimizeLossesBot(this.name, this.testNet, this.config);

  MinimizeLossesBot.create({
    required this.name,
    required this.testNet,
    required int dailyLossSellOrders,
    required double maxInvestmentPerOrder,
    required double percentageSellOrder,
    required Duration timerBuyOrder,
  }) {
    uuid = const Uuid().v4();
    type = BotTypes.minimizeLosses;
    config = MinimizeLossesConfig.create(
      dailyLossSellOrders: dailyLossSellOrders,
      maxInvestmentPerOrder: maxInvestmentPerOrder,
      percentageSellOrder: percentageSellOrder,
      timerBuyOrder: timerBuyOrder,
    );
  }

  @override
  void start(Ref ref) async {
    botStatus = BotStatus(BotPhases.loading, 'loading');
    this.ref = ref;

    if (timer != null) timer!.cancel();

    if (buyOrderPrice != null) {
      /// TODO check every 10 seconds if buyOrderPrice is placed
      /// fetch buyOrder
      /// if is completed start _runBotPipeline

      timer = Timer.periodic(const Duration(seconds: 10), _runBuyOrderPipeline);

      await _submitBuyOrder();

      timer = Timer.periodic(const Duration(seconds: 10), _runBotPipeline);
    }

    botStatus = BotStatus(BotPhases.loading, 'submitting order price');

    /// TODO create order price
  }

  @override
  void stop() async {
    timer?.cancel();
    botStatus = BotStatus(BotPhases.offline, 'turned off');

    /// TODO notify
  }

  factory MinimizeLossesBot.fromJson(Map<String, dynamic> json) =>
      _$MinimizeLossesBotFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$MinimizeLossesBotToJson(this);

  Future<void> _runBuyOrderPipeline(Timer timer) async {
    if (!timer.isActive) return;
  }

  Future<void> _runBotPipeline(Timer timer) async {
    if (!timer.isActive) return;

    /// TODO check if order is open or closed.
    /// If closed check if is a gain or a loss.
    /// If is loss add to loss counter

    /// TODO check if is major or equal to loss counter.
    /// If so, shutdown bot and notify user

    // - fetch informazione sulla crypto ogni 10s
    // - Fare in modo che il bot aumenti l'ordine di vendita piazzando un ordine con un valore ricavato da questa formula:
    // (prezzo_attuale - (calcolo della % impostata verso il prezzo_iniziale)) > last_prezzo_ordine
    // - Memorizzare se l'ordine eseguito è risultato una perdita o un profitto.
    // - Controllare all'avvio se è presente un ordine in corso che è stato piazzato dall'ultimo avvio e ancora non si è concluso.
    cryptoInfo = await _fetchCryptoInfo();

    if (_hasToMoveOrder()) {
      await _moveOrder();
      //TODO notify order moved
    } else {
      // do nothing
    }
  }

  Future<dynamic> _submitBuyOrder() {
    //TODO implement _submitBuyOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _fetchCryptoInfo() {
    //TODO implement _fetchCryptoInfo
    return Future.delayed(const Duration(seconds: 1));
  }

  Future<dynamic> _moveOrder() {
    //TODO implement _moveOrder
    return Future.delayed(const Duration(seconds: 1));
  }

  bool _hasToMoveOrder() {
    return _calculateNewOrderPrice() > lastOrderPrice!;
  }

  double _calculateNewOrderPrice() {
    return cryptoInfo.actualValue -
        (buyOrderPrice! * config.percentageSellOrder! / 100);
  }
}
