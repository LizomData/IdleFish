// 引入页面展示所需的数据、工具与事件工具类
import MyData from '../../model/MyData'
import { d1 } from "hytech"
import { promptAction, router } from '@kit.ArkUI'
import { m as initData } from 'ohbuild';
import Food, { ItemType, RouteParam, TabBean } from '../../model/modle'
import Toast from '../../util/Toast'
import DbUtil from '../../util/DbUtil'
import emitter from '@ohos.events.emitter'
import EventUtil from '../../util/EventUtil'
import { Path_Detail } from '../DetailPage'
import PreferencesUtil from '../../util/PreferencesUtil';
import { http } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import List from '@ohos.util.List';

@Preview
@Entry
@Component
export struct HomeFragment {
  // 顶部二级分类当前选中的标签索引
  @State currTabIndex: number = 1
  // 当前是否处于搜索结果展示状态
  @State isSearchState: boolean = false
  // 输入框中的搜索关键字，未使用状态装饰避免频繁刷新
  searchKeyStr: string = ''
  // 首页默认展示的数据列表，从内置数据源初始化
  @State dataList: Array<Food> = []
  // 搜索结果列表，切换搜索状态后用于替换展示
  @State searchList: Array<Food> = []
  @State username: string = "unknown";

  async fetchGoodList() {


    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request('http://10.34.82.240:8800/api/items', {
      method: http.RequestMethod.GET,
      header: { 'Content-Type': 'application/json' },

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

          let list : List<object>= JSON.parse(data.result.toString())["data"];
          for (const item of list) {
            let food : Food= {
              price: item['price'],
              id_: '',
              publish_u_id: '',
              own_u_id: '',
              name: item['name'],
              people_want: item['people_want'],
              image_urls: "http://10.34.82.240:8800"+item['image_urls']
            }
            this.dataList.push(food);
          }
          console.log("aaaa:"+JSON.parse(data.result.toString())["data"])
          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })
  }

  //每次都执行
  async aboutToAppear() {

    await this.fetchGoodList();

    const userName: string = await PreferencesUtil.getStringPreference('user_name', '');

    // 更新状态
    if (userName.trim() === "") {
      this.username = 'Guest';
    } else {
      this.username = userName;
    }

    console.log('zushiyekeji HomeFragment aboutToAppear')
    // EventUtil.register(0, async (res)=>{

    // })
    //

    // 清空旧的搜索关键字，避免返回页面时显示历史输入
    //清空搜索值
    this.searchKeyStr = ''
    // 从本地数据库查询最新的商品数据，保持展示与数据库同步
    //查询最新的数据库数据
    // let l: Array<Food> = await DbUtil.queryFoodList()
    // this.dataList = l
    // 回到常规模式，先展示默认列表
    this.isSearchState = false
    // 清空上一轮搜索结果
    this.searchList = []
    // 触发埋点，统计页面曝光
    initData('secondTransaction')
  }

