abstract class SizeStoreState {
  SizeStoreState();
}

class LoadingState extends SizeStoreState {
  LoadingState();
}

class ErrorState extends SizeStoreState {
  ErrorState();
}

class LoadedState extends SizeStoreState {
  LoadedState();
}

class FetchedState extends SizeStoreState {
  FetchedState();
}