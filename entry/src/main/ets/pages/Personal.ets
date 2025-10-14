import router from '@ohos.router';

interface PersonalStat {
  label: string;
  value: string;
}

interface PersonalService {
  title: string;
  subtitle: string;
}

@Entry
@Component
struct PersonalPage {
  private stats: PersonalStat[] = [
    { label: '关注', value: '128' },
    { label: '粉丝', value: '560' },
    { label: '信用', value: '良好' }
  ];

  private orders: PersonalStat[] = [
    { label: '待付款', value: '2' },
    { label: '待发货', value: '1' },
    { label: '待收货', value: '0' },
    { label: '退款/售后', value: '0' }
  ];

  private services: PersonalService[] = [
    { title: '闲鱼币', subtitle: '签到领福利' },
    { title: '鱼塘', subtitle: '加入同城兴趣圈' },
    { title: '我的钱包', subtitle: '查看账单与余额' },
    { title: '寄卖服务', subtitle: '专业验货包邮寄' }
  ];

  build() {
    Column() {
      this.renderHeader()
      Scroll() {
        Column() {
          this.renderProfileCard()
          this.renderOrderSection()
          this.renderServiceGrid()
          this.renderHelpCenter()
        }
        .padding({ left: 20, right: 20, top: 16, bottom: 32 })
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

      Text('个人主页')
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .margin({ left: 12 })

      Blank()

      Button('设置')
        .type(ButtonType.Normal)
        .height(32)
        .width(72)
        .borderRadius(16)
        .backgroundColor('#E7ECF5')
        .fontColor('#1F1F33')
    }
    .padding({ left: 20, right: 20, top: 24, bottom: 14 })
    .backgroundColor('#FFFFFF')
  }

  @Builder
  private renderProfileCard() {
    Column() {
      Row() {
        Image($r('app.media.background'))
          .width(76)
          .height(76)
          .borderRadius(38)
          .backgroundColor('#2B3070')

        Column() {
          Text('SERENE STUDIO')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor('#FFFFFF')
          Text('设计美学玩家 · 芝麻信用 720')
            .fontSize(12)
            .fontColor('#D2D5FF')
            .margin({ top: 6 })

          Row() {
            ForEach(this.stats, (item: PersonalStat) => {
              Column() {
                Text(item.value)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .fontColor('#FFFFFF')
                Text(item.label)
                  .fontSize(12)
                  .fontColor('#C6C9FF')
                  .margin({ top: 4 })
              }
              .alignItems(HorizontalAlign.Center)
              .margin({ right: 18 })
            }, (item: PersonalStat) => item.label)
          }
          .margin({ top: 14 })
        }
        .margin({ left: 18 })
      }

      Row() {
        Button('编辑资料')
          .type(ButtonType.Normal)
          .height(38)
          .width(120)
          .borderRadius(19)
          .backgroundColor('#FFFFFF')
          .fontColor('#1F1F33')
        Button('切换账号')
          .type(ButtonType.Normal)
          .height(38)
          .width(140)
          .borderRadius(19)
          .backgroundColor('#FF8A65')
          .fontColor('#1F1F33')
          .margin({ left: 12 })
          .onClick(() => {
            router.pushUrl({ url: 'pages/Login' });
          })
      }
      .margin({ top: 24 })
    }
    .padding({ left: 24, right: 24, top: 28, bottom: 28 })
    .backgroundColor('#1F1F33')
    .borderRadius(28)
  }

  @Builder
  private renderOrderSection() {
    Column() {
      Row() {
        Text('我的订单')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('全部订单 >')
          .fontSize(12)
          .opacity(0.6)
      }

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.orders, (item: PersonalStat) => {
          Column() {
            Text(item.label)
              .fontSize(13)
              .opacity(0.7)
            Text(item.value)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 8 })
          }
          .width('48%')
          .padding({ left: 18, right: 18, top: 20, bottom: 20 })
          .backgroundColor('#F5F6FF')
          .borderRadius(20)
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })
        }, (item: PersonalStat) => item.label)
      }
      .margin({ top: 20 })
    }
    .padding({ left: 24, right: 24, top: 26, bottom: 26 })
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .margin({ top: 20 })
  }

  @Builder
  private renderServiceGrid() {
    Column() {
      Text('常用服务')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      Column() {
        ForEach(this.services, (item: PersonalService) => {
          Row() {
            Column() {
              Text(item.title)
                .fontSize(16)
                .fontWeight(FontWeight.Medium)
              Text(item.subtitle)
                .fontSize(12)
                .opacity(0.6)
                .margin({ top: 4 })
            }
            .alignItems(HorizontalAlign.Start)

            Blank()

            Button('进入')
              .type(ButtonType.Normal)
              .height(34)
              .width(72)
              .borderRadius(17)
              .backgroundColor('#1F1F33')
              .fontColor('#FFFFFF')
          }
          .padding({ left: 18, right: 18, top: 18, bottom: 18 })
          .backgroundColor('#F8F9FF')
          .borderRadius(20)
          .margin({ top: 14 })
        }, (item: PersonalService) => item.title)
      }
      .margin({ top: 16 })
    }
    .padding({ left: 24, right: 24, top: 26, bottom: 26 })
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .margin({ top: 20 })
  }

  @Builder
  private renderHelpCenter() {
    Column() {
      Text('帮助与客服')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)

      Column() {
        Row() {
          Column() {
            Text('客服小助手')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
            Text('7×24 小时在线答疑')
              .fontSize(12)
              .opacity(0.6)
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          Blank()
          Button('联系')
            .type(ButtonType.Normal)
            .height(34)
            .width(72)
            .borderRadius(17)
            .backgroundColor('#FF8A65')
            .fontColor('#1F1F33')
        }
        .padding({ left: 18, right: 18, top: 18, bottom: 18 })
        .backgroundColor('#FFF4EE')
        .borderRadius(20)

        Row() {
          Column() {
            Text('安全与合规中心')
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
            Text('账号、交易与隐私管理')
              .fontSize(12)
              .opacity(0.6)
              .margin({ top: 2 })
          }
          .alignItems(HorizontalAlign.Start)
          Blank()
          Button('查看')
            .type(ButtonType.Normal)
            .height(34)
            .width(72)
            .borderRadius(17)
            .backgroundColor('#1F1F33')
            .fontColor('#FFFFFF')
        }
        .padding({ left: 18, right: 18, top: 18, bottom: 18 })
        .backgroundColor('#F2F4FF')
        .borderRadius(20)
        .margin({ top: 16 })
      }
      .margin({ top: 18 })
    }
    .padding({ left: 24, right: 24, top: 26, bottom: 32 })
    .backgroundColor('#FFFFFF')
    .borderRadius(24)
    .margin({ top: 20, bottom: 40 })
  }
}
