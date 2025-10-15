// 买入列表所需的数据及工具类
import MyData from '../../model/MyData'
import Food, { ItemType, TabBean } from '../../model/modle'
import DbUtil from '../../util/DbUtil'

@Preview
@Entry
@Component
export struct BuyFragment {
  // @State dataList: Array<Food> = [MyData.homeListData[0]]

  // 我的买入数据集合
  @State dataList: Array<Food> = []

  // 进入页面执行
  async aboutToAppear() {
    console.log('zushiyekeji BuyFragment aboutToAppear')

    // 页面展示时读取“我买入的”商品数据
    this.dataList = await DbUtil.queryFoodListMeBuy()
  }

  async onDeleteClick(itemData: Food) {
    // await DbUtil.deleteFood(itemData.id_)
    //
    // promptAction.showToast({
    //   message: '删除成功'
    // })
    //
    // this.dataList = await DbUtil.queryFoodListMePublish()
  }

  @Builder
  bottomBuilder() {
    //渲染商品列表数据
    WaterFlow({}) {
      ForEach(this.dataList,
        (itemData: Food, index: number) => {
          FlowItem() {
            Stack() {
              Column() {
                Image(itemData.image_urls)
                  .width('100%')
                  //.height(index == 2 ? 100 : 150)
                  .height(150)
                  .borderRadius(10)
                  .borderRadius(8)
              Column() {
                // 商品信息区域
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

              // Image($r('app.media.delete'))
              //   .width(30)
              //   .height(30)
              //   .margin({ right: 5 })
              //   .onClick(() => {
              //     this.onDeleteClick(itemData)
              //   })
            }
            .alignContent(Alignment.BottomEnd)
            .padding(5)
            .borderRadius(10)
            .backgroundColor(Color.White)
          }

          //.backgroundColor(Color.White)
        })
    }
    //到底部时触发
    .onReachEnd(async () => {

    })
    .columnsTemplate('1fr 1fr')
    .rowsGap(10)
    .columnsGap(10)
    .height('100%')
  }

  build() {
    Column() {
      // 页面标题
      Text('我买入的')
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .margin({ top: 50, bottom: 10 })
      Scroll() {
        // 列表支持滚动浏览全部已购买商品
        this.bottomBuilder()
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .padding(15)
      .backgroundColor('#0d000000')
    }

  }
}
