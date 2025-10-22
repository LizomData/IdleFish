// Ability 入口需要的系统能力与项目工具
import UIAbility from '@ohos.app.ability.UIAbility';
import hilog from '@ohos.hilog';
import { i } from 'hytech';
import { window } from '@kit.ArkUI';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import PreferenceUtil from '../util/PreferencesUtil';
import { Path_splash } from '../pages/SplashPage';
import { BusinessError } from '@kit.BasicServicesKit';
import { Path_Login } from '../pages/LoginPage';

export default class EntryAbility extends UIAbility {

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', 'Ability onCreate');
  }

  onDestroy() {
    hilog.info(0x0000, 'testTag', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage) {
    hilog.info(0x0000, 'testTag', 'Ability onWindowStageCreate');
    i(this.context, '#cacfbbaf');

    let windowClass: window.Window | undefined = undefined;
    windowStage.getMainWindow((err: BusinessError, data) => {
      if (err.code) {
        console.error('Failed to obtain the main window. Cause: ' + JSON.stringify(err));
        return;
      }
      windowClass = data;
      console.info('Succeeded in obtaining the main window.');

      const names: ('status' | 'navigation')[] = ['status'];
      windowClass.setWindowSystemBarEnable(names, (err) => {
        if (err.code) {
          console.error('Failed to hide system bars. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('System bars hidden successfully.');
      });

      const isLayoutFullScreen = true;
      windowClass.setWindowLayoutFullScreen(isLayoutFullScreen, (err) => {
        if (err.code) {
          console.error('Failed to enable full-screen layout. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('Full-screen layout enabled.');
      });

      const sysBarProps: window.SystemBarProperties = {
        statusBarColor: '#00000000',
        navigationBarColor: '#00000000',
        statusBarContentColor: '#ff000000',
        navigationBarContentColor: '#ffffff'
      };
      windowClass.setWindowSystemBarProperties(sysBarProps, (err) => {
        if (err.code) {
          console.error('Failed to set system bar properties. Cause:' + JSON.stringify(err));
          return;
        }
        console.info('System bar properties set successfully.');
      });
    });

    windowStage.loadContent(Path_splash, (err, data) => {
      if (err.code) {
        hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', JSON.stringify(data) ?? '');
    });

    PreferenceUtil.init(this.context);
    // DbUtil.init(this.context);
  }

  onWindowStageDestroy() {
    hilog.info(0x0000, 'testTag', 'Ability onWindowStageDestroy');
  }

  onForeground() {
    hilog.info(0x0000, 'testTag', 'Ability onForeground');
  }

  onBackground() {
    hilog.info(0x0000, 'testTag', 'Ability onBackground');
  }
}