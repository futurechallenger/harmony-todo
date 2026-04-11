@ObservedV2
class ConnectionStatus {
  @Trace
  public isConnected?: boolean = false;

  constructor(isConnected?: boolean) {
    this.isConnected = isConnected;
  }
}

export { ConnectionStatus }