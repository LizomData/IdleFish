import router from '@ohos.router';

@Entry
@Component
struct LoginPage {
  @State phone: string = '';
  @State password: string = '';

  build() {
    Column() {
      this.renderHeader()
      Scroll() {
        Column() {
          this.renderWelcome()
          this.renderForm()
          this.renderOtherOptions()
        }
        .padding({ left: 20, right: 20, top: 24, bottom: 40 })
        .backgroundColor('#F7F8FB')
      }
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F7F8FB')
  }

  @Builder
  private renderHeader() {
    Row() {
      Button('返回')
        .type(ButtonType.Normal)
        .height(32)
        .width(72)
        .borderRadius(16)
        .backgroundColor('#F0F2FF')
        .fontColor('#1F1F33')
        .onClick(() => {
          router.back();
        })

      Text('登录账号')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 12 })

      Blank()

      Button('帮助')
        .type(ButtonType.Normal)
        .height(32)
        .width(72)
        .borderRadius(16)
        .backgroundColor('#E7ECF5')
        .fontColor('#1F1F33')
    }
    .padding({ left: 20, right: 20, top: 20, bottom: 12 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  private renderWelcome() {
    Column() {
      Text('打造你的质感交易空间')
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
      Text('登录即可同步收藏、订单与消息通知')
        .fontSize(13)
        .opacity(0.6)
        .margin({ top: 8 })
    }
    .margin({ top: 32 })
  }

  @Builder
  private renderForm() {
    Column() {
      Column() {
        Column() {
          Text('手机号码')
            .fontSize(14)
            .opacity(0.7)
          TextInput({ text: this.phone, placeholder: '请输入手机号' })
            .height(48)
            .backgroundColor('#F2F3F8')
            .borderRadius(16)
            .padding({ left: 16, right: 16 })
            .margin({ top: 10 })
            .onChange((value: string) => {
              this.phone = value;
            })

          Text('登录密码')
            .fontSize(14)
            .opacity(0.7)
            .margin({ top: 20 })
          TextInput({ text: this.password, placeholder: '请输入密码' })
            .height(48)
            .backgroundColor('#F2F3F8')
            .borderRadius(16)
            .padding({ left: 16, right: 16 })
            .margin({ top: 10 })
            .onChange((value: string) => {
              this.password = value;
            })

          Row() {
            Text('忘记密码')
              .fontSize(12)
              .opacity(0.6)
            Blank()
            Text('短信验证码登录')
              .fontSize(12)
              .fontColor('#1F1F33')
          }
          .margin({ top: 16 })
        }
        .padding({ left: 20, right: 20, top: 24, bottom: 24 })
        .backgroundColor('#FFFFFF')
        .borderRadius(24)
      }

      Column() {
        Button('立即登录')
          .type(ButtonType.Normal)
          .height(50)
          .width('100%')
          .borderRadius(25)
          .backgroundColor('#1F1F33')
          .fontColor('#FFFFFF')
          .onClick(() => {
            router.replaceUrl({ url: 'pages/Personal' });
          })

        Button('注册新账号')
          .type(ButtonType.Normal)
          .height(50)
          .width('100%')
          .borderRadius(25)
          .backgroundColor('#F0F2FF')
          .fontColor('#1F1F33')
          .margin({ top: 12 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Personal' });
          })
      }
      .margin({ top: 26 })
    }
    .margin({ top: 36 })
  }

  @Builder
  private renderOtherOptions() {
    Column() {
      Text('其他登录方式')
        .fontSize(12)
        .opacity(0.5)
        .margin({ top: 24 })

      Row() {
        Button('支付宝')
          .type(ButtonType.Normal)
          .height(44)
          .width(110)
          .borderRadius(22)
          .backgroundColor('#F0F2FF')
          .fontColor('#1F1F33')

        Button('微信')
          .type(ButtonType.Normal)
          .height(44)
          .width(110)
          .borderRadius(22)
          .backgroundColor('#E1F7F0')
          .fontColor('#1F1F33')
          .margin({ left: 16 })

        Button('游客体验')
          .type(ButtonType.Normal)
          .height(44)
          .width(110)
          .borderRadius(22)
          .backgroundColor('#FFF1EC')
          .fontColor('#1F1F33')
          .margin({ left: 16 })
      }

      Text('登录即表示同意《用户协议》《隐私政策》')
        .fontSize(10)
        .opacity(0.5)
        .margin({ top: 26 })
    }
  }
}
