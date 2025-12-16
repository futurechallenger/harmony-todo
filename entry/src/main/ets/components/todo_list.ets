import { TodoInfo } from '../models/TodoInfo';
import { DBUtils } from '../libs/DBUtils'

@ComponentV2
export struct TodoList {
  private dbUtils = new DBUtils(this.getUIContext())
  // @Consumer('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @Require @Param navPathStack: NavPathStack = new NavPathStack()
  @Event isShowFloatingButton: (isShow: boolean) => void = () => {
  }
  @Param todos: Array<TodoInfo> = []
  @Consumer('refreshTodoList') refreshTodoList: string = ''

  async aboutToAppear() {
    console.log('======todo list aboutToAppear', this.refreshTodoList)
    // await this.loadTodos()
  }

  onDidBuild(): void {
    console.log('======todo list onDidBuild', this.refreshTodoList)
    // this.loadTodos()
  }

  build() {
    Column() {
      Text(this.refreshTodoList)

      List() {
        ForEach(this.todos, (item: TodoInfo) => {
          ListItem() {
            Column() {
              Row() {
                Column() {
                  Text(item.getTitle())
                  Text(item.getDescription())
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