  @Builder
  searchBuilder() {
    // 搜索区域包含扫描图标、输入框与搜索按钮
    Row() {
      Image($r('app.media.ic_code'))
        .width(21)
        .margin({ left: 16 })

      TextInput({ placeholder: '搜索商品' })
        .textAlign(TextAlign.Start)
        .backgroundColor(Color.Transparent)
        .onChange((value: string, previewText?: PreviewText) => {
          // 仅记录输入内容，不立即请求数据库
          this.searchKeyStr = value
        })
        .layoutWeight(1)

      Text('搜索')
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
          // 点击后根据关键字执行数据库查询
          this.onSearchClick()
        })
    }
    .margin({ top: 40 })
    .borderRadius(20)
    .borderColor('#ff2b2a2a')
    .borderWidth(1)

  }

  async onSearchClick() {
    // 查询包含关键字的商品列表并展示在搜索结果区域
    this.searchList = await DbUtil.queryFoodListByName(this.searchKeyStr)
    this.isSearchState = true
  }

  @Builder
  topTabBuilder() {
    // 顶部标签切换区域，使用 Tabs 组件实现
    Column() {
      Tabs({
        barPosition: BarPosition.Start,
        index: this.currTabIndex
      }) {
        ForEach(MyData.topTabBeanList, (item: TabBean, index: number) => {
          TabContent() {

          }.tabBar(
            new SubTabBarStyle(item.title)
              .indicator({
                color: $r('app.color.green_music')
              })
              .labelStyle({
                unselectedColor: '#000000',
                selectedColor: $r('app.color.green_music')
              })
          )
        })
      }
      .vertical(false)
      .barHeight(55)
      .height(55)
      .width('60%')
      .onChange((index: number) => {
        let str = MyData.topTabBeanList[index].title
        //Toast.show(str)
        // 顶部频道暂未实现，统一提示敬请期待
        Toast.show('敬请期待')
      })
    }.width('100%').alignItems(HorizontalAlign.Start)

    //.backgroundColor(Color.Red)
  }

  @Builder
  funcBuilder() {
    // 功能入口使用横向滚动实现快速导航
    Scroll() {
      Row({ space: 10 }) {
        ForEach(MyData.funcAreaList, (itemData: ItemType, index: number) => {
          Column() {
            Image(itemData.img)
              .height(60)
              .width('100%')
              .borderRadius(10)
            Text(itemData.title)
              .fontColor(Color.White)
              .fontSize(13)
              .fontWeight(FontWeight.Medium)
              .margin({ top: 4 })
              .borderRadius(5)
              .backgroundColor($r('app.color.green_music'))
              .padding({
                left: 6,
                right: 6,
                top: 2,
                bottom: 2
              })
          }
          .width('20%')
          //.height(150)
          .onClick(() => {
            // 入口功能后续补齐，此处给予统一提示
            Toast.show('敬请期待')
          })
        })
      }
    }
    .width('100%')
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off) //关闭滚动条
    .margin({ top: 0 })
  }

  @Builder
  userBuilder() {
    // 欢迎语区域展示用户昵称和快捷文案
    Row() {
      Text('你好，' + this.username)
        .fontColor(Color.Black)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
      //.margin({ top: 16 })

      Image($r('app.media.ic_vip'))
        .width(30)
        .height(15)
        .margin({ left: 5 })

      Text('二手交易就在集市')
        .fontColor(Color.Gray)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .layoutWeight(1)
        .textAlign(TextAlign.End)

      Image($r('app.media.arrow_to_right'))
        .width(15).height(15)
        .margin({ left: 5 })
    }
    .width('100%')
    .margin({ top: 20, bottom: 5 })
    .alignItems(VerticalAlign.Center)

  }

  @Builder
  func2Builder() {
    // 横向展示推荐位海报
    Row() {
      Image($r('app.media.hfunc1'))
        .width('50%')//.objectFit(ImageFit.Fill)
        .height(90).borderRadius(10)
      Image($r('app.media.hfunc2'))
        .width('20%')
        .height(90).borderRadius(10)
        .margin({ left: 10 })
      Image($r('app.media.hfunc3'))
        .width('20%')
        .height(90).borderRadius(10)
        .margin({ left: 10 })
    }
    .width('100%')
    .margin({ top: 10 })

  }

  // title显示
  @Builder
  titleBuilder(title: string) {
    // 通用标题栏组件，统一控制主标题与更多按钮的样式
    Row() {
      Text(title)
        .fontColor($r('app.color.black1'))
        .fontSize(20)
        .fontWeight(FontWeight.Medium)
      //.fontColor($r("app.color.fuzhu2"))
      //.fontColor($r("app.color.white"))

      Text('更多')
        .margin({ right: 10 })
        .fontWeight(FontWeight.Regular)
        .fontSize(14)
        .fontColor($r('app.color.black1'))
      //.fontColor($r("app.color.white"))
    }
    //.backgroundColor(Color.Red)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 15 })
  }

  @Builder
  bottomBuilder() {
    //渲染商品列表数据
    WaterFlow({}) {
      ForEach(!this.isSearchState ? this.dataList : this.searchList,
        (itemData: Food, index: number) => {
          FlowItem() {
            Column() {
              Image(itemData.image_urls)
                .width('100%')
                .height(index == 2 ? 100 : 150)
                .borderRadius(10)
                .borderRadius(8)
              Column() {
                Text(itemData.name)
                  .margin({ top: 10 })
                Row() {
                  //价格
                  Text('¥ ' + itemData.price)
                    .fontColor(Color.Red).fontSize(14)
                    .fontWeight(600)
                  //已售
                  Text(`${itemData.people_want}想要`)
                    .fontColor('#ff696868').fontSize(12)
                    .margin({ left: 10 })
                }
                .width('100%')
                .margin({ top: 10 })
              }.alignItems(HorizontalAlign.Start)

            }
            .padding(5)
            .borderRadius(10)
            .backgroundColor(Color.White)
            .onClick(() => {
              this.goDetail(itemData)
            })
          }

          //.backgroundColor(Color.White)
        })
    }
    //到底部时触发
    .onReachEnd(async () => {

    })
    //.backgroundColor('#ffe2e2e2')
    .columnsTemplate('1fr 1fr')
    .rowsGap(10)
    .columnsGap(10)

    //.padding(10)
  }

  @Builder
  searchListBuilder() {
    // 搜索结果页与主列表结构一致，通过浮层显示
    Column() {
      RelativeContainer() {
        Text('搜索结果')
          .fontColor(Color.Black)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            middle: {
              anchor: '__container__',
              align: HorizontalAlign.Center
            },
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            }
          })
        Image($r('app.media.close'))
          .width(30)
          .height(30)
          .alignRules({
            right: {
              anchor: '__container__',
              align: HorizontalAlign.End
            },
            center: {
              anchor: '__container__',
              align: VerticalAlign.Center
            }
          })
          .margin({ right: 15 })
          .onClick(() => {
            // 关闭搜索层并恢复默认列表
            this.searchList = []
            this.isSearchState = false
          })
      }.margin({ top: 50, bottom: 15 }).height(40)

      //渲染商品列表数据
      WaterFlow({}) {
        ForEach(!this.isSearchState ? this.dataList : this.searchList,
          (itemData: Food, index: number) => {
            FlowItem() {
              Column() {
                Image(itemData.image_urls)
                  .width('100%')
                  .height(index == 2 ? 100 : 150)
                  .borderRadius(10)
                  .borderRadius(8)
                Column() {
                  Text(itemData.name)
                    .margin({ top: 10 })
                  Row() {
                    //价格
                    Text('¥ ' + itemData.now_price)
                      .fontColor(Color.Red).fontSize(14)
                      .fontWeight(600)
                    //已售
                    Text(`${itemData.want_count}想要`)
                      .fontColor('#ff696868').fontSize(12)
                      .margin({ left: 10 })
                  }
                  .width('100%')
                  .margin({ top: 10 })
                }.alignItems(HorizontalAlign.Start)

              }
              .padding(5)
              .borderRadius(10)
              .backgroundColor(Color.White)
              .onClick(() => {
                // 点击跳转详情，方便复用统一的进入路径
                this.goDetail(itemData)
              })
            }

            //.backgroundColor(Color.White)
          })
      }
      //到底部时触发
      .onReachEnd(async () => {

      })
      //.backgroundColor('#ffe2e2e2')
      .columnsTemplate('1fr 1fr')
      .rowsGap(10)
      .columnsGap(10)
      .layoutWeight(1)

    }.height('100%')
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      Scroll() {
        if (!this.isSearchState) {
          Column() {

            this.searchBuilder()
            this.topTabBuilder()

            this.funcBuilder()

            this.userBuilder()
            this.func2Builder()

            this.titleBuilder('最近上新')

            this.bottomBuilder()
          }
          .padding(15)
          .width('100%')
        } else {
          // 搜索状态下，仅渲染搜索结果组件
          this.searchListBuilder()
        }
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .attributeModifier(d1)

    }

  }

  goDetail(item: Food) {
    // 构造路由参数对象，将选中的商品数据传递到详情页
    const p = new RouteParam()
    p.content = item
    router.pushUrl({
      url: Path_Detail,
      params: p
    })
  }
}
