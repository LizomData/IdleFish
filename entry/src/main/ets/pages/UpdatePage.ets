// 编辑页所需的界面与数据工具
import { promptAction, router } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'
import MyData from '../model/MyData'
import DateUtil from '../util/DateUtil'
import Food, { RouteParam } from '../model/modle'
import DbUtil from '../util/DbUtil'
import PreferenceUtil from '../util/PreferencesUtil'
import EventUtil from '../util/EventUtil'
import { http } from '@kit.NetworkKit'
import { GlobalVariable } from '../util/GlobalVariable'
import Toast from '../util/Toast'
import { BusinessError } from '@kit.BasicServicesKit';


export const Path_Update = 'pages/UpdatePage'

/**
 * 编辑宝贝页面
 */
@Preview
@Entry
@Component
export struct UpdatePage {
  //islLoadImageSuccess :number = -1
  // 标记图片是否经过确认
  isClickImageBtn: boolean = false
  // 输入框临时记录的图片地址
  inputImageUrl: string = ''
  // 图片展示使用的资源
  @State loadImageUrl: string = MyData.detailImageUrl
  // 即将提交的图片地址
  @State tempImageUrl: string = ''
  // 商品描述
  @State tempDes: string = ''
  // 商品价格
  @State tempPrice: string = ''
  // 当前编辑的商品信息
  food: Food = MyData.homeListData[0]
  // 路由参数对象
  routeParam = new RouteParam()

  //每次都执行
  async aboutToAppear() {
    console.log('zushiyekeji UpdatePage aboutToAppear')
    console.log(JSON.stringify(router.getParams()))
    // 获取上一页传递过来的商品信息并初始化表单
    this.routeParam = router.getParams() as RouteParam
    this.food = this.routeParam.content as Food
    this.tempImageUrl = this.food.image_urls
    this.loadImageUrl = this.food.image_urls
    this.tempDes = this.food.name
    this.tempPrice = this.food.price

  }

  async publishBtn() {
    if (!this.isClickImageBtn) {
      // 图片未确认时给予提示
      promptAction.showToast({
        message: '图片点击确定按钮！'
      })
      return
    }
    if (this.tempDes == '') {
      // 描述校验
      promptAction.showToast({
        message: '兄弟，商品描述写上！'
      })
      return
    }
    if (this.tempPrice == '') {
      // 价格校验
      promptAction.showToast({
        message: '兄弟，商品价格写上！'
      })
      return
    }

    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/items/'+this.food.id_, {
      method: http.RequestMethod.PUT,
      header: { 'Content-Type': 'application/json',
        "Authorization":GlobalVariable.token,
      },
      extraData:JSON.stringify({
        "name": this.tempDes,
        "description": this.tempDes,
        "price": this.tempPrice,
        "image_url":  this.tempImageUrl,
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
            message: '编辑成功！'
          })

          // 销毁请求对象
          httpRequest.destroy()

          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })
    return
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.arrow_left')).width(20).height(25)
          .margin({
            left: 16
          })
          .onClick(() => {
            // 顶部返回按钮
            router.back()
          })
        Text('编辑宝贝')
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

      Image(this.loadImageUrl)
        .onError(() => {
          this.loadImageUrl = MyData.detailImageUrl
        })
        .onFinish(() => {
          console.log('img onFinish ')
        })
        .onComplete(() => {
          console.log('img onComplete ')
          //this.islLoadImageSuccess = 1
        })
        .height(300)
        .width('100%')
        .margin({ top: 10 })
        .borderRadius(5)

      Row() {
        TextInput({ text: this.tempImageUrl, placeholder: '请输入商品图地址URL' })
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            this.inputImageUrl = value
          })
          .layoutWeight(1)

        Text('确定')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#fffd0000')
          .margin({ right: 16 })
          .padding({
            left: 14,
            top: 4,
            right: 14,
            bottom: 4
          })
          .borderRadius(13)
          .onClick(() => {
            this.isClickImageBtn = true
            this.tempImageUrl = this.inputImageUrl
            this.loadImageUrl = this.inputImageUrl
          })
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor('#ff0d66ff')
      .borderWidth(1)

      Row() {
        TextInput({ text: this.tempDes, placeholder: '请输入商品名称或者描述' })
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            // 同步最新描述
            this.tempDes = value
          })
          .layoutWeight(1)
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor('#ff0d66ff')
      .borderWidth(1)

      Row() {
        TextInput({ text: this.tempPrice, placeholder: '请输入商品价格' })
          .textAlign(TextAlign.Start)
          .type(InputType.NUMBER_DECIMAL)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            this.tempPrice = value
          })
          .layoutWeight(1)
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor('#ff0d66ff')
      .borderWidth(1)

      Text('发布')
        .fontSize(20)
        .fontColor(Color.White)
        .backgroundColor('#ff0d66ff')
        .margin({ left: 20, right: 20, top: 40 })
        .width('100%')
        .height(40)
        .textAlign(TextAlign.Center)
        .borderRadius(30)
        .onClick(() => {
          this.publishBtn()
        })

    }.width('100%').height('100%').padding(16)
  }
}
