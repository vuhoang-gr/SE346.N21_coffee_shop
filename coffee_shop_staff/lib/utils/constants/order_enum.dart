enum OrderStatus {
  preparing("Preparing"),
  delivering("Delivering"),
  delivered("Delivered"),
  deliverFailed("Delivery Failed"),
  received("Received"),
  prepared("Prepared"),
  completed("Commpleted"),
  cancelled("Cancelled");

  final String name;
  const OrderStatus(this.name);
}

extension ParseToString on OrderStatus {
  String toOrderString() {
    return name;
  }
}

extension StringToOrder on String {
  OrderStatus toOrderStatus() {
    switch (this) {
      case 'Preparing':
        return OrderStatus.preparing;
      case 'Delivering':
        return OrderStatus.delivering;
      case 'Delivered':
        return OrderStatus.delivered;
      case 'Delivery Failed':
        return OrderStatus.deliverFailed;
      case 'Received':
        return OrderStatus.received;
      case 'Prepared':
        return OrderStatus.prepared;
      case 'Commpleted':
        return OrderStatus.completed;
      case 'Cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.preparing;
    }
  }
}
