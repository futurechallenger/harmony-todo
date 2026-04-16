import { fetchData } from '../services/todos_service';
import { SettingsComponent } from '../view/settings_component'
import { TodoList } from '../view/todo_list';
import { Detail } from './Detail';
import { AddTodoDialog } from '../view/add_todo_dialog';
import { DBUtils } from '../libs/DBUtils'
import { AppStorageV2, PersistenceV2, window } from '@kit.ArkUI';
import { ThemeModel } from '../viewmodel/ThemeModel';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { TodoListViewModel } from '../viewmodel/TodoListViewModel';

const DOMAIN = 0x0000

interface Res {
  code: number,
  msg: string
}

/**
 * TODO: Use @ObservedV2 to crate view models
 */

@Entry
@ComponentV2
struct Index {
  private dialogComponentId: number = -1
  private currentWindow: window.Window | undefined = undefined

  @Local appTheme: ThemeModel | undefined = AppStorageV2.connect(ThemeModel, 'app_theme', () => new ThemeModel())
  @Local navPathStack: NavPathStack = new NavPathStack()
  @Local showFloatingButton: boolean = true
  @Local todoList: TodoListViewModel = new TodoListViewModel(this.getUIContext().getHostContext())
  @Provider('refreshTodoList') refreshTodoList: string = '';

  @Monitor('appTheme.currentColorMode')
  onAppThemeChange(monitor: IMonitor) {
    console.log('>>>>>>>>===>>>monitor of color mode', JSON.stringify(monitor.value()?.now));
    const colorMode = monitor.value()?.now as ConfigurationConstant.ColorMode | undefined
    if (colorMode === void 0 || !this.currentWindow || !this.appTheme) {
      return;
    }

    if (this.appTheme.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT) {
      this.currentWindow?.setWindowSystemBarProperties({
        statusBarContentColor: '#E74646'
      }).catch(() => {
        // TODO: Implement error handling.
        console.log('==>>>light theme error')
      })
    } else if (this.appTheme.currentColorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK) {
      this.currentWindow?.setWindowSystemBarProperties({
        statusBarContentColor: '#B2F297'
      }).catch(() => {
        // TODO:
        console.log('==>>>dark theme error')
      })
    }
  }

  async aboutToAppear(): Promise<void> {
    console.log('=========Home page starting============')
    // TODO: init the db again here?
    // this.dbUtils.createDB()
    await this.todoList.loadTodoList()

    window.getLastWindow(this.getUIContext().getHostContext(), (err: BusinessError, data) => {
      this.currentWindow = data
    })

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

  async onDidBuild() {
    console.log('=========Home page did build============')
  }

  @Builder
  dialogComponent() {
    AddTodoDialog({
      onAddTodo: async (title: string, desc: string) => {
        // TODO: add todo
        // TODO: refresh todo list

        await this.todoList.addTodo(title, desc)
        this.refreshTodoList = `refresh ${title} ${desc} - ${new Date().getTime()}}`
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
                todos: this.todoList.todoList,
                isShowFloatingButton: (isShow: boolean) => this.showFloatingButton = isShow,
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
              },
              isModal: true,
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

