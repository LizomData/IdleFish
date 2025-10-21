// 导入页面路由模块
import router from '@ohos.router';
import { http } from '@kit.NetworkKit';
import promptAction from '@ohos.promptAction';
import { Path_Regist } from './RegistPage';
import PreferencesUtil from './../util/PreferencesUtil';
import { Path_Main } from './MainPage';
import { BusinessError } from '@kit.BasicServicesKit';
import Toast from '../util/Toast';
import { GlobalVariable } from '../util/GlobalVariable';

export const Path_Login = 'pages/LoginPage'

@Entry
@Component
struct Login {
  @State user: string = ''; // 用户名
  @State password: string = ''; // 密码

  build() {
    Stack() {
      Image($r("app.media.background"))
        .width('100%')
        .height('100%')
        .blur(50)
      Column() {
        // 欢迎文字
        Text('欢迎回来')
          .fontSize('40fp')
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: '40vp' })

        // logo
        Image($r("app.media.logo"))
          .width(100)
          .borderRadius(16)
          .margin({ bottom: '20vp' })

        // 用户名和密码输入框
        TextInput({ placeholder: '请输入账号' })
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
          .backgroundColor('#ff0d66ff')
          .onClick(() => {
            this.loginBtnClick();

          })

        Row() {
          Text('没有账号？注册')
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
    if (this.user == '' || this.password == '') {
      promptAction.showToast({
        message: '手机号或密码不能为空',
        duration: 1000,
        bottom: '360vp'
      })
      return
    }

console.log(JSON.stringify({
  "username":this.user,
  "password":this.password
}))
    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/login', {
      method:http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json' },
      // 参数
      extraData: JSON.stringify({
        "username":this.user,
        "password":this.password
      })
    },
      // 请求完成（不管成功还是失败）都调用的回调函数
      (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {
          // 如果err无值代表请求成功，打印响应体
          console.info('Result:' + JSON.stringify(data.result));

          if(JSON.parse(data.result.toString())["code"]!="0")
          {
            promptAction.showToast({
              message: JSON.parse(data.result.toString())["msg"],
              duration: 1000,
              bottom: '360vp'
            })
            return
          }

          Toast.show("登录成功:"+this.user);

          PreferencesUtil.putPreferenceValue('user_name', this.user)
          PreferencesUtil.putPreferenceValue('token', JSON.parse(data.result.toString())["data"]["token"])
          GlobalVariable.token=JSON.parse(data.result.toString())["data"]["token"]
          GlobalVariable.user_name=this.user


          // 销毁请求对象
          httpRequest.destroy()

          // 路由跳转
          router.replaceUrl({
            url: Path_Main
          }).catch((err: Error) => {
            // 错误提示
          })

          return;
        }
        console.error(err.message);
      Toast.show(err.message);


      })
    return;
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
    color: '#ff0d66ff',
    width: 1
  })
}
