import { GlobalVariable } from "../util/GlobalVariable";
import Food, { FindItemBean, ItemType, MineItem, NavigationTabBean, TabBean } from "./modle";

// 项目中的静态数据集中管理，便于统一维护
class MyData {
  // 首页功能入口数据
  funcAreaList: Array<ItemType> = [
    {
      title: '数码产品',
      img: $r("app.media.func1")
    },
    {
      title: '辅导图书',
      img: $r('app.media.func2')
    },
    {
      title: '校园专区',
      img: $r('app.media.func3')
    },
    {
      title: '生活用品',
      img: $r('app.media.func4')
    },
    {
      title: '二次元',
      img: $r('app.media.func2')
    },
    {
      title: '书籍杂志',
      img: $r('app.media.func4')
    }
  ]
  // 底部导航栏展示数据
  bottomBeanList: Array<NavigationTabBean> = [
    {
      title: '首页',
      iconSelected: $r('app.media.house_fill'),
      iconNormal: $r('app.media.house_fill')
    },
    {
      title: '发布',
      iconSelected: $r('app.media.arrowshape_up_to_line_fill'),
      iconNormal: $r('app.media.arrowshape_up_to_line_fill')
    },
    {
      title: '',
      iconSelected: $r('app.media.mai'),
      iconNormal: $r('app.media.mai')
    },
    {
      title: '买入',
      iconSelected: $r("app.media.arrowshape_down_to_line_fill"),
      iconNormal: $r("app.media.arrowshape_down_to_line_fill")
    },
    {
      title: '我的',
      iconSelected: $r('app.media.person'),
      iconNormal: $r('app.media.person')
    },

  ]
  // 顶部频道标签数据
  topTabBeanList: Array<TabBean> = [
    { title: '关注' },
    { title: '推荐' },
    { title: '广场' },
    { title: '新发' },
  ]
  // 个人中心功能列表
  mineList: MineItem[] = [
    {
      img: $r('app.media.huiyuan'),
      name: '升级为会员',
      des: '黄金会员4级'
    },
    {
      img: $r("app.media.heart_normal"),
      name: '我的收藏',
      des: ''
    },
    {
      img: $r('app.media.pinglun'),
      name: '检查更新',
      des: ''
    },
    {
      img: $r('app.media.share'),
      name: '隐私政策',
      des: ''
    },
  ]
  // 底部导航高度
  MainBottomTabHeight = 80
  // 隐私政策正文内容
  PrivacyContentText = ''


  // 默认的首页商品数据，首次启动时用于填充数据库
  homeListData: Array<Food> = [

  ]
  // 图片占位资源
  detailImageUrl = GlobalVariable.server_ip+'/uploads/upload.png'
}

const v = new MyData()

export default v as MyData
