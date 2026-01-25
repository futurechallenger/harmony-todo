import { CapsuleSegmentButtonV2, PersistenceV2, SegmentButton, SegmentButtonV2Items } from '@kit.ArkUI'
import { TodoInfo } from '../models/TodoInfo'
import { Settings } from '../models/Settings'

@Preview
@ComponentV2
export struct SettingsComponent {
  private settingsItems: string[] = ['settings 1', 'settings 2'];
  @Local todoList: TodoInfo[] = [];
  @Local settings: Settings = PersistenceV2.connect(Settings, 'Settings', () => new Settings())!
  @Local selectedIndex: number = 0

  aboutToAppear() {
    this.selectedIndex = this.settings.fontSize === 'small' ? 0 : this.settings.fontSize === 'medium' ? 1 : 2
  }

  onDidBuild(): void {
    console.log('===>>>SETTINGS onDidBuild', this.settings.fontSize)
  }

  build() {
    Column() {
      List() {
        ListItem() {
          Column() {
            Text('Font size')
              .fontSize(14)
              .fontColor(Color.Gray)
              .gesture(
                TapGesture().onAction(() => {
                  console.log('===>>>SETTINGS Text Tap gesture onAction')
                })
              )

            CapsuleSegmentButtonV2({
              items: new SegmentButtonV2Items([
                { text: "Small" },
                { text: "Medium" },
                { text: "large" },
              ]),
              selectedIndex: this.selectedIndex, //  this.settings.fontSize === 'small' ? 0 : this.settings.fontSize === 'medium' ? 1 : 2,
              $selectedIndex: (index: number) => {
                this.selectedIndex = index
                this.settings.fontSize = index === 0 ? 'small' : index === 1 ? 'medium' : 'large'
              }
            })
              .margin({ top: 10 })
          }
          .gesture(TapGesture().onAction(() => {
            console.log('===>>>SETTINGS Column Tap gesture onAction', this.selectedIndex)
          }))
          .width('100%')
          .padding(16)
          .backgroundColor(Color.White)
          .borderRadius(8)
          .margin({ bottom: 8 })
          .alignItems(HorizontalAlign.Start)
        }
      }
      .width('100%')
      .height('100%')
      .padding(16)
      .backgroundColor('#F5F5F5')
    }
  }
}