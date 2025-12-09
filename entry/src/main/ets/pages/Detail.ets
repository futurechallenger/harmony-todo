import { Todo } from '../models/Todo'

@Preview
@ComponentV2
export struct Detail {
  // 固定数组数据
  @Local todo?: Todo

  build() {
    NavDestination() {
      Column() {
        Text(this.todo?.getTitle())
        Text(this.todo?.getDescription())
        Text(this.todo?.getCompleted() ? '已完成' : '未完成')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
    }
    .title("Detail")
    .onReady((context: NavDestinationContext) => {
      const params = context.pathInfo.param as Todo;
      console.log('Nav params > ', params.getTitle())
      this.todo = new Todo(params.getID(), params.getTitle(), params.getDescription(), params.getCompleted())
    })
  }
}