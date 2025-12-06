import { Todo } from '../models/Todo';

@ComponentV2
export struct TodoList {
  private todos: Array<Todo> = [
    new Todo(1, 'todo 1', 'todo 1 description', false),
    new Todo(1, 'todo 2', 'todo 2 description', false),
  ]

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
              }
              .justifyContent(FlexAlign.Start)
              .padding({
                left: 16,
                right: 16,
                top: 10,
                bottom: 10
              })
              .backgroundColor(Color.Yellow)

              Divider()
            }
            .alignItems(HorizontalAlign.Start)
            .backgroundColor(Color.Red)
          }
        })
      }
      .width('100%')
      .height('100%')
    }
  }
}