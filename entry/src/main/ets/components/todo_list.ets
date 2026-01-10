import { TodoInfo } from '../models/TodoInfo';
import { DBUtils } from '../libs/DBUtils'
import { Settings } from '../models/Settings'
import { PersistenceV2 } from '@kit.ArkUI'

/*
 * TODO:
 * 1. 长按删除
 * 2. Swipe action
 * 3. 使用多机协同，下拉刷新来同步多个机器的数据
 */
@ComponentV2
export struct TodoList {
  private dbUtils = new DBUtils(this.getUIContext())
  @Require @Param navPathStack: NavPathStack = new NavPathStack()
  @Event isShowFloatingButton: (isShow: boolean) => void = () => {
  }
  @Param todos: Array<TodoInfo> = []
  @Consumer('refreshTodoList') refreshTodoList: string = ''
  @Local settings: Settings = PersistenceV2.connect(Settings, 'Settings', () => new Settings())!

  async aboutToAppear() {
    console.log('======todo list aboutToAppear', this.refreshTodoList)
  }

  onDidBuild(): void {
    console.log('======todo list onDidBuild', this.refreshTodoList)
  }

  build() {
    Column() {
      Text(this.refreshTodoList)

      List() {
        ForEach(this.todos, (item: TodoInfo) => { // TODO: use Repeat later
          ListItem() {
            Column() {
              Row() {
                Column() {
                  Text(item.getTitle())
                    .fontWeight(FontWeight.Bold)
                    .fontColor($r('app.color.title_color'))
                    .fontSize(this.settings.fontSize === 'small' ? 16 : this.settings.fontSize === 'medium' ? 22 : 30)
                  Text(item.getDescription())
                    .fontColor($r('app.color.text_color'))
                    .fontSize(this.settings.fontSize === 'small' ? 14 : this.settings.fontSize === 'medium' ? 20 : 28)
                }
                .alignItems(HorizontalAlign.Start)

                Image($r('app.media.chevron_right'))
                  .width(24)
                  .height(24)
                  .onClick(() => {
                    this.isShowFloatingButton(false)
                    this.navPathStack.pushPathByName('detail', item)
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.SpaceBetween)
              .alignItems(VerticalAlign.Center)
              .padding({
                left: 16,
                right: 16,
                top: 10,
                bottom: 10
              })

              Divider()
            }
            .alignItems(HorizontalAlign.Start)
          }
        })
      }
      .width('100%')
      .height('100%')
    }
  }
}