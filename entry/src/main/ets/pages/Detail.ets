import { Todo } from '../models/Todo'

@Preview
@ComponentV2
export struct Detail {
  @Local todo?: Todo
  @Local highlightStatus: number = -1

  aboutToAppear(): void {
    this.highlightStatus = this.todo?.getCompleted() ? 1 : 0
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
      const params = context.pathInfo.param as Todo;
      console.log('Nav params > ', params?.getTitle())
      this.todo = new Todo(params.getID(), params.getTitle(), params.getDescription(), params.getCompleted())
    })
  }
}