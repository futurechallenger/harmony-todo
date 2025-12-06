@Preview
@Component
export struct Detail {
  // 固定数组数据
  private settingsItems: string[] = ['settings 1', 'settings 2'];

  build() {
    Column() {
      List() {
        ForEach(this.settingsItems, (item: string) => {
          ListItem() {
            Row() {
              Text(item)
                .fontSize(16)
                .fontColor(Color.Black)
            }
            .width('100%')
            .padding(16)
            .backgroundColor(Color.White)
            .borderRadius(8)
            .margin({ bottom: 8 })
          }
        })
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
    }
  }
}