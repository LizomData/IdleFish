// 发布列表依赖的数据源、工具与事件工具方法
import MyData from '../../model/MyData'
import { promptAction, router } from '@kit.ArkUI'
import Food, { ItemType, RouteParam, TabBean } from '../../model/modle'
import DbUtil from '../../util/DbUtil'
import { Path_Update } from '../UpdatePage'
import EventUtil from '../../util/EventUtil'

@Preview
@Entry
@Component
export struct SellFragment {
  //调试用
  // @State dataList: Array<Food> = [MyData.homeListData[0]]
  // 当前用户发布的数据列表
  @State dataList: Array<Food> = []

  // 进入页面执行
  async aboutToAppear() {
    console.log('zushiyekeji SellFragment ')

    // 初始化时查询当前用户发布的所有商品
    this.dataList = await DbUtil.queryFoodListMePublish()
  }

  async onDeleteClick(itemData: Food) {
    // 删除单个商品后刷新列表
    await DbUtil.deleteFood(itemData.id_)

    promptAction.showToast({
      message: '删除成功'
    })

    this.dataList = await DbUtil.queryFoodListMePublish()
  }

  goUpdatePage(item: Food) {
    const p = new RouteParam()
    p.content = item
    //回传数据 回调
    // 注册事件回调，更新成功后刷新数据
    EventUtil.register(1, async ()=>{
      console.log('zushiyekeji goUpdatePage 回调')

      this.dataList = await DbUtil.queryFoodListMePublish()

      EventUtil.off(1)
    })
    router.pushUrl({
      url: Path_Update,
      params: p,
    })
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
                // 商品封面图
                Image(itemData.icon_url)
                  .width('100%')//.height(index == 2 ? 100 : 150)
                  .height(150)
                  .borderRadius(10)
                  .borderRadius(8)
                Column() {
                  // 商品标题
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
              .onClick(() => {
                // 点击卡片进入编辑页
                this.goUpdatePage(itemData)
              })

              Image($r('app.media.delete'))
                .width(30)
                .height(30)
                .margin({ right: 5 })
                .onClick(() => {
                  // 删除按钮单独处理，避免冒泡引发详情跳转
                  this.onDeleteClick(itemData)
                })
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
      // 顶部标题与说明
      Text('我发布的')
        .fontWeight(FontWeight.Bold)
        .fontSize(20)
        .margin({ top: 50, bottom: 10 })
      Scroll() {
        // 列表区域支持滚动查看全部商品
        this.bottomBuilder()
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .padding(15)
      .backgroundColor('#0d000000')
    }

  }
}
