enum OrderStatus {
  preparing("Đang xử lí"),
  delivering("Đang giao"),
  delivered("Đã giao"),
  deliverFailed("Giao hàng thất bại"),
  prepared("Đã chuẩn bị"),
  completed("Hoàn thành"),
  cancelled("Đã hủy"),
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
      case 'Đang giao':
        return OrderStatus.delivering;
      case 'Đã giao':
        return OrderStatus.delivered;
      case 'Giao hàng thất bại':
        return OrderStatus.deliverFailed;
      case 'Đã chuẩn bị':
        return OrderStatus.prepared;
      case 'Hoàn thành':
        return OrderStatus.completed;
      case 'Đã hủy':
        return OrderStatus.cancelled;
      case 'Tất cả':
        return OrderStatus.all;
      default:
        return OrderStatus.preparing;
    }
  }
}
