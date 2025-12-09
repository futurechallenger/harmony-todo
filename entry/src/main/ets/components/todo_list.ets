import { Todo } from '../models/Todo';

@ComponentV2
export struct TodoList {
  // @Consumer('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @Require @Param todos: Array<Todo> = [];
  @Require @Param navPathStack: NavPathStack = new NavPathStack()
  @Event isShowFloatingButton: (isShow: boolean) => void = () => {
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