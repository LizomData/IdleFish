// 发布列表依赖的数据源、工具与事件工具方法
import MyData from '../../model/MyData'
import { promptAction, router } from '@kit.ArkUI'
import Food, { ItemType, RouteParam, TabBean } from '../../model/modle'
import DbUtil from '../../util/DbUtil'
import { Path_Update } from '../UpdatePage'
import EventUtil from '../../util/EventUtil'
import { http } from '@kit.NetworkKit'
import { BusinessError } from '@kit.BasicServicesKit';
import { GlobalVariable } from '../../util/GlobalVariable'
import List from '@ohos.util.List';
import Toast from '../../util/Toast'

@Preview
@Entry
@Component
export struct SellFragment {
  //调试用
  // @State dataList: Array<Food> = [MyData.homeListData[0]]
  // 当前用户发布的数据列表
  @State dataList: Array<Food> = []

  async fetchGoodList() {


    // 创建请求对象
    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/items_my', {
      method: http.RequestMethod.GET,
      header: { 'Content-Type': 'application/json',
        "Authorization":GlobalVariable.token,
      },

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

          let list:  List<object> = JSON.parse(data.result.toString())["data"];
          for (const item of list) {
            let food: Food = {
              price: String(item['price']),
              id_: String(item['id']),
              publish_u_id: '',
              own_u_id: '',
              name: item['name'],
              people_want: item['people_want'],
              image_urls: String(item['image_urls']).includes("http") ? item['image_urls'] :
                "http://10.34.82.240:8800" + item['image_urls']
            }
            this.dataList.push(food);
          }
          console.log("aaaa:" + JSON.parse(data.result.toString())["data"])
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
                Image(itemData.image_urls)
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
