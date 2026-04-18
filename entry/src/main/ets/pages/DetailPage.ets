import { common } from '@kit.AbilityKit'
import { AppStorageV2 } from '@kit.ArkUI'
import { TodoModel } from '../model/TodoModel'
import { TodoViewModel } from '../viewmodel/TodoViewModel';
import { emitter } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct DetailPage {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext
  @Local todo?: TodoViewModel =
    AppStorageV2.connect<TodoViewModel>(TodoViewModel, 'todo_detail', () => new TodoViewModel(new TodoModel()))

  @Computed
  get todoInfo() {
    return !this.todo ? 'Empty todo' : this.todo.title;
  }

  aboutToAppear(): void {
    console.log('aboutToAppear')

    // emitter.on('todo_detail', (data: emitter.EventData) => {
    //   console.log('DetailPage > todo_detail_update', data)
    //   // this.todo = JSON.parse(data.data)
    // })
    this.context.eventHub.on('todo_detail_update', (data: string) => {
      console.log('DetailPage > todo_detail_update', data)
    })
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

  onPageHide(): void {
    // (this.getUIContext().getHostContext() as common.UIAbilityContext).terminateSelf()
  }
}