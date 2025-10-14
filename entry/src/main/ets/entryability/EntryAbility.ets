// Ability 入口需要的系统能力与项目工具
import UIAbility from '@ohos.app.ability.UIAbility';
import { t as UIEntryAbility } from 'ohbuild';
import hilog from '@ohos.hilog';
import { i } from 'hytech';
import window from '@ohos.window';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import PreferenceUtil from '../util/PreferencesUtil';
import { Path_splash } from '../pages/SplashPage';
import DbUtil from '../util/DbUtil';
import { Path_Main } from '../pages/MainPage';
import { BusinessError } from '@kit.BasicServicesKit';
import { Path_Login } from '../pages/LoginPage';

export default class EntryAbility extends UIEntryAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {

  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    // Main window is created, set main page for this ability
    i(this.context, '#cacfbbaf')
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');

    //沉浸式 获取应用主窗口
    let windowClass: window.Window = this.getWindow(windowStage, 'secondTransaction');
    // 1. 设置窗口全屏
    let isLayoutFullScreen = true;
    windowClass.setWindowLayoutFullScreen(isLayoutFullScreen)
      .then(() => {
        console.info('Succeeded in setting the window layout to full-screen mode.');
      })
      .catch((err: BusinessError) => {
        console.error('Failed to set the window layout to full-screen mode. Cause:' + JSON.stringify(err));
      });

    // 默认加载闪屏页作为入口
    windowStage.loadContent(Path_splash, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });
    // 初始化首选项与数据库工具
    PreferenceUtil.init(this.context)
    DbUtil.init(this.context)
  }

  onWindowStageDestroy() {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground() {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
  }
}
