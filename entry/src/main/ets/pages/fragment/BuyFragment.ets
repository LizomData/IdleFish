// 买入列表所需的数据及工具类
import Food, { ItemType, TabBean } from '../../model/modle'
import Toast from '../../util/Toast'
import { BusinessError } from '@kit.BasicServicesKit';
import { http } from '@kit.NetworkKit';
import { GlobalVariable } from '../../util/GlobalVariable';
import { promptAction } from '@kit.ArkUI';
import List from '@ohos.util.List';

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

    const httpRequest = http.createHttp()
    httpRequest.request(GlobalVariable.server_ip+'/api/order/list', {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        "Authorization": GlobalVariable.token,
      },

    },
      // 请求完成（不管成功还是失败）都调用的回调函数
      async (err: BusinessError, data: http.HttpResponse) => {
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

          let list: List<object> = JSON.parse(data.result.toString())["data"];
          for (const item of list) {


            const httpRequest2 = http.createHttp()
            httpRequest2.request(GlobalVariable.server_ip+'/api/items/'+item['item_id'], {
              method: http.RequestMethod.GET,
              header: {
                'Content-Type': 'application/json',
                "Authorization": GlobalVariable.token,
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
                    return ;
                  }

                  let item: object = JSON.parse(data.result.toString())["data"];
                  let food: Food = {
                    id_: '',
                    publish_u_id: '',
                    own_u_id: '',
                    name: '',
                    people_want: '',
                    image_urls: '',
                    price: ''
                  };
                  food.price= item['price']
                  food.id_= item['id']
                  food.publish_u_id=''
                  food.own_u_id= ''
                  food.name= item['name']
                  food.people_want= item['people_want']
                  food.image_urls= String(item['image_urls']).includes("http") ? item['image_urls'] :
                    GlobalVariable.server_ip + item['image_urls']

                  this.dataList.push(food);

                  // 销毁请求对象
                  httpRequest.destroy()


                  return;
                }
                Toast.show(err.message)
                console.error(err.message);

              })
              // await this.fetchItemDetail(item['item_id'],food);


          }

          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })

    // 页面展示时读取“我买入的”商品数据
    // this.dataList = await DbUtil.queryFoodListMeBuy()
  }

  fetchItemDetail(item_id:string,): Food{

    let food: Food = {
      id_: '',
      publish_u_id: '',
      own_u_id: '',
      name: '',
      people_want: '',
      image_urls: '',
      price: ''
    }

    const httpRequest = http.createHttp()

    httpRequest.request(GlobalVariable.server_ip+'/api/items/'+item_id, {
      method: http.RequestMethod.GET,
      header: {
        'Content-Type': 'application/json',
        "Authorization": GlobalVariable.token,
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
            return ;
          }

          let item: object = JSON.parse(data.result.toString())["data"];

          food.price= item['price']
          food.id_= item['id']
          food.publish_u_id=''
          food.own_u_id= ''
          food.name= item['name']
          food.people_want= item['people_want']
          food.image_urls= item['image_urls']

          // 销毁请求对象
          httpRequest.destroy()


          return;
        }
        Toast.show(err.message)
        console.error(err.message);

      })

    return food;
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
      Row() {
        Text('我买入的')
          .fontSize(24)
          .padding(10)
          .fontWeight(FontWeight.Medium)
          .margin({ right: 10, top: 25, bottom: 10 })
      }
      .width('95%')
      Scroll() {
        this.bottomBuilder()
      }
      .height('100%')
      .scrollBar(BarState.Off)
      .padding(15)
      .backgroundColor('#0d000000')
    }

  }
}
