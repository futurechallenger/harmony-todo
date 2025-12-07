@Preview
@Component
export struct Detail {
  // 固定数组数据
  private settingsItems: string[] = ['settings 1', 'settings 2'];

  build() {
    NavDestination() {
      Column() {
        Text("Detail")
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .title("Detail")
  }
}