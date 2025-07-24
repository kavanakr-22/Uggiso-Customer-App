void debugLog(String message) {
  const bool isDebugMode = bool.fromEnvironment("dart.vm.product") == false;
  if (isDebugMode) {
    print(message);
  }
}
