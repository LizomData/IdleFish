// 编辑页所需的界面与数据工具
import { promptAction, router } from '@kit.ArkUI'
import { preferences } from '@kit.ArkData'
import MyData from '../model/MyData'
import DateUtil from '../util/DateUtil'
import Food, { RouteParam } from '../model/modle'
import DbUtil from '../util/DbUtil'
import PreferenceUtil from '../util/PreferencesUtil'
import EventUtil from '../util/EventUtil'


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
    this.tempImageUrl = this.food.icon_url
    this.tempDes = this.food.name
    this.tempPrice = this.food.now_price

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
    let goodId = this.food.id_
    if (goodId == '') {
      // 若缺少商品编号则重新生成
      goodId = DateUtil.generateOrderCode()
    }
    let own_u_id = this.food.own_u_id
    if (own_u_id == '') {
      own_u_id = ''
    }
    // 获取当前登录用户作为发布者
    let user_id: preferences.ValueType = await PreferenceUtil.getPreferenceValue('user_name', '')
    // 维持想要人数的随机值
    let wantN = Math.floor(Math.random() * 100)
    let v: Food = {
      id_: goodId,
      publish_u_id: user_id.toString(),
      own_u_id: own_u_id,
      //名称
      name: this.tempDes,
      //
      want_count: `${wantN}`,
      //图片
      icon_url: this.tempImageUrl,
      //价格
      now_price: this.tempPrice,
    }
    // 更新数据库后通过事件通知刷新
    DbUtil.updateFood(v).then(()=>{
      //数据库修改完毕后发送消息到前一个页面
      EventUtil.send(1)
    })

    promptAction.showToast({
      message: '编辑成功！'
    })

    router.back()
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back')).width(20).height(25)
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
          // 图片加载失败时回退默认占位图
          this.loadImageUrl = MyData.detailImageUrl
        })
        .onFinish(() => {
          console.log('zushiyekeji img onFinish ')
        })
        .onComplete(() => {
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
            // 先暂存用户输入，待确认后再应用
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
            // 确认图片后赋值到展示变量
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
            // 同步最新描述
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
            // 同步价格
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
          // 提交编辑结果
          this.publishBtn()
        })

    }.width('100%').height('100%').padding(16)
  }
}
