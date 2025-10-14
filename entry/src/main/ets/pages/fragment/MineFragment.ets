// 个人中心页面依赖的路由与弹窗能力
import router from '@ohos.router';
import { o } from "hytech"
import promptAction from '@ohos.promptAction';
import { Path_Login } from '../LoginPage';

@Preview
@Entry
@Component
export struct MineFragment {
  async aboutToAppear() {

  }

  build() {
    // 使用 Stack 构建顶部背景和底部内容卡片
    Stack() {
      Column() {
        // 用户头像与昵称区域
        Image($r('app.media.meinv0'))
          .width(100)
          .height(100)
          .borderRadius(50)
          .margin({ top: 100 })
          .onClick(() => {

          })

        Text('@祖师爷科技')
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.Black)
          .margin({ top: 20, bottom : 10 })
          .backgroundColor(Color.White)
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
      .backgroundImage($r('app.media.water_bg'))
      .backgroundImageSize({ height: '150%', width: '100%' })

      //.backgroundBlurStyle(BlurStyle.Regular)

      Column({ space: 10 }) {
        this.mineItemBuilder($r('app.media.huizhang'), '我的老师', () => {
          // router.pushUrl({
          //   url: Path_Collection
          // })
          // 展示功能待开放的提示
          promptAction.showToast({
            message: '已经是最新老师',
            duration: 1000,
            bottom: '360vp'
          })
        })
        Divider()
        this.mineItemBuilder($r('app.media.jihua'), '版本升级', () => {
          // 提示当前版本已是最新
          promptAction.showToast({
            message: '已经是最新版本',
            duration: 1000,
            bottom: '360vp'
          })
        })
        Divider()
        this.mineItemBuilder($r('app.media.yinsi'), '隐私政策', () => {
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
        this.mineItemBuilder($r('app.media.guanyu'), '关于我们', () => {
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
              console.info('zhu click button: privacy_content');

            })
            .catch((err: Error) => {
              console.info('zhu showDialog error: privacy_content');
            })
        })

        Blank()
        Button('退出登录')
          .width('100%')
          .fontSize(18)
          .backgroundColor('#FFE20D')
          .fontColor(Color.White)
          .onClick(() => {
            //router.back()
            // 使用 replaceUrl 确保退出后无法返回
            router.replaceUrl({
              url: Path_Login
            })
          })
      }
      .width('100%')
      .height('60%')
      .offset({ y: '40%' })
      .borderRadius({ topLeft: 50, topRight: 50 })
      .backgroundColor(Color.White)
      .padding(30)

    }
    .width('100%')
    .height('100%')
    .padding({ bottom: 100 })
    .attributeModifier(o)
    .alignContent(Alignment.Top)
  }

  @Builder
  mineItemBuilder(icon: Resource, title: string, callback?: () => void) {
    // 列表项通用布局，包含图标、标题和箭头
    Row({ space: 10 }) {
      Image(icon)
        .width(24)
        .height(24)
      Text(title)
        .fontSize(16)
        .height(24)
        .fontWeight(FontWeight.Medium)
      Blank()
      Image($r('app.media.ic_arrow_right'))
        .width(24)
        .height(24)
    }.width('100%')
    .height(40)
    .onClick(() => {
      // 有回调则执行对应逻辑
      callback && callback();
    })
  }
}
