// 发布页面引入通用数据、工具类及用户信息存储
import MyData from '../../model/MyData'
import { t } from "hytech"
import { promptAction, router } from '@kit.ArkUI'
import Food, { ItemType, TabBean } from '../../model/modle'
import Toast from '../../util/Toast'
import DbUtil from '../../util/DbUtil'
import emitter from '@ohos.events.emitter'
import EventUtil from '../../util/EventUtil'
import DateUtil from '../../util/DateUtil'
import PreferenceUtil from '../../util/PreferencesUtil'
import { preferences } from '@kit.ArkData'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit';
import { GlobalVariable } from '../../util/GlobalVariable'

@Preview
@Entry
@Component
export struct PublishFragment {
  //islLoadImageSuccess :number = -1
  // 控制图片按钮是否已经确认
  isClickImageBtn :boolean = false
  // 临时存储输入框中的图片地址
  inputImageUrl: string = ''
  // 图片加载展示用的资源 url
  @State loadImageUrl: string = MyData.detailImageUrl
  // 真正用于提交的图片地址
  @State tempImageUrl: string = ''
  // 商品描述
  @State tempDes: string = ''
  // 商品价格
  @State tempPrice: string = ''

  //每次都执行
  async aboutToAppear() {
    console.log('zushiyekeji SellFragment aboutToAppear')
    // EventUtil.register(0, async (res)=>{
    //   //清空搜索值
    //   this.searchKeyStr = ''
    //   //查询最新的数据库数据
    //   let l: Array<Food> = await DbUtil.queryFoodList()
    //   this.dataList = l
    //   this.isSearchState = false
    // })
    // //
    // // let l: Array<Food> = await DbUtil.queryFoodList()
    // // this.dataList = l
  }

  async publishBtn() {
    if (!this.isClickImageBtn) {
      // 未确认图片时提示用户
      promptAction.showToast({
        message: '图片点击确定按钮！'
      })
      return
    }
    if (this.tempDes == '') {
      // 描述为空校验
      promptAction.showToast({
        message: '兄弟，商品描述写上！'
      })
      return
    }
    if (this.tempPrice == '') {
      // 价格为空校验
      promptAction.showToast({
        message: '兄弟，商品价格写上！'
      })
      return
    }


    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/items/upload', {
      method: http.RequestMethod.POST,
      header: { 'Content-Type': 'application/json',
      "Authorization":GlobalVariable.token,
      },
      extraData:JSON.stringify({
        "name": this.tempDes,
        "description": this.tempDes,
        "price": this.tempPrice,
        "image_url":  this.tempImageUrl,
        "peole_want": Math.floor(Math.random() * 100)
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
            message: '发布成功！'
          })

          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })
    //
    // // 通过时间戳生成唯一商品ID
    // let goodId = DateUtil.generateOrderCode()
    // let user_id: preferences.ValueType = await PreferenceUtil.getPreferenceValue('user_name', '')
    // // 随机生成想要人数，增加页面活力
    // let wantN = Math.floor(Math.random() * 100)
    // let v: Food = {
    //   id_: goodId,
    //   publish_u_id: user_id.toString(),
    //   own_u_id: '',
    //   //名称
    //   name: this.tempDes,
    //   //
    //   people_want: `${wantN}`,
    //   //图片
    //   image_urls: this.tempImageUrl,
    //   //价格
    //   price: this.tempPrice,
    // }
    // DbUtil.insertFood(v)



    //清除数据
    this.isClickImageBtn = false
    this.inputImageUrl = ''
    this.loadImageUrl = MyData.detailImageUrl

    this.tempImageUrl = ''
    this.tempDes = ''
    this.tempPrice = ''

    //发送消息
    //EventUtil.send(0)
  }

  build() {
    Column() {
      // 页面标题
      Text('发布宝贝')
        .fontColor($r('app.color.black1'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 40 })
      Image(this.loadImageUrl)
        .onError(() => {
          // 加载失败时回退到默认占位图
          this.loadImageUrl = MyData.detailImageUrl
        })
        .onFinish(()=>{
          console.log('zushiyekeji img onFinish ')
        })
        .onComplete(()=>{
          console.log('zushiyekeji img onComplete ')
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
            // 图片输入框仅在用户确认前暂存值
            this.inputImageUrl = value
          })
          .layoutWeight(1)

        Text('确定')
          .fontSize(16)
          .fontColor(Color.White)
          .backgroundColor('#EB5E1A')
          .margin({ right: 16 })
          .padding({
            left: 14,
            top: 4,
            right: 14,
            bottom: 4
          })
          .borderRadius(13)
          .onClick(() => {
            // 检查图片后再赋值到正式变量
            this.isClickImageBtn = true
            this.tempImageUrl = this.inputImageUrl
            this.loadImageUrl = this.inputImageUrl
          })
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor($r('app.color.zhuti'))
      .borderWidth(1)

      Row() {
        TextInput({ text: this.tempDes, placeholder: '请输入商品名称或者描述' })
          .textAlign(TextAlign.Start)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            // 同步商品描述
            this.tempDes = value
          })
          .layoutWeight(1)
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor($r('app.color.zhuti'))
      .borderWidth(1)

      Row() {
        TextInput({ text: this.tempPrice, placeholder: '请输入商品价格' })
          .textAlign(TextAlign.Start)
          .type(InputType.NUMBER_DECIMAL)
          .backgroundColor(Color.Transparent)
          .onChange((value: string, previewText?: PreviewText) => {
            // 同步商品价格
            this.tempPrice = value
          })
          .layoutWeight(1)
      }
      .margin({ top: 10 })
      .borderRadius(20)
      .borderColor($r('app.color.zhuti'))
      .borderWidth(1)

      Text('发布')
        .fontSize(20)
        .fontColor(Color.White)
        .backgroundColor('#FFE20D')
        .margin({ left: 20, right: 20, top: 40 })
        .width('100%')
        .height(40)
        .textAlign(TextAlign.Center)
        .borderRadius(30)
        .onClick(() => {
          // 点击发布，触发发布流程校验与入库
          this.publishBtn()
        })

    }
    .attributeModifier(t)
    .width('100%')
    .height('100%')
    .padding(16)
  }
}
