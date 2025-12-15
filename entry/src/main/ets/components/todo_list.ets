import { TodoInfo } from '../models/TodoInfo';
import { DBUtils } from '../libs/DBUtils'
import { DatabaseFactory } from '../database/DatabaseFactory';

// import { TodoService } from '../services/TodoService';

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

  // private async loadTodos(): Promise<void> {
  //   try {
  //     console.log('===load todos')
  //
  //     // const todos = await this.todoService.getAllTodos()
  //     const todos = await this.dbUtils.queryData();
  //     this.todos = todos;
  //
  //     console.log('===load todos done', this.todos)
  //   } catch (error) {
  //     console.error('Error loading todos:', error)
  //   }
  // }

  // private async deleteTodo(id: number): Promise<void> {
  //   try {
  //     // await this.todoService.deleteTodo(id)
  //     await this.loadTodos()
  //   } catch (error) {
  //     console.error('Error deleting todo:', error)
  //   }
  // }

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