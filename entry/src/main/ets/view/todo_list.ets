import { TodoModel } from '../model/TodoModel';
import { common, Want } from '@kit.AbilityKit'
import { DBUtils } from '../libs/DBUtils'
import { Settings } from '../viewmodel/Settings'
import { PersistenceV2 } from '@kit.ArkUI'
import axios, { AxiosResponse } from '@ohos/axios';
import { TodoListViewModel } from '../viewmodel/TodoListViewModel';
import { TodoViewModel } from '../viewmodel/TodoViewModel';

/*
 * TODO:
 * 1. 长按删除
 * 2. Swipe action
 * 3. 使用多机协同，下拉刷新来同步多个机器的数据
 */
@ComponentV2
export struct TodoList {
  private dbUtils = new DBUtils(this.getUIContext())
  @Require @Param navPathStack: NavPathStack = new NavPathStack()
  @Event isShowFloatingButton: (isShow: boolean) => void = () => {
  }
  @Require @Param todos: TodoViewModel[];
  @Consumer('refreshTodoList') refreshTodoList: string = ''
  @Local settings: Settings = PersistenceV2.connect(Settings, 'Settings', () => new Settings())!
  @Local refreshing: boolean = false

  async aboutToAppear() {
    console.log('======todo list aboutToAppear', this.refreshTodoList)
    console.log('======todo list aboutToAppear', this.todos)
  }

  onDidBuild(): void {
    console.log('======todo list onDidBuild', this.refreshTodoList)
  }

  build() {
    Column() {
      Text(this.refreshTodoList)

      Refresh({ refreshing: this.refreshing }) {
        List() {
          ForEach(this.todos, (item: TodoViewModel) => { // TODO: use Repeat or LazyForEach later
            ListItem() {
              Column() {
                Row() {
                  Column() {
                    Text(item.title)
                      .fontWeight(FontWeight.Bold)
                      .fontColor($r('app.color.title_color'))
                      .fontSize(this.settings.fontSize === 'small' ? 16 : this.settings.fontSize === 'medium' ? 22 : 30)
                    Text(item.description)
                      .fontColor($r('app.color.text_color'))
                      .fontSize(this.settings.fontSize === 'small' ? 14 : this.settings.fontSize === 'medium' ? 20 : 28)
                  }
                  .alignItems(HorizontalAlign.Start)

                  Image($r('app.media.chevron_right'))
                    .width(24)
                    .height(24)
                    .onClick(() => {
                      this.isShowFloatingButton(false)
                      // this.navPathStack.pushPathByName('detail', item)

                      const want: Want = {
                        deviceId: '',
                        bundleName: 'com.example.myapplication',
                        abilityName: 'DetailAbility',
                        parameters: {
                          todo: JSON.stringify(item.toModel())
                        }
                      };
                      (this.getUIContext().getHostContext() as common.UIAbilityContext).startAbility(want)
                    })
                }
                .width('100%')
                .justifyContent(FlexAlign.SpaceBetween)
                .alignItems(VerticalAlign.Center)
                .padding({
                  left: 16,
                  right: 16,
                  top: 10,
                  bottom: 10
                })

                Divider()
              }
              .alignItems(HorizontalAlign.Start)
            }
          })
        }
        .width('100%')
        .height('100%')
      }
      .onRefreshing(async () => {
        console.log('======todo list onRefresh')
        this.refreshing = true;

        try {
          this.refreshing = false;
          console.log('======todo list onRefresh done')
        } catch (err) {
          console.error('refresh error:', err.message)
          this.refreshing = false;
          console.log('======todo list onRefresh done')
        }
      })
      .pullToRefresh(true)
    }
  }

  @Builder
  customRefreshView() {
    Column() {
      Text('Refreshing...')
    }
  }
}
