abstract class ToppingStoreState {
  ToppingStoreState();
}

class LoadingState extends ToppingStoreState {
  LoadingState();
}

class ErrorState extends ToppingStoreState {
  ErrorState();
}

class LoadedState extends ToppingStoreState {
  LoadedState();
}

class FetchedState extends ToppingStoreState {
  FetchedState();
}
