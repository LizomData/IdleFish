import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import Food, { RouteParam } from '../model/modle';
import MyData from '../model/MyData';
import { preferences } from '@kit.ArkData';
import PreferenceUtil from '../util/PreferencesUtil';
import { http } from '@kit.NetworkKit';
import { GlobalVariable } from '../util/GlobalVariable';
import { BusinessError } from '@kit.BasicServicesKit';
import Toast from '../util/Toast';

export const Path_Detail = 'pages/DetailPage'

@Entry
@Component
struct ProductDetailPage {
  @State imgScale: number = 1;
  @State imgOffsetX: number = 0;
  @State imgOffsetY: number = 0;
  @State dragStartX: number = 0;
  @State dragStartY: number = 0;
  @State lastClickTime: number = 0;
  @State enlargeImage: string | Resource = '';


  // 当前展示的商品信息，默认取内置数据以避免空对象
  food: Food = MyData.homeListData[0]
  // 当前登录用户 ID
  @State user_id: preferences.ValueType = ''

  hideLarge() {
     this.imgScale = 1;
    this.imgOffsetX = 0;
    this. imgOffsetY = 0;
    this. dragStartX = 0;
    this. dragStartY = 0;
    this. lastClickTime = 0;
    this.enlargeImage = '';
  }

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
    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip + '/api/order/create', {
      method: http.RequestMethod.POST,
      header: {
        'Content-Type': 'application/json',
        "Authorization": GlobalVariable.token,
      },
      extraData: JSON.stringify({
        "item_id": Number(this.food.id_)
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

          Toast.show("购买成功: order_id为" + JSON.parse(data.result.toString())["data"]['order_id'].toString())
          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })
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
        Image($r('app.media.arrow_left')).width(20).height(25)
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
          .margin({ left: 120 })
      }
      .width('100%')
      //.height(50)
      .margin({ top: 45, bottom: 15 })
      //.justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)
      .backgroundColor(Color.White)

