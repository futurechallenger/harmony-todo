import { AppStorageV2 } from '@kit.ArkUI'
import { TodoModel } from '../model/TodoModel'
import { TodoViewModel } from '../viewmodel/TodoViewModel';

@Entry
@ComponentV2
struct DetailPage {
  @Local todo?: TodoViewModel =
    AppStorageV2.connect<TodoViewModel>(TodoViewModel, 'todo_detail', () => new TodoViewModel(new TodoModel()))

  @Computed
  get todoInfo() {
    return !this.todo ? 'Empty todo' : this.todo.title;
  }

  build() {
    Column() {
      Text(this.todoInfo)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}