// 详情页所需的路由、弹窗及数据工具
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { JSON } from '@kit.ArkTS';
import { m as saveData } from 'ohbuild';
import DbUtil from '../util/DbUtil';
import Food, { RouteParam } from '../model/modle';
import MyData from '../model/MyData';
import { preferences } from '@kit.ArkData';
import PreferenceUtil from '../util/PreferencesUtil';

export const Path_Detail = 'pages/DetailPage'

@Entry
@Component
struct ProductDetailPage {
  // 当前展示的商品信息，默认取内置数据以避免空对象
  food: Food = MyData.homeListData[0]
  // 当前登录用户 ID
  @State user_id: preferences.ValueType = ''

  async aboutToAppear() {
    console.log(JSON.stringify(router.getParams()))
    // 获取路由参数并初始化页面数据
    const routeParam = router.getParams() as RouteParam
    this.food = routeParam.content as Food

    // 读取当前登录用户，用于判断按钮显示与否
    this.user_id = await PreferenceUtil.getPreferenceValue('user_name', '')
  }

  addCart() {
    // 购买后提示，并将当前用户设置为持有者
    promptAction.showToast({
      message: '购买成功！'
    })
    this.food.own_u_id = this.user_id.toString()
    DbUtil.updateFood(this.food)
    router.back()
  }

  getV() {
    let a = this.food.publish_u_id == this.user_id
    let b = this.food.own_u_id == this.user_id
    let c = (a || b)
    // 若当前用户已拥有或发布该商品则隐藏购买按钮
    return c ? Visibility.Hidden : Visibility.Visible
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back')).width(20).height(25)
          .margin({
            left: 16
          })
          .onClick(() => {
            // 返回上一页
            router.back()
          })
        Text('宝贝详情')
          .fontColor(Color.Black)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 110 })
      }
      .width('100%')
      //.height(50)
      .padding({ top: 50, bottom: 15 })
      //.justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)

      Scroll() {
        Column() {
          //图片轮播
          Row() {
            Stack() {
              // 主图区域，展示商品大图
              Image(this.food.icon_url)
                .width('90%')
                .height(300).borderRadius(10)
              Row() {
                // 右下角标识区域，可扩展为轮播指示器
                Text('0000321')
                  .backgroundColor('#797B7A')
                  .borderRadius(16)
                  .padding({
                    left: 10,
                    right: 10,
                    top: 5,
                    bottom: 5
                  })
                  .fontSize(12)
                  .fontColor(Color.White)
                  .fontWeight(600)
                // Text(this.productList.length.toString())
                Text('3')
                  .margin({ right: 8, left: 10 })
                  .fontSize(12)
                  .fontColor(Color.White)
                  .fontWeight(600)
              }
              .backgroundColor('#98999B')
              .borderRadius(16)
              .margin({ right: 10 })

            }
            .alignContent(Alignment.BottomEnd)
          }
          .margin({ top: 20, bottom: 10 })
          .alignItems(VerticalAlign.Bottom)

          //内容区域
          Column() {
            Row() {
              Column({ space: 5 }) {


                Text('现价￥' + (this.food.now_price).toString())
                  .fontSize(20).fontWeight(FontWeight.Bold)
                  .fontColor(Color.Black)

              }
              .padding({ left: 10 })
              .justifyContent(FlexAlign.Center)
              .alignItems(HorizontalAlign.Start)
              .height(60)
              .borderRadius({ topLeft: 16, topRight: 30, bottomRight: 30 })
              .width('66%')
              .linearGradient({
                direction: GradientDirection.Right,
                repeating: false,
                colors: [['#80ffe20d', 0.0], ['#ffffe20d', 1.0]]
              })

              Column({ space: 3 }) {
                Image($r('app.media.productDetal_year'))
                  .height(20)
                Text('买贵双倍赔｜包邮')
                  .fontSize(11)
                  .fontColor('#846030')
                  .borderRadius(4)
                  .backgroundColor(Color.White)
                  .fontWeight(500)
                  .padding(3)
              }
              .margin({ right: 10, top: 5 })
              .height(60)
              .justifyContent(FlexAlign.Start)

            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

            Column() {
              Column() {
                Row() {
                  // 商品标签切换示例
                  Toggle({ type: ToggleType.Button, isOn: true }) {
                    Text('靓丽时尚')
                      .fontSize(12)
                      .fontColor('#DA5A4D')
                      .fontWeight(500)
                      .padding({ left: 4, right: 4 })
                  }
                  .selectedColor('#FDEBE7')
                  .border({ width: 1, color: '#E69B99' })
                  .margin({ left: 10, right: 10 })
                  .onChange((isOn: boolean) => {
                    if (isOn) {
                      // this.isSelect = !this.isSelect;
                    }
                  })

                  Toggle({ type: ToggleType.Button, isOn: false }) {
                    Text('青春活力')
                      .fontSize(12)
                      .fontColor('#DA5A4D')
                      .fontWeight(500)
                      .padding({ left: 4, right: 4 })
                  }
                  .selectedColor('#FDEBE7')
                  .border({ width: 1, color: '#E69B99' })

                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .padding({ top: 10, bottom: 10 })

              }
              .backgroundColor(Color.White)
              .width('100%')
              .borderRadius(16)

            }
            .borderRadius({ topLeft: 16, topRight: 16 })
            .backgroundColor('#F2F2F2')

          }
          .backgroundColor('#fff5ea90')
          .width('90%')
          .borderRadius({ topLeft: 16, topRight: 16 })

          Column() {
            Text(this.food.name)
              .fontSize(20)
              .fontWeight(FontWeight.Bold)

            Text(this.food.name)
              .fontSize(14)
              .fontWeight(FontWeight.Normal)
              .margin({ top: 10 })
              .lineHeight(18)
          }
          .layoutWeight(1)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .width('90%')
          .margin({ top: 10, bottom: 20 })
          .justifyContent(FlexAlign.Start)
          .alignItems(HorizontalAlign.Start)
          .padding(16)
        }
        .width('100%')
        .backgroundColor($r('app.color.gray_bg'))
        .height('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Row() {

        Text('注意：自己发布的宝贝和自己买到的宝贝，不能再次“我想要”') {
        }
        .fontColor(Color.Gray)
        .fontSize(12).width('55%')
        //.margin({left:16,right:16})

        Blank().layoutWeight(1)

        Column() {
          Text('我想要')
            .fontColor(Color.Black)
            .fontSize(18)
            .fontWeight(600)
        }
        .backgroundColor($r('app.color.zhuti'))
        .padding({
          left: 30,
          right: 30,
          top: 10,
          bottom: 10
        })
        .borderRadius(30)
        .onClick(() => {
          // 点击立即购买
          this.addCart()
        })
        .visibility(this.getV())
      }
      .width('100%')
      .translate({ x: 0, y: -10 })
      .justifyContent(FlexAlign.Start)
      .padding({
        left: 20,
        right: 20,
        top: 10,
        bottom: 10
      })
      .backgroundColor(Color.White)
    }
    .justifyContent(FlexAlign.End)
    .height('100%')

  }
}
saveData('secondTransaction')
