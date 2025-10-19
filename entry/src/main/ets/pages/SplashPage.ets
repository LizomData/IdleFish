import router from '@ohos.router';
import PreferencesUtil from '../util/PreferencesUtil';
import { Path_Login } from './LoginPage';
import { Path_Main } from './MainPage';
import { promptAction } from '@kit.ArkUI';
import { GlobalVariable } from '../util/GlobalVariable';

/**
 * 欢迎页，可以设置倒计时
 */

export const Path_splash = 'pages/SplashPage'

@Entry
@Component
struct SplashPage {

  async  aboutToAppear()  {
    GlobalVariable.server_ip='your_server_ip';
  }

  //倒计时
  @State countDownSeconds: number = 5;
  private timeId: number = 0;
  private TAG: string = 'AdvertisingPage';

  onPageShow() {
    // 启动倒计时，每秒更新一次剩余时间
    this.timeId = setInterval(() => {
      if (this.countDownSeconds === 0) {
        this.jumpToAppHomePage();
      } else {
        this.countDownSeconds--;
      }
    }, 1000);
  }

  onPageHide() {
    // 页面隐藏时清理路由堆栈及定时器，防止内存泄漏
    router.clear();
    clearInterval(this.timeId);
  }

  /**
   * 跳转到主页.
   */
  async jumpToAppHomePage() {
    // 欢迎页跳转到登录页，后续可扩展到主页
    const token: string = await PreferencesUtil.getStringPreference('token', '');
    const username: string = await PreferencesUtil.getStringPreference('user_name', '');

    GlobalVariable.user_name=username;
    GlobalVariable.token=token;


    if (token == "") {
      router.pushUrl({
        url: Path_Login
      }).catch((error: Error) => {
        //Logger.error(this.TAG, 'AdvertisingPage pushUrl error ' + JSON.stringify(error));
      });
      return
    }

    promptAction.showToast({
      message: "欢迎回来: "+username,
      duration: 1000,
      bottom: '360vp'
    })

    // 路由跳转
    router.replaceUrl({
      url: Path_Main
    }).catch((err: Error) => {
      // 错误提示
    })

  }

  build() {
    // 使用全屏背景图片叠加跳过按钮
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.splash'))
        .width('100%')
        .height('100%')
      Text($r('app.string.advertising_text_title', this.countDownSeconds))
        .fontColor(Color.White)
        .fontSize('12fp')
        .letterSpacing(0.05)
        .backgroundColor('#33000000')
        .border({
          radius: '18vp',
          width: '1',
          color: Color.White
        })
        .margin({
          top: '30vp',
          left: '260vp'
        })
        .padding({
          left: '12vp',
          top: '8vp',
          right: '12vp',
          bottom: '8vp'
        })
        .onClick(() => {
          this.jumpToAppHomePage();
        })
    }
    .width('100%')
    .height('100%')
  }
}
