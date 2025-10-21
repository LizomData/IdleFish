// 顶部引入页面中使用到的所有片段以及工具类，确保组件可以独立渲染
import { HomeFragment } from './fragment/HomeFragment'
import emitter from '@ohos.events.emitter'
import router from '@ohos.router'
import { NavigationTabBean } from '../model/modle'
import MyData from '../model/MyData'
import { BTabBuilder1 } from './view/BTabBuilder1'
import DbUtil from '../util/DbUtil'
import { SellFragment } from './fragment/SellFragment'
import { BuyFragment } from './fragment/BuyFragment'
import { MineFragment } from './fragment/MineFragment'
import { PublishFragment } from './fragment/PublishFragment'

// 页面路由常量，供其它模块跳转到首页使用
export let Path_Main = 'pages/MainPage'

@Preview
@Entry
@Component
struct MainPage {
  // 当前底部导航栏选中的索引，默认展示首页
  @State curIndex: number = 0

  // 页面展示后触发的生命周期回调，可用于懒加载或事件订阅
  async onPageShow() {

  }

  // 统一处理底部导航点击事件，切换当前的片段索引
  async onTabClick(index: number) {
    this.curIndex = index

    // if (index == 0) {
    //   await DbUtil.insertFood(MyData.homeListData[0])
    // }
    // if (index == 1) {
    //   let a = await DbUtil.queryFoodList()
    // }
  }

  // 中间悬浮发布按钮的构建器，单独抽取便于复用及位置管理
  @Builder
  MTabBuilder() {
    Column() {
      Image($r('app.media.mai'))
        .width(70)
        .height(70)
        .margin({ left: 3, bottom: 6 })
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .borderRadius({ topLeft: 40, topRight: 40 })
    .borderWidth(0.5)
    .borderColor(Color.White)
    .backgroundColor(Color.White)
    .padding({ bottom: 20 })
    .onClick(() => {
      this.onTabClick(2)
    })
  }

  build() {
    // 使用堆叠布局，让底部导航覆盖在内容片段之上
    Stack() {

      Column() {
        // 根据索引切换展示的片段，保持页面状态单一来源
        if (this.curIndex == 0) {
          HomeFragment()
        } else if (this.curIndex == 1) {
          SellFragment()
        } else if (this.curIndex == 2) {
          PublishFragment()
        } else if (this.curIndex == 3) {
          BuyFragment()
        } else if (this.curIndex == 4) {
          MineFragment()
        }
      }.height('100%')

      // 底部导航栏区域，使用 Row 平铺五个按钮
      Row() {
        Column() {
          // 首页 tab，选中状态下使用高亮图标
          Image(this.curIndex == 0 ? MyData.bottomBeanList[0].iconSelected :
          MyData.bottomBeanList[0].iconNormal)
            .width(21)
            .height(21)
            .backgroundColor(this.curIndex == 0 ? $r('app.color.zhuti') : null)
            .borderRadius(20)
          Text(MyData.bottomBeanList[0].title)
            .fontColor(this.curIndex == 0 ? Color.Black : Color.Black)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .padding({ top: 5, bottom: 5 })
        .onClick(() => {
          // 点击切换至首页
          this.onTabClick(0)
        })
        .padding({ top: 5, bottom: 20 })

        Column() {
          // 发布 tab，突出显示选中态
          Image(this.curIndex == 1 ? MyData.bottomBeanList[1].iconSelected :
          MyData.bottomBeanList[1].iconNormal)
            .width(21)
            .height(21).backgroundColor(this.curIndex == 1 ? $r('app.color.zhuti') : null)
            .borderRadius(10)
          Text(MyData.bottomBeanList[1].title)
            .fontColor(this.curIndex == 1 ? Color.Black : Color.Black)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .padding({ top: 5, bottom: 5 })
        .onClick(() => {
          // 跳转至发布列表
          this.onTabClick(1)
        })
        .padding({ top: 5, bottom: 20 })

        /**
         * 中间
         */
        this.MTabBuilder()

        Column() {
          // 买入 tab，展示已购商品
          Image(this.curIndex == 3 ? MyData.bottomBeanList[3].iconSelected :
          MyData.bottomBeanList[3].iconNormal)
            .width(21)
            .height(21)
            .backgroundColor(this.curIndex == 3 ? $r('app.color.zhuti') : null)
            .borderRadius(10)
          Text(MyData.bottomBeanList[3].title)
            .fontColor(this.curIndex == 3 ? Color.Black : Color.Black)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .padding({ top: 5, bottom: 5 })
        .onClick(() => {
          // 切换到买入记录
          this.onTabClick(3)
        })
        .padding({ top: 5, bottom: 20 })

        Column() {
          // 我的 tab，显示个人中心
          Image(this.curIndex == 4 ? MyData.bottomBeanList[4].iconSelected :
          MyData.bottomBeanList[4].iconNormal)
            .width(21)
            .height(21)
            .backgroundColor(this.curIndex == 4 ? $r('app.color.zhuti') : null)
            .borderRadius(10)
          Text(MyData.bottomBeanList[4].title)
            .fontColor(this.curIndex == 4 ? Color.Black : Color.Black)
            .fontSize(13)
            .fontWeight(FontWeight.Medium)
            .margin({ top: 4 })
        }
        .backgroundColor(Color.White)
        .layoutWeight(1)
        .padding({ top: 5, bottom: 5 })
        .onClick(() => {
          // 进入个人中心
          this.onTabClick(4)
        })
        .padding({ top: 5, bottom: 20 })
      }
      .width('100%')
      //.margin({bottom:20})
      .backgroundColor(Color.Transparent)
      .alignItems(VerticalAlign.Bottom)
    }
    .height('100%')
    .width('100%')
    .alignContent(Alignment.Bottom)
    .backgroundColor('#fff1f1f1')

  }
}
