import router from '@ohos.router';

interface HotItem {
  title: string;
  price: string;
  distance: string;
  tag?: string;
}

interface ShortcutItem {
  label: string;
  caption: string;
  accent: string;
}

interface InspirationCard {
  title: string;
  description: string;
  accent: string;
  textColor: string;
}

@Entry
@Component
struct Index {
  @State searchValue: string = '';
  private shortcuts: ShortcutItem[] = [
    { label: '今日特惠', caption: '限时秒杀·精选', accent: '#EDF3FF' },
    { label: '设计好物', caption: '家具 · 艺术', accent: '#FFF3E8' },
    { label: '科技焕新', caption: '手机 · 数码', accent: '#EAF8F2' },
    { label: '户外生活', caption: '滑板 · 露营', accent: '#F4EBFF' }
  ];
  private highlightChips: string[] = ['可预约验货', '同城极速达', '包邮精选', '官方质检', '超高颜值家居'];
  private inspirationCards: InspirationCard[] = [
    {
      title: '北欧原木风客厅',
      description: '用二手设计点亮居家氛围',
      accent: '#1F1F33',
      textColor: '#FFFFFF'
    },
    {
      title: '创作者私藏器物',
      description: '手工、古着与限量收藏',
      accent: '#F7F0E5',
      textColor: '#1F1F33'
    }
  ];
  private hotItems: HotItem[] = [
    {
      title: '戴森 V12 Detect Slim 无线吸尘器',
      price: '￥3,080',
      distance: '距您 1.5km · 24 小时内上新',
      tag: '含发票'
    },
    {
      title: 'iPad Pro 11 英寸 512G + 二代笔',
      price: '￥5,650',
      distance: '距您 3.2km · 个人自用',
      tag: '成色 9.5'
    },
    {
      title: '宜家 LISABO 实木书桌 + 收纳套装',
      price: '￥680',
      distance: '距您 0.9km · 含送货安装'
    }
  ];

  build() {
    Column() {
      Scroll() {
        Column() {
          this.renderHeader()
          this.renderHeroSection()
          this.renderShortcutRow()
          this.renderHighlights()
          this.renderHotList()
          this.renderInspirationSection()
          this.renderPublishCard()
        }
        .width('100%')
        .padding({ left: 20, right: 20, top: 12, bottom: 24 })
        .backgroundColor('#F7F8FB')
      }
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      this.renderBottomNav()
    }
    .backgroundColor('#F7F8FB')
    .height('100%')
    .width('100%')
  }

  @Builder
  private renderHeader() {
    Row() {
      Column() {
        Text('Hi，欢迎回来')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
        Text('上海 · 静安区 · 质感生活圈')
          .fontSize(12)
          .opacity(0.6)
          .margin({ top: 6 })
      }
      .alignItems(HorizontalAlign.Start)

      Blank()

      Button('个人中心')
        .type(ButtonType.Normal)
        .height(34)
        .width(104)
        .borderRadius(18)
        .backgroundColor('#1F1F33')
        .fontColor('#FFFFFF')
        .onClick(() => {
          router.pushUrl({ url: 'pages/Personal' });
        })
    }
    .width('100%')
    .alignItems(VerticalAlign.Center)
    .padding({ left: 20, right: 20, top: 4 })
  }

