import axios, { AxiosResponse } from '@ohos/axios';
import { fetchData } from '../services/todos_service';
import { SettingsComponent } from '../components/settings_component'
import { Settings } from '../models/Settings'
import { TodoList } from '../components/todo_list';
import { Detail } from './Detail';
import { AddTodoDialog } from '../components/add_todo_dialog';
import { TodoInfo, TodoInfoType } from '../models/TodoInfo';
import { DBUtils } from '../libs/DBUtils'
import { AppStorageV2, PersistenceV2, window } from '@kit.ArkUI';
import { ThemeModel } from '../models/ThemeModel';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { ConnectionStatus } from '../models/ConnectionStatus';
import { connection } from '@kit.NetworkKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import Fetch from '@system.fetch';
import { PostParamType, ResponseData } from '../libs/create_request';

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
  private dbUtils: DBUtils = new DBUtils(this.getUIContext())
  private currentWindow: window.Window | undefined = undefined
  // @Provider('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Local appTheme: ThemeModel | undefined = AppStorageV2.connect(ThemeModel, 'app_theme')
  @Local navPathStack: NavPathStack = new NavPathStack()
  @Local showFloatingButton: boolean = true
  @Local todoList: TodoInfo[] = []
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

  aboutToAppear(): void {
    console.log('=========Home page starting============')
    this.dbUtils.createDB()

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


    let netSpecifier: connection.NetSpecifier = {
      netCapabilities: {
        bearerTypes: [connection.NetBearType.BEARER_CELLULAR, connection.NetBearType.BEARER_WIFI],
        networkCap: [connection.NetCap.NET_CAPABILITY_INTERNET]
      }
    }

    let conn = connection.createNetConnection(netSpecifier, 10)

    conn.on('netAvailable', (data: connection.NetHandle) => {
      hilog.info(DOMAIN, 'connection status', `Succeeded in connecting, data is ${JSON.stringify(data)}`);
    });
    conn.on('netUnavailable', (data: void) => {
      hilog.info(DOMAIN, 'connection status', `network unavailable, data is ${JSON.stringify(data)}`)
    })

    conn.register((err: BusinessError, data: void) => {
      hilog.info(DOMAIN, 'connection status',
        `register result, err is ${JSON.stringify(err)}, data is ${JSON.stringify(data)}`)
    })
  }

  async onDidBuild() {
    console.log('=========Home page did build============')
    // NOTE: deal with sqlite `const ret = await this.dbUtils.queryData()`
    try {
      const todos = await fetchData() || [];
      console.log('===>>>todos', JSON.stringify(todos));

      this.todoList = todos || []
    } catch (error) {
      console.error('===>>>request error', error);
    }
  }

  @Builder
  dialogComponent() {
    AddTodoDialog({
      onAddTodo: async (title: string, desc: string) => {
        // await this.dbUtils.insertData(title, desc)
        // this.todoList = await this.dbUtils.queryData()
        // this.refreshTodoList = `refresh ${title} ${desc} - ${new Date().getTime()}}`

        const todoInfo: TodoInfoType = { title, description: desc }

        const ret: AxiosResponse<ResponseData<TodoInfoType>> =
          await axios.post('http://192.168.31.109:17788/add', todoInfo)
        console.log('===>>>todos', JSON.stringify(ret)); // this.todoList.push(todo.data)

        const todo: TodoInfoType | undefined = ret.data?.data;
        if (!todo) {
          throw new Error('Todo is empty')
        }
        this.todoList.push(new TodoInfo().init(todo?.id || -1, todo.title, todo.description, todo.completed || 0,
          todo.version || 0))
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
                todos: this.todoList,
                isShowFloatingButton: (isShow: boolean) => this.showFloatingButton = isShow,
                fetchData: async () => {
                  this.todoList = await fetchData() || []
                }
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