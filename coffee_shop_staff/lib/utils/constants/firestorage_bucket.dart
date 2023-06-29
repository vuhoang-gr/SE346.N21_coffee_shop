class FireStorageBUCKET {
  FireStorageBUCKET({required this.id}) {
    user = UserBucket(id: id);
  }
  String id;
  late UserBucket user;
  ProductBucket products = ProductBucket();
  PromoBucket promo = PromoBucket();
  SizeBucket size = SizeBucket();
  ImageBucket image = ImageBucket();
}

class BUCKET {
  BUCKET({this.root, this.current = ""});
  BUCKET? root;
  String current;
  String? id;
  createPath() {
    return root != null ? root!.current + current : current;
  }

  getPath() {
    return current;
  }
}

class UserBucket extends BUCKET {
  UserBucket({String? id}) {
    this.id = id;
    current = "users/$id/";
    avatar = AvatarBucket(root: this);
    cover = CoverBucket(root: this);
  }
  late BUCKET avatar;
  late BUCKET cover;
}

class AvatarBucket extends BUCKET {
  AvatarBucket({root}) {
    this.root = root;
    current = "avatar/";
    current = createPath();
  }
}

class CoverBucket extends BUCKET {
  CoverBucket({root}) {
    this.root = root;
    current = "cover/";
    current = createPath();
  }
}

class SizeBucket extends BUCKET {
  SizeBucket() {
    current = 'size/';
  }
}

class PromoBucket extends BUCKET {
  PromoBucket() {
    current = 'promo/';
  }
}

class ProductBucket extends BUCKET {
  ProductBucket() {
    current = 'products/';
  }
  BUCKET food = AvatarBucket();
  BUCKET topping = CoverBucket();
}

class FoodBucket extends BUCKET {
  FoodBucket() {
    root = ProductBucket();
    current = "food/";
    current = createPath();
  }
}

class ToppingBucket extends BUCKET {
  ToppingBucket() {
    root = ProductBucket();
    current = "topping/";
    current = createPath();
  }
}

class ImageBucket extends BUCKET {
  ImageBucket() {
    current = "images/";
  }
}
