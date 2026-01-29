import axios, { Axios, AxiosResponse } from '@ohos/axios';
import { ResponseData } from '../libs/create_request';
import { TodoInfo, TodoInfoType } from '../models/TodoInfo';
import { JSON } from '@kit.ArkTS';

@Preview
@ComponentV2
export struct Detail {
  @Local todoId: number = 0
  @Local todo?: TodoInfo
  @Local highlightStatus: number = -1
  @Local stack: NavPathStack = new NavPathStack();

  aboutToAppear(): void {
    this.highlightStatus = this.todo?.getCompleted() ? 1 : 0

    const params: TodoInfo = this.stack.getParamByName('detail')?.[0] as TodoInfo;

    console.log('> todo detail > aboutToAppear, todo ID: ', this.todoId)
    console.log('> todo detail > aboutToAppear, todo params: ', JSON.stringify(params))
  }

  onDidBuild(): void {
    console.log('> todo detail > onDidBuild, todo ID: ', this.todoId)
  }

  private async updateTodoStatus(completed: boolean): Promise<void> {
    if (this.todo) {
      try {
        // await database.update(this.todo.getID(), this.todo.getTitle(), this.todo.getDescription(), completed)
        console.log(`Updated todo ${this.todo.getID()} to completed: ${completed}`)
      } catch (error) {
        console.error('Error updating todo:', error)
      }
    }
  }

  build() {
    NavDestination() {
      Column() {
        Text(this.todo?.getTitle())
          .fontSize(46)
        Text(this.todo?.getDescription())
          .fontSize(20)
          .fontColor(Color.Gray)
        Row() {
          Column() {
            Text('In Progress')
              .fontSize(this.highlightStatus === 0 ? 24 : 16)
              .fontColor(this.highlightStatus === 0 ? Color.White : Color.Black)
          }
          .backgroundColor(Color.Red)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)
          .onClick(() => {
            console.log('In Progress')
            this.highlightStatus = 0;
            this.updateTodoStatus(false)
          })
          .height('100%')

          Column() {
            Text('Complete')
              .fontSize(this.highlightStatus === 1 ? 24 : 16)
              .fontColor(this.highlightStatus === 1 ? Color.White : Color.Black)
          }
          .backgroundColor(Color.Green)
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .layoutWeight(1)
          .onClick(() => {
            console.log('Completed')
            this.highlightStatus = 1;
            this.updateTodoStatus(true)
          })
          .height('100%')
        }
        .width('100%')
        .height(80)
        .borderWidth(2)
        .borderRadius(20)
        .clip(true)
      }
      .width('100%')
      .height('100%')
      .padding({
        left: 20,
        right: 20,
        top: 15,
        bottom: 15
      })
      .justifyContent(FlexAlign.SpaceAround)
      .alignItems(HorizontalAlign.Center)
      .layoutWeight(2)

      Column() {

      }.layoutWeight(1)
    }
    .title("Detail")
    .onReady((context: NavDestinationContext) => {
      const params = context.pathInfo.param as TodoInfo;
      console.log('==> todo detail > Nav params > ', { title: params?.getTitle(), id: params?.getID() })
      // const newTodo = new TodoInfo();
      // newTodo.init(params.getID() || 0, params.getTitle(), params.getDescription(),!params.getCompleted() ? 0 : 1, params.getVersion())
      // this.todo = newTodo
      this.todoId = params?.getID() || 0
      console.log('>>>detail page > requesting todo detail')
      axios.get(`http://192.168.31.109:17788/todo/${this.todoId}`)
        .then((res: AxiosResponse<ResponseData<TodoInfoType | null>>) => {
          const temp: TodoInfoType | null = res.data.data;
          if (!temp) {

            console.log('>>>detail page > requesting todo detail > no data')
            return;
          }
          const todo = new TodoInfo().init(temp.id, temp.title, temp.description, temp.completed, temp.version);

          console.log('>>>detail page > requesting todo detail', JSON.stringify(todo));
          this.todo = todo
        })
    })
  }
}