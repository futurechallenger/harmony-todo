import { TodoList } from "./todo_list";
import { DBUtils } from '../libs/DBUtils'
import { TodoInfo } from '../models/TodoInfo'

@ComponentV2
export struct SettingsComponent {
  private dbUtils: DBUtils = new DBUtils(this.getUIContext())
  // 固定数组数据
  private settingsItems: string[] = ['settings 1', 'settings 2'];
  @Local todoList: TodoInfo[] = [];

  async aboutToAppear() {
    this.todoList = await this.dbUtils.queryData()
  }

  build() {
    Column() {
      List() {
        ForEach(this.todoList, (item: TodoInfo) => {
          ListItem() {
            Row() {
              Text(item.getTitle())
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