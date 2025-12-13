import { Todo } from '../models/Todo';
import { DatabaseFactory } from '../database/DatabaseFactory';
import { TodoService } from '../services/TodoService';

@ComponentV2
export struct TodoList {
  // @Consumer('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @Require @Param navPathStack: NavPathStack = new NavPathStack()
  @Event isShowFloatingButton: (isShow: boolean) => void = () => {
  }
  @Local todos: Array<Todo> = []
  private todoService = TodoService.getInstance()

  aboutToAppear(): void {
    this.loadTodos()
  }

  private async loadTodos(): Promise<void> {
    try {
      this.todos = await this.todoService.getAllTodos()
    } catch (error) {
      console.error('Error loading todos:', error)
    }
  }

  private async deleteTodo(id: number): Promise<void> {
    try {
      await this.todoService.deleteTodo(id)
      await this.loadTodos()
    } catch (error) {
      console.error('Error deleting todo:', error)
    }
  }

  build() {
    Column() {
      List() {
        ForEach(this.todos, (item: Todo) => {
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