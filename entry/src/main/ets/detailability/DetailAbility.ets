import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { AppStorageV2, window } from '@kit.ArkUI';
import { TodoModel } from '../model/TodoModel';
import { TodoViewModel } from '../viewmodel/TodoViewModel';

const DOMAIN = 0x0000;

export default class DetailAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onCreate');
    const todo = want?.parameters?.['todo'];
    console.log('>>>todo>>>', todo);

    if (!todo) {
      hilog.error(DOMAIN, 'testTag', 'todo is null');
      return;
    }

    const todoInfo =new TodoViewModel( JSON.parse(todo as string) as TodoModel);
    AppStorageV2.connect<TodoViewModel>(TodoViewModel, 'todo_detail', () => todoInfo)
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onWindowStageCreate');

    windowStage.loadContent('pages/DetailPage', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'testTag', 'Succeeded in loading the content.');
    });
  }

  onNewWant(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onNewWant', want);
    const todo = want?.parameters?.['todo'];
    if (!todo) {
      hilog.error(DOMAIN, 'testTag', 'todo is null');
      return;
    }

    const todoInfo =new TodoViewModel( JSON.parse(todo as string) as TodoModel);
    AppStorageV2.connect<TodoViewModel>(TodoViewModel, 'todo_detail', () => todoInfo)
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(DOMAIN, 'testTag', '%{public}s', 'DetailAbility onBackground');
  }
}