  @Builder
  private renderHeroSection() {
    Column() {
      Column() {
        Text('发现下一件心动好物')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)
          .fontColor('#FFFFFF')
        Text('精选改造、智能焕新与设计师器物')
          .fontSize(13)
          .fontColor('#C6CBFF')
          .margin({ top: 6 })

        Row() {
          TextInput({ text: this.searchValue, placeholder: '搜索家具、数码、潮流精选' })
            .onChange((value: string) => {
              this.searchValue = value;
            })
            .height(44)
            .backgroundColor('#383D7A')
            .borderRadius(22)
            .padding({ left: 16, right: 16 })
            .fontColor('#FFFFFF')
            .layoutWeight(1)

          Button('探索')
            .type(ButtonType.Normal)
            .height(44)
            .width(96)
            .borderRadius(22)
            .backgroundColor('#FF8A65')
            .fontColor('#1F1F33')
            .margin({ left: 12 })
            .onClick(() => {
              router.pushUrl({ url: 'pages/Login' });
            })
        }
        .margin({ top: 20 })

        Row() {
          Text('极速验货')
            .fontSize(11)
            .fontColor('#FFFFFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#3C4188')
            .borderRadius(14)
          Text('上门取件')
            .fontSize(11)
            .fontColor('#FFFFFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#3C4188')
            .borderRadius(14)
            .margin({ left: 10 })
          Text('售后护航')
            .fontSize(11)
            .fontColor('#FFFFFF')
            .padding({ left: 12, right: 12, top: 6, bottom: 6 })
            .backgroundColor('#3C4188')
            .borderRadius(14)
            .margin({ left: 10 })
        }
        .margin({ top: 18 })
      }
      .padding({ left: 20, right: 20, top: 28, bottom: 28 })
      .backgroundColor('#2B3070')
      .borderRadius(28)

      Row() {
        Column() {
          Text('本周精选专辑')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
          Text('来自独立设计师的 18 件灵感单品')
            .fontSize(12)
            .opacity(0.6)
            .margin({ top: 4 })
        }

        Blank()

        Button('查看专辑')
          .type(ButtonType.Normal)
          .height(34)
          .width(110)
          .backgroundColor('#FFFFFF')
          .fontColor('#1F1F33')
          .onClick(() => {
            router.pushUrl({ url: 'pages/Personal' });
          })
      }
      .margin({ top: 20 })
    }
    .margin({ top: 20 })
  }

  @Builder
  private renderShortcutRow() {
    Column() {
      Row() {
        Text('灵感捷径')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('全部入口')
          .fontSize(12)
          .opacity(0.6)
      }
      .alignItems(VerticalAlign.Center)
      .margin({ top: 26 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.shortcuts, (item: ShortcutItem) => {
          Column() {
            Text(item.label)
              .fontSize(15)
              .fontWeight(FontWeight.Medium)
            Text(item.caption)
              .fontSize(11)
              .opacity(0.65)
              .margin({ top: 6 })
          }
          .width('48%')
          .padding({ left: 16, right: 16, top: 20, bottom: 20 })
          .backgroundColor(item.accent)
          .borderRadius(20)
          .alignItems(HorizontalAlign.Start)
          .margin({ bottom: 12 })
        }, (item: ShortcutItem) => item.label)
      }
      .margin({ top: 16 })
    }
  }

  @Builder
  private renderHighlights() {
    Column() {
      Text('精选标签')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 26 })

      Flex({ wrap: FlexWrap.Wrap }) {
        ForEach(this.highlightChips, (label: string) => {
          Text(label)
            .padding({ left: 16, right: 16, top: 10, bottom: 10 })
            .backgroundColor('#FFFFFF')
            .borderRadius(18)
            .fontSize(12)
            .margin({ right: 12, bottom: 12 })
        }, (label: string) => label)
      }
      .margin({ top: 14 })
    }
  }

  @Builder
  private renderHotList() {
    Column() {
      Row() {
        Text('热门好物')
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
        Blank()
        Text('更多 >')
          .fontSize(12)
          .opacity(0.6)
      }
      .alignItems(VerticalAlign.Center)
      .margin({ top: 24 })

      Column() {
        ForEach(this.hotItems, (item: HotItem) => {
          Row() {
            Image($r('app.media.background'))
              .width(96)
              .height(96)
              .borderRadius(16)
              .backgroundColor('#FFFFFF')

            Column() {
              Row() {
                Text(item.title)
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
                if (item.tag !== undefined) {
                  Text(item.tag!)
                    .fontSize(12)
                    .fontColor('#FF6E4A')
                    .backgroundColor('#FFF1EC')
                    .borderRadius(12)
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .margin({ left: 12 })
                }
              }
              .alignItems(VerticalAlign.Center)

              Text(item.distance)
                .fontSize(12)
                .opacity(0.6)
                .margin({ top: 6 })

              Text(item.price)
                .fontSize(18)
                .fontWeight(FontWeight.Bold)
                .fontColor('#3347FF')
                .margin({ top: 8 })
              Button('联系卖家')
                .type(ButtonType.Normal)
                .height(36)
                .width(96)
                .borderRadius(18)
                .backgroundColor('#1F1F33')
                .fontColor('#FFFFFF')
                .margin({ top: 10 })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/Login' });
                })
            }
            .margin({ left: 16 })
            .alignItems(HorizontalAlign.Start)
          }
          .padding({ left: 16, right: 16, top: 16, bottom: 16 })
          .margin({ top: 16 })
          .backgroundColor('#FFFFFF')
          .borderRadius(20)
        }, (item: HotItem) => item.title)
      }
    }
  }

  @Builder
  private renderInspirationSection() {
    Column() {
      Text('主题灵感集')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 28 })

      Column() {
        ForEach(this.inspirationCards, (card: InspirationCard) => {
          Column() {
            Text(card.title)
              .fontSize(18)
              .fontWeight(FontWeight.Bold)
              .fontColor(card.textColor)
            Text(card.description)
              .fontSize(12)
              .opacity(0.7)
              .fontColor(card.textColor)
              .margin({ top: 8 })

            Button('打开灵感集')
              .type(ButtonType.Normal)
              .height(40)
              .width(140)
              .borderRadius(20)
              .backgroundColor('#FFFFFF')
              .fontColor('#1F1F33')
              .margin({ top: 18 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/Login' });
              })
          }
          .padding({ left: 20, right: 20, top: 28, bottom: 28 })
          .backgroundColor(card.accent)
          .borderRadius(24)
          .margin({ top: 16 })
        }, (card: InspirationCard) => card.title)
      }
    }
  }

  @Builder
  private renderPublishCard() {
    Column() {
      Text('极速发布闲置')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 28 })

      Row() {
        Column() {
          Text('AI 智能估价，30 秒完成发布流程')
            .fontSize(12)
            .opacity(0.75)
            .fontColor('#FFFFFF')
          Text('同步推送到三大买家圈，曝光更高')
            .fontSize(12)
            .opacity(0.6)
            .fontColor('#FFFFFF')
            .margin({ top: 6 })

          Row() {
            Button('立即发布')
              .type(ButtonType.Normal)
              .height(44)
              .width(132)
              .borderRadius(22)
              .backgroundColor('#FFFFFF')
              .fontColor('#1F1F33')
              .onClick(() => {
                router.pushUrl({ url: 'pages/Login' });
              })
            Button('估算价格')
              .type(ButtonType.Normal)
              .height(44)
              .width(132)
              .borderRadius(22)
              .backgroundColor('#1F1F33')
              .fontColor('#FFFFFF')
              .margin({ left: 12 })
              .onClick(() => {
                router.pushUrl({ url: 'pages/Login' });
              })
          }
          .margin({ top: 18 })
        }
        .alignItems(HorizontalAlign.Start)

        Blank()

        Image($r('app.media.foreground'))
          .width(96)
          .height(96)
          .borderRadius(28)
          .backgroundColor('#242448')
      }
      .padding({ left: 24, right: 24, top: 26, bottom: 26 })
      .margin({ top: 18 })
      .backgroundColor('#2B3070')
      .borderRadius(28)
    }
  }

  @Builder
  private renderBottomNav() {
    Row() {
      Column() {
        Image($r('app.media.background'))
          .width(26)
          .height(26)
        Text('首页')
          .fontSize(12)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Center)
      .onClick(() => {})

      Column() {
        Image($r('app.media.background'))
          .width(26)
          .height(26)
        Text('分类')
          .fontSize(12)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 30 })

      Button('+发布')
        .type(ButtonType.Normal)
        .height(46)
        .width(110)
        .borderRadius(23)
        .backgroundColor('#FF6E4A')
        .fontColor('#FFFFFF')
        .margin({ left: 30 })
        .onClick(() => {
          router.pushUrl({ url: 'pages/Login' });
        })

      Column() {
        Image($r('app.media.background'))
          .width(26)
          .height(26)
        Text('消息')
          .fontSize(12)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 30 })

      Column() {
        Image($r('app.media.background'))
          .width(26)
          .height(26)
        Text('我的')
          .fontSize(12)
          .margin({ top: 4 })
      }
      .alignItems(HorizontalAlign.Center)
      .margin({ left: 30 })
      .onClick(() => {
        router.pushUrl({ url: 'pages/Personal' });
      })
    }
    .padding({ left: 24, right: 24, top: 12, bottom: 12 })
    .backgroundColor('#FFFFFF')
    .borderRadius(28)
    .margin({ left: 20, right: 20, bottom: 24, top: 12 })
  }
}
