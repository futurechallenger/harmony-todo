// @Preview
// @ComponentV2
// export struct AddTodoDialog {
//   build() {
//     Column() {
//       Text('Title')
//       TextInput({ placeholder: '请输入标题' })
//       Text('Title')
//       TextInput({ placeholder: '请输入标题' })
//
//       Row() {
//         Button() {
//           Text('Cancel')
//         }
//
//         Button() {
//           Text('OK')
//         }
//       }
//     }
//   }
// }

@Builder
function ButtonTitle(title: string) {
  Text(title)
    .width(80)
    .fontSize(14)
    .fontWeight(500)
    .fontColor(Color.White)
    .margin({
      right: 10,
      left: 10,
      top: 6,
      bottom: 6
    })
    .textAlign(TextAlign.Center)
}

@ComponentV2
export struct AddTodoDialog {
  inputController: TextInputController = new TextInputController()
  descController: TextAreaController = new TextAreaController()
  @Local titleText: string = ''
  @Local descText: string = ''
  @Require @Param onClose?: () => void
  @Event onAddTodo?: (title: string, desc: string) => void

  build() {
    Column() {
      Text('Title').fontColor(Color.Gray)
      TextInput({ placeholder: 'Enter title please', controller: this.inputController })
        .onChange((text) => {
          this.titleText = text
          console.log('text', text)
        })

      Text('Description').fontColor(Color.Gray)
        .margin({ top: 12 })
      TextArea({ placeholder: 'Enter description please', controller: this.descController })
        .maxLines(3)
        .minLines(3)
        .onChange((text) => {
          this.descText = text
          console.log('desc text', text)
        })

      Row() {
        Button() {
          ButtonTitle('Cancel')
        }
        .onClick(() => {
          this.onClose?.()
        })

        Column() {
        }.width(20)

        Button() {
          ButtonTitle('OK')
        }
        .onClick(() => {
          console.log('>>>>Add todo dialog: ')
          this.onAddTodo?.(this.titleText, this.descText)
          this.onClose?.()
        })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .margin({ top: 12 })
    }
    .padding({
      left: 20,
      right: 20,
      top: 16,
      bottom: 16
    })
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
  }
}