      Scroll() {
        Column() {
          //图片轮播
          Row() {
            Stack() {
              if (this.enlargeImage) {
                Stack() {
                  // 主图区域，展示商品大图
                  Image(this.enlargeImage)
                    .width('90%')
                    .height(300)
                    .borderRadius(16)
                    .scale({ x: this.imgScale, y: this.imgScale })
                    .translate({ x: this.imgOffsetX, y: this.imgOffsetY })
                    .gesture(
                      PanGesture()
                        .onActionStart((e: GestureEvent) => {
                          this.dragStartX = e.offsetX;
                          this.dragStartY = e.offsetY;
                        })
                        .onActionUpdate((e: GestureEvent) => {
                          this.imgOffsetX = this.imgOffsetX + e.offsetX - this.dragStartX;
                          this.imgOffsetY = this.imgOffsetY + e.offsetY - this.dragStartY;
                          this.dragStartX = e.offsetX;
                          this.dragStartY = e.offsetY;
                        })
                        .onActionEnd(() => {
                          const maxX = (this.imgScale - 1) * 360;
                          const maxY = (this.imgScale - 1) * 640;
                          this.imgOffsetX = Math.max(-maxX, Math.min(maxX, this.imgOffsetX));
                          this.imgOffsetY = Math.max(-maxY, Math.min(maxY, this.imgOffsetY));
                          animateTo({ duration: 200, curve: Curve.EaseOut }, () => {
                            this.imgOffsetX = this.imgOffsetX;
                            this.imgOffsetY = this.imgOffsetY;
                          });
                        })
                    )
                    .onClick((event: ClickEvent) => {
                      const now = Date.now();
                      if (now - this.lastClickTime < 300) {
                        this.imgScale = this.imgScale === 1 ? 2 : 1;
                        this.imgOffsetX = 0;
                        this.imgOffsetY = 0;
                      }
                      this.lastClickTime = now;
                    })

                  Button() {
                    Image($r('app.media.close_green')).width(32).height(32)
                  }
                  .type(ButtonType.Circle)
                  .backgroundColor(Color.Transparent)
                  .onClick(() => this.hideLarge())
                  .position({ x: '90%', y: '5%' })
                  .zIndex(1000)
                  .stateEffect(true)

                }
                .width('100%')
                .height('100%')
                .backgroundColor('#E0000000')
                .position({ x: 0, y: 0 })
                .zIndex(999)
                .transition({ type: TransitionType.Insert, scale: { x: 1.1, y: 1.1 } })
                .animation({ duration: 200 })
              } else {
                Image(this.food.image_urls)
                  .width('90%')
                  .height(300).borderRadius(16).onClick(() => {
                  this.enlargeImage = this.food.image_urls;
                })
              }


              // Row() {
              //   // 右下角标识区域，可扩展为轮播指示器
              //   Text('0000321')
              //     .backgroundColor('#797B7A')
              //     .borderRadius(16)
              //     .padding({
              //       left: 10,
              //       right: 10,
              //       top: 5,
              //       bottom: 5
              //     })
              //     .fontSize(12)
              //     .fontColor(Color.White)
              //     .fontWeight(600)
              //   // Text(this.productList.length.toString())
              //   Text('3')
              //     .margin({ right: 8, left: 10 })
              //     .fontSize(12)
              //     .fontColor(Color.White)
              //     .fontWeight(600)
              // }
              // .backgroundColor('#98999B')
              // .borderRadius(16)
              // .margin({ right: 10 })

            }
            .alignContent(Alignment.BottomEnd)
          }
          .margin({ top: 20, bottom: 20 })
          .alignItems(VerticalAlign.Bottom)

          //内容区域
          Column() {
            Row() {
              Row() {
                Text('￥' + (this.food.price).toString())
                  .fontSize(20).fontWeight(FontWeight.Bold)
                  .fontColor(Color.Red)
                //Blank()
              }
              .width('100%')
              .padding({ left: 10, right: 10 })
              .justifyContent(FlexAlign.Center)
              //.alignItems(HorizontalAlign.Start)
              .height(60)
              .borderRadius({ topLeft: 16, topRight: 30, bottomRight: 30 })
              .width('66%')
              .linearGradient({
                direction: GradientDirection.Right,
                repeating: false,
                colors: [['#FFFFE00D', 0.0], ['#fffabf0c', 1.0]]
              })
              .margin({ right: 10 })
              .height(60)
              .justifyContent(FlexAlign.Start)

              Column() {
                Text('热销中🔥')
                  .fontSize(12)
                  .padding(3)
                  .fontColor(Color.Red)
                  .backgroundColor('#FFFFE0E0')
                  .borderRadius(10)
                  .margin({ bottom: 3 })
                Text('品质保障')
                  .fontSize(12)
                  .padding(3)
                  .fontColor('#ffac754a')
                  .borderRadius(12)
                  .backgroundColor(Color.White)
                  .fontWeight(500)
              }
              .margin({ right: 20 })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')

            Column() {
              Column() {
                Row() {
                  Text(this.food.name)
                    .fontSize(20)
                    .fontWeight(FontWeight.Bold)
                    .padding(5)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
                .padding({ top: 10, bottom: 10 })

              }
              .backgroundColor(Color.White)
              .width('100%')
              .borderRadius(16)

            }
            .borderRadius(16)
            .backgroundColor(Color.White)

          }
          .backgroundColor('#FFFFE00D')
          .width('90%')
          .borderRadius(16)

          Column() {
            Text('商品描述')
              .fontSize(16)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 5, bottom: 5 })
              .lineHeight(18)
            Text(this.food.name)
              .fontSize(14)
              .fontWeight(FontWeight.Normal)
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
        .backgroundColor('#fff1f1f1')
        .height('100%')
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.Off)
      .layoutWeight(1)

      Row() {
        Text('平台将保障您的交易安全')
          .fontColor(Color.Gray)
          .fontSize(12).width('50%')
          .margin({ left: 16, right: 16 })
        Blank()
          .layoutWeight(1)

        Column() {
          Text('购买')
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