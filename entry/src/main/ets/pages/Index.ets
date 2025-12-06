import { SettingsComponent } from '../components/settings-component'
import {TodoList} from '../components/todo-list';
import { Detail } from './Detail';

@Entry
@Component
struct Index {
  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack()

  @Builder
  pageMap(name: string) {
    if (name === 'detail') {
      Detail();
    }
  }

  build() {
    Column() {
      Navigation(this.navPathStack) {
        Tabs({ barPosition: BarPosition.End }) {
          TabContent() {
            TodoList()
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
  }
}