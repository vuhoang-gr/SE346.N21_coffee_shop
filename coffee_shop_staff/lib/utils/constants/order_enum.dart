enum OrderStatus {
  preparing("Đang xử lí"),
  delivering("Đang giao hàng"),
  delivered("Đã giao hàng"),
  deliverFailed("Giao hàng thất bại"),
  received("Đã nhận"),
  prepared("Đang chuẩn bị"),
  completed("Đã hoàn thành"),
  cancelled("Đã hủy đơn"),
  all("Tất cả");

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
      case 'Đang xử lí':
        return OrderStatus.preparing;
      case 'Đang giao hàng':
        return OrderStatus.delivering;
      case 'Đã giao hàng':
        return OrderStatus.delivered;
      case 'Giao hàng thất bại':
        return OrderStatus.deliverFailed;
      case 'Đã nhận':
        return OrderStatus.received;
      case 'Đang chuẩn bị':
        return OrderStatus.prepared;
      case 'Đã hoàn thành':
        return OrderStatus.completed;
      case 'Đã hủy đơn':
        return OrderStatus.cancelled;
      case 'Tất cả':
        return OrderStatus.all;
      default:
        return OrderStatus.preparing;
    }
  }
}
