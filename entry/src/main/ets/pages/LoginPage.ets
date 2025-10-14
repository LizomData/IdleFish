// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';
import { preferences } from '@kit.ArkData';
import { Path_Regist } from './RegistPage';
import PreferencesUtil from './../util/PreferencesUtil';
import { Path_Main } from './MainPage';

export const Path_Login = 'pages/LoginPage'

@Entry
@Component
struct Login {
  @State user: string = '123'; // 用户名
  @State password: string = '123'; // 密码

  build() {
    Stack() {
      Image($r("app.media.water_bg"))
        .width('100%')
        .height('100%')
      Column() {
        // 欢迎文字
        Text('用户登陆')
          .fontSize('30fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: '40vp' })

        // logo
        Image($r("app.media.logo"))
          .width(100)
          .borderRadius(10)
          .margin({ bottom: '20vp' })

        // 欢迎文字
        /*Text('账号登录')
          .fontSize('30fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)*/

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入手机号' })
          .inputStyle()// 公共样式函数
          .maxLength(11)
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.user = data;
            console.info('user:' + data)
          })
          .margin({ left: 20, right: 20, top: 10 })

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password = data;
            console.info('password:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        // 文字提示
        Row() {
          // Text('短信验证码登录')
          //   .fontSize('16fp')
          //   .fontColor(Color.Blue)
          // Text('忘记密码')
          //   .fontSize('16fp')
          //   .fontColor(Color.White)
          //   .margin({ right: 30, top: 10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.End)

        // 登录按钮
        Button('登录', { type: ButtonType.Capsule })
          .width('50%')
          .margin({ top: 20 })
          .backgroundColor('#ffdec515')
          .onClick(() => {
            this.loginBtnClick()
          })

        Row() {
          Text('注册')
            .fontSize('16fp')
            .fontWeight(FontWeight.Medium)
            .fontColor('#ffffff')
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 15 })
        .onClick(() => {
          this.registBtnClick()
        })

        ////-其他
        Row() {
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor($r('app.color.tint_gray'))
            .margin({ left: 10, right: 10 })
          Text('其他登录方式')
            .fontSize('16fp')
            .fontColor(Color.White)
          Blank().height(0.5).layoutWeight(1)
            .backgroundColor($r('app.color.tint_gray'))
            .margin({ left: 10, right: 10 })
        }
        .width('100%')
        .justifyContent(FlexAlign.Center)
        .margin({ top: 40 })

        /////三个按钮
        Row() {
          // ForEach(this.otherData, (item: string) => {
          //   Button(item, { type: ButtonType.Circle })
          //     .circleBtnStyle()
          // }, (item: string) => JSON.stringify(item))
          Row() {
            Image($r('app.media.huawei')).width(40).height(40).borderRadius(10)
            Text('华为账号').fontColor('#ffffff').margin({ left: 6 })
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)

          Row() {
            Image($r('app.media.weixin')).width(40).height(40).borderRadius(10)
            Text('微信').fontColor('#ffffff').margin({ left: 6 })
          }.layoutWeight(1).alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .margin('20vp')
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
  }

  async loginBtnClick() {
    // 判断用户名和密码非空
    if (this.user == '' || this.password == '') {
      // 不能跳转，同时提示
      promptAction.showToast({
        message: '手机号或密码不能为空',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    // 从偏好存储中获取注册时保存的用户名
    let v: preferences.ValueType = await PreferencesUtil.getPreferenceValue('user_name', '')
    if (v == '') {
      promptAction.showToast({
        message: '您还未注册',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    if (v != this.user) {
      promptAction.showToast({
        message: '手机号不正确',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    // 校验密码是否与注册信息一致
    let v2: preferences.ValueType = await PreferencesUtil.getPreferenceValue('pwd', '')
    if (v2 != this.password) {
      promptAction.showToast({
        message: '密码不正确',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    promptAction.showToast({
      message: '登录成功',
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

  registBtnClick() {
    // 进入注册页面，供未注册用户使用
    router.pushUrl({
      url: Path_Regist
    }).catch((err: Error) => {
      // 错误提示
    })
  }
}

// 添加公共的样式函数
// @Extend装饰器：扩展组件样式
// @Extend(组件描述名称) function 样式名称
// 输入框公共样式函数
@Extend(TextInput)
function inputStyle() {
  // .placeholderColor(Color.White)
  .placeholderColor('#ffffff')
  .backgroundColor('#75ffffff')
  .maxLength(6)
  //.padding('12vp')
  .padding({
    left: 12,
    right: 12,
    top: 8,
    bottom: 8
  })
  .margin('10vp')
  .border({
    color: '#FFE20D',
    width: 1
  })
}

// 原型按钮公共样式函数
@Extend(Button)
function circleBtnStyle() {
  .width('60vp')
  .height('60vp')
}
