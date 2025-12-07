import { hilog } from '@kit.PerformanceAnalysisKit';
import { SettingsComponent } from '../components/settings-component'
import { TodoList } from '../components/todo-list';
import { Detail } from './Detail';

@Entry
@ComponentV2
struct Index {
  // @Provider('navPathStack') navPathStack: NavPathStack = new NavPathStack()
  @Local navPathStack: NavPathStack = new NavPathStack()
  @Local showFloatingButton: boolean = true

  aboutToAppear(): void {
    this.navPathStack.setInterception({
      willShow: (from: NavDestinationContext | "navBar", to: NavDestinationContext | "navBar",
        operation: NavigationOperation, animated: boolean) => {
        console.log(`Navigation will show from: ${from} to: ${to}, param: ${JSON.stringify(operation.toString())}`)

        if(typeof to === 'string') {
          this.showFloatingButton = true
        }
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
        })
      }
    }
  }
}