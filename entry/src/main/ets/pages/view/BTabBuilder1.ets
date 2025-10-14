// 底部导航公共构建器，负责渲染单个 tab
import MyData from "../../model/MyData"

@Component
export struct BTabBuilder1 {
  // 当前选中的 tab 索引，由外部控制
  @State curIndex: number = 0
  // 当前构建器对应的索引
  @State index: number = 0

  build() {
    Column() {
      // 根据是否选中切换图标资源
      Image(this.curIndex == this.index ? MyData.bottomBeanList[this.index].iconSelected :
      MyData.bottomBeanList[this.index].iconNormal)
        .width(21)
        .height(21)
      // tab 标题区域
      Text(MyData.bottomBeanList[this.index].title)
        .fontColor(Color.White)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 4 })
    }.layoutWeight(1)
    .onClick(()=>{

    })
  }
}
