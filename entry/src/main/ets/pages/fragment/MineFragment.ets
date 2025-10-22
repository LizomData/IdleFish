import router from '@ohos.router';
import { o } from "hytech"
import promptAction from '@ohos.promptAction';
import { Path_Login } from '../LoginPage';
import PreferencesUtil from '../../util/PreferencesUtil';


@Preview
@Entry
@Component
export struct MineFragment {
  @State username: string ="";

  async aboutToAppear() {

    const userName: string = await PreferencesUtil.getStringPreference('user_name', '');

    // 更新状态
    if (userName.trim() === "") {
      this.username = 'Guest';
    } else {
      this.username = userName;
    }
  }

  build() {
    Stack() {
      Column() {
        Image($r('app.media.person_crop_circle_fill_1'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 60 })
          // .onClick(() => {
          //
          // })

        Text(this.username)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({ top: 10, bottom : 10 })
          //.backgroundColor(Color.White)
          .padding({
            left: 15,
            right: 15,
            top: 3,
            bottom: 3
          })
          .borderRadius(20)

      }
      .width('100%')
      .height('50%')
      .backgroundImage($r('app.media.background'))
      .backgroundImageSize({ height: '150%', width: '100%' })
      .backgroundBlurStyle(BlurStyle.Regular)

      Column({ space: 10 }) {
        Row() {
          this.menuItemBuilder($r('app.media.arrow_left'), '我发布的', () => {
            router.pushUrl({ url: 'pages/fragment/SellFragment' })
          })
          this.menuItemBuilder($r('app.media.arrow_left'), '我买到的', () => {
            router.pushUrl({ url: 'pages/fragment/BuyFragment' })
          })
          this.menuItemBuilder($r('app.media.arrow_left'), '上架商品', () => {
            router.pushUrl({ url: 'pages/fragment/PublishFragment' })
          })
        }
        .padding(10)
        .borderRadius(20)
        .backgroundColor(Color.White)
        .margin({bottom: 10})

        Column({ space: 10 }) {
          this.mineItemBuilder($r('app.media.arrow_up_circle'), '版本升级', () => {
            // 提示当前版本已是最新
            promptAction.showToast({
              message: '已经是最新版本',
              duration: 1000,
              bottom: '360vp'
            })
          })
          Divider()
          this.mineItemBuilder($r('app.media.lock'), '隐私政策', () => {
            // 展示隐私政策弹窗
            promptAction.showDialog({
              title: '隐私政策', //弹窗标题
              message: $r('app.string.privacy_content'), //弹窗内容
              buttons: [// 按钮的数组
                {
                  text: '确认',
                  color: '#4bb0c4'
                },
                {
                  text: '取消',
                  color: '#ffbab6b6'
                },
              ],
            })
              .then(data => {
                console.info('zhu click button: privacy_content');

              })
              .catch((err: Error) => {
                console.info('zhu showDialog error: privacy_content');
              })
          })
          Divider()
          this.mineItemBuilder($r('app.media.person_2_fill'), '关于我们', () => {
            // 展示关于我们信息
            promptAction.showDialog({
              title: '关于我们', //弹窗标题
              message: $r('app.string.about_content'), //弹窗内容
              buttons: [// 按钮的数组
                {
                  text: '确认',
                  color: '#4bb0c4'
                },
                {
                  text: '取消',
                  color: '#ffbab6b6'
                },
              ],
            })
              .then(data => {
                console.info('privacy_content');

              })
              .catch((err: Error) => {
                console.info('error: privacy_content');
              })
          })
          Divider()

          this.mineItemBuilder($r('app.media.xmark'), '退出登录', () => {
            PreferencesUtil.putPreferenceValue('user_name', "")
            PreferencesUtil.putPreferenceValue('token', "")
            router.replaceUrl({
              url: Path_Login
            })
          })
        }
        .padding(10)
        .borderRadius(20)
        .backgroundColor(Color.White)

        // Blank()
        // Button('退出登录')
        //   .width('100%')
        //   .fontSize(18)
        //   .backgroundColor('#FFE20D')
        //   .fontColor(Color.White)
        //   .onClick(() => {
        //     //router.back()
        //     PreferencesUtil.putPreferenceValue('user_name', "")
        //     PreferencesUtil.putPreferenceValue('token', "")
        //     // 使用 replaceUrl 确保退出后无法返回
        //     router.replaceUrl({
        //       url: Path_Login
        //     })
        //   })
      }
      .width('100%')
      .height('80%')
      .offset({ y: '30%' })
      .borderRadius({ topLeft: 32, topRight:32 })
      .backgroundColor('#fff1f1f1')
      .padding(16)

    }
    .width('100%')
    .height('100%')
    .padding({ bottom: 100 })
    .attributeModifier(o)
    .alignContent(Alignment.Top)
  }

  @Builder
  mineItemBuilder(icon: Resource, title: string, callback?: () => void) {
    Row({ space: 10 }) {
      Image(icon)
        .width(24)
        .height(24)
        .fillColor(Color.Black)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
      Blank()
      Image($r('app.media.arrow_right'))
        .width(24)
        .height(24)
        .fillColor(Color.Black)
    }.width('100%')
    .height(40)
    .onClick(() => {
      callback && callback();
    })
  }

  @Builder
  menuItemBuilder(icon: Resource, title: string, onClick?: () => void) {
    Column() {
      Image(icon)
        .width(40)
        .height(40)
        .fillColor(Color.Black)
      Text(title)
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 6 })
    }
    .onClick(() => {
      onClick && onClick()
    })
    .width('33%')
  }
}

