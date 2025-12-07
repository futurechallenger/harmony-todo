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

@Builder
export function AddTodoDialog() {
  Column() {
    Text('Title').fontColor(Color.Gray)
    TextInput({ placeholder: 'Enter title please' })
    Text('Description').fontColor(Color.Gray)
      .margin({ top: 12 })
    TextInput({ placeholder: 'Enter description please' })

    Row() {
      Button() {
        ButtonTitle('Cancel')
      }

      Column() {
      }.width(20)

      Button() {
        ButtonTitle('OK')
      }
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
