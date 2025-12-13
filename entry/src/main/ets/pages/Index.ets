import { hilog } from '@kit.PerformanceAnalysisKit';
import { TodoService } from '../services/TodoService'
import { SettingsComponent } from '../components/settings_component'
import { TodoList } from '../components/todo_list';
import { Detail } from './Detail';
import { AddTodoDialog } from '../components/add_todo_dialog';
import { Todo } from '../models/Todo';
import { deviceInfo } from '@kit.BasicServicesKit';

@Entry
@ComponentV2
struct Index {
  private dialogComponentId: number = -1
  @Local todos: Array<Todo> = [
    new Todo(1, 'todo 1', 'todo 1 description', false),
    new Todo(2, 'todo 2', 'todo 2 description', false),
  ]
  // @Provider('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @Local navPathStack: NavPathStack = new NavPathStack()
  @Local showFloatingButton: boolean = true

  aboutToAppear(): void {
    console.log('=========Home page starting============')

    this.navPathStack.setInterception({
      willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",
        operation: NavigationOperation, animated: boolean) => {
        console.log(`Navigation will show from: ${from} to: ${to}, param: ${JSON.stringify(operation.toString())}`)

        if (typeof to === 'string') {
          this.showFloatingButton = true
        }
      }
    })
  }

  @Builder
  dialogComponent() {

    // @Event onAddTodo?: (title: string, desc: string) => void
    AddTodoDialog({
      onAddTodo: (title: string, desc: string) => {
        const todoService = new TodoService()
        todoService.createTodo(title, desc)
      },
      onClose: () => {
        this.getUIContext().getPromptAction().closeCustomDialog(this.dialogComponentId)
      }
    })
  }

  @Builder
  pageMap(name: string) {
    if (name === 'detail') {
      Detail();
    }
  }

  build() {
    Stack() {
      Column() {
        Navigation(this.navPathStack) {
          Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
              TodoList({
                navPathStack: this.navPathStack,
                isShowFloatingButton: (isShow: boolean) => this.showFloatingButton = isShow
              })
            }
            .tabBar('Home')

            TabContent() {
              SettingsComponent()
            }
            .tabBar('Settings')
          }
          .scrollable(false)
          .height('100%')
          .width('100%')
        }
        .title("Items")
        .navDestination(this.pageMap)
      }

      // Floating Button
      if (this.showFloatingButton) {
        Button() {
          Text('+')
            .fontSize(24)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
        }
        .width(56)
        .height(56)
        .backgroundColor('#0A59F7')
        .borderRadius(28)
        .position({ x: '82%', y: '85%' })
        .shadow({
          radius: 8,
          color: '#40000000',
          offsetX: 0,
          offsetY: 2
        })
        .onClick((event: ClickEvent) => {
          console.log('add button is clicked')
          this.getUIContext()
            .getPromptAction()
            .openCustomDialog({
              builder: () => {
                this.dialogComponent()
                // AddTodoDialog() NOTE Error
              },
              isModal: true,
              // maskColor: Color.Yellow,
            })
            .then((dialogId: number) => {
              this.dialogComponentId = dialogId
            })
            .catch((err: BusinessError) => {
              console.error(`openCustomDialog error: ${err.message}`)
            })
        })
      }
    }
  }
}