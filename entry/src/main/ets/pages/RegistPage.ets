// 导入页面路由模块
import router from '@ohos.router';
// 导入弹窗
import promptAction from '@ohos.promptAction';
import PreferencesUtil from './../util/PreferencesUtil';
import { http } from '@kit.NetworkKit';
import { GlobalVariable } from '../util/GlobalVariable';
import { BusinessError } from '@kit.BasicServicesKit';
import Toast from '../util/Toast';

export const Path_Regist = 'pages/RegistPage'

@Entry
@Component
struct RegistPage {
  @State userName: string = '123'; // 用户名
  @State password: string = '123'; // 密码
  @State password2: string = '123'; // 密码

  build() {
    Stack() {
      // 背景使用整幅图片覆盖页面
      Image($r("app.media.water_bg"))
        .objectFit(ImageFit.Cover)
        .width('100%')
        .height('100%')

      Column() {
        // 顶部返回按钮
        Row() {
          Image($r('app.media.back'))
            .width(30)
            .height(30)
            .borderRadius(10)
            .margin({ top: 40, left: 16 })
        }
        .margin({ top: 10 })
        .width('100%')
        .justifyContent(FlexAlign.Start)
        .onClick(() => {
          router.back()
        })

        Blank().layoutWeight(1)

        Image($r("app.media.logo"))
          .width('80vp')// 默认单位就是vp，可以简写为80
          .width(80)
          .margin({ bottom: '20vp', top: 40 })

        // 欢迎文字
        Text('用户注册')
          .fontSize('30fp')
          .fontColor(Color.White)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30 })

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入账号' })
          .inputStyle()// 公共样式函数
          .maxLength(11)
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.userName = data;
            console.info('user:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        TextInput({ placeholder: '请输入密码' })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password = data;
            console.info('password:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        TextInput({ placeholder: '请再次输入密码' })
          .type(InputType.Password)// 输入框类型
          .inputStyle()// 公共样式函数
          .onChange(data => { // 输入框的值发生变化时，触发回调，data代表输入的内容
            this.password2 = data;
            console.info('password:' + data)
          }).margin({ left: 20, right: 20, top: 10 })

        // 登录按钮
        Button('注册', { type: ButtonType.Capsule })
          .width('50%')
          .margin({ top: 20, left: 20, right: 20 })
          .backgroundColor('#ffdec515')
          .onClick(() => {
            this.loginBtnClick()
          })

        Blank().layoutWeight(1)
      }
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')

  }

  loginBtnClick() {
    // 判断用户名和密码非空
    if (this.userName == ''
      || this.password == ''
      || this.password2 == '') {
      // 不能跳转，同时提示
      promptAction.showToast({
        message: '账号、密码、再次密码不能为空不能为空',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }
    if (this.password != this.password2) {
      promptAction.showToast({
        message: '密码、再次密码必须相同',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }

    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/register', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json',
      },
      extraData:JSON.stringify({
        "username":this.userName,
        "password":this.password
      })

    },
      // 请求完成（不管成功还是失败）都调用的回调函数
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          // 如果err无值代表请求成功，打印响应体
          console.info('Result:' + JSON.stringify(data.result));

          if (JSON.parse(data.result.toString())["code"] != "0") {
            promptAction.showToast({
              message: JSON.parse(data.result.toString())["msg"],
              duration: 1000,
              bottom: '360vp'
            })
            return
          }
          promptAction.showToast({
            message: '注册成功',
            duration: 1000,
            bottom: '360vp'
          })

          // 注册完成后返回登录页
          router.back()
          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })
    // // 将用户账号与密码持久化到偏好存储
    // PreferencesUtil.putPreferenceValue('user_name', this.userName)
    // PreferencesUtil.putPreferenceValue('pwd', this.password)


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
