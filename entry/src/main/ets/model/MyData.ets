import Food, { FindItemBean, ItemType, MineItem, NavigationTabBean, TabBean } from "./modle";

// 项目中的静态数据集中管理，便于统一维护
class MyData {
  // 首页功能入口数据
  funcAreaList: Array<ItemType> = [
    {
      title: '手机数码',
      img: $r("app.media.func1")
    },
    {
      title: '辅导图书',
      img: $r('app.media.func2')
    },
    {
      title: '学习文具',
      img: $r('app.media.func3')
    },
    {
      title: '九新服装',
      img: $r('app.media.func4')
    },
    {
      title: '二次元',
      img: $r('app.media.func5')
    },
    {
      title: '校园神券',
      img: $r('app.media.func5')
    }
  ]
  // 底部导航栏展示数据
  bottomBeanList: Array<NavigationTabBean> = [
    {
      title: '首页',
      iconSelected: $r('app.media.home0'),
      iconNormal: $r('app.media.home0')
    },
    {
      title: '发布',
      iconSelected: $r('app.media.maichu'),
      iconNormal: $r('app.media.maichu')
    },
    {
      title: '',
      iconSelected: $r('app.media.mai'),
      iconNormal: $r('app.media.mai')
    },
    {
      title: '买入',
      iconSelected: $r("app.media.mairu"),
      iconNormal: $r("app.media.mairu")
    },
    {
      title: '我的',
      iconSelected: $r('app.media.ic_mine'),
      iconNormal: $r('app.media.ic_mine')
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
      img: $r('app.media.ic_share'),
      name: '隐私政策',
      des: ''
    },
  ]
  // 底部导航高度
  MainBottomTabHeight = 80
  // 隐私政策正文内容
  PrivacyContentText =
    '1.本《隐私政策》适用于全民投票的全部产品和服务，包括H5网站、iOS端应用程序、安卓端应用程序等全部终端客户端。\n' +
      '\n' +
      '2.请您在使用各项产品和或服务前，仔细阅读并充分理解本隐私政策的全部内容。一旦您使用或继续使用我们的产品/服务，即表示您同意我们按照本隐私政策使用和处理您的相关信息。\n' +
      '\n' +
      '3.我们可能会不时依据法律法规或业务调整对本隐私政策进行修订。当本隐私政策发生变更后，我们会在此协议提示更新时间并向您展示变更后的内容。\n' +
      '\n' +
      '4.您需理解，只有在您确认并同意变更后的《隐私政策》，我们才会依据变更后的隐私政策收集、使用、处理和存储您的个人信息；您有权拒绝同意变更后的隐私政策，但请您知悉，一旦您拒绝同意变更后的隐私政策，可能导致您不能或不能继续完整使用全民投票的相关服务和功能，或者无法达到我们拟达到的服务效果。'


  // 默认的首页商品数据，首次启动时用于填充数据库
  homeListData: Array<Food> = [
    {
      id_: '0',
      publish_u_id: '',
      own_u_id: '',
      name: '南航空姐制服短袖短裙套装',
      people_want: '15',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i4/O1CN01fSpvfW1EWvdofw4nX_!!4611686018427383400-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '299',
    },
    {
      id_: '1',
      publish_u_id: '',
      own_u_id: '',
      name: '女大闲置出苹果5s，16g内存',
      people_want: '3',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i2/O1CN01V19W5h2M7IaCoZ6ZD_!!4611686018427382708-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '3500',
    },
    {
      id_: '2',
      publish_u_id: '',
      own_u_id: '',
      name: '出和泉纱雾t恤短袖cos服装大全套',
      people_want: '54',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i3/O1CN01N1maGE1iXmn6j707t_!!0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '160',
    },
    {
      id_: '3',
      publish_u_id: '',
      own_u_id: '',
      name: '全新《文城》余华作品平装',
      people_want: '9',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i2/O1CN01xAKf5C1xNS8SUj4Uz_!!4611686018427385103-53-fleamarket.heic_450x10000Q90.jpg_.webp',
      price: '18',
    },
    {
      id_: '4',
      publish_u_id: '',
      own_u_id: '',
      name: '泰式校服一套s 带裙子领带',
      people_want: '7',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i1/O1CN01XFCd2V1sszL5NRYfH_!!4611686018427386719-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '213',
    },
    {
      id_: '5',
      publish_u_id: '',
      own_u_id: '',
      name: '迪卡侬15L户外双肩包，适合徒步旅行',
      people_want: '1',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i3/O1CN01yjnZ3R1QTW4xhD7dN_!!4611686018427383897-53-fleamarket.heic_450x10000Q90.jpg_.webp',
      price: '122',
    },
    {
      id_: '6',
      publish_u_id: '',
      own_u_id: '',
      name: '捡漏M2芯片新款iPad Air6代原装内存',
      people_want: '1',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i3/O1CN01PLfQP81Sw1xsBvdW2_!!4611686018427380870-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '122',
    },
    {
      id_: '7',
      publish_u_id: '',
      own_u_id: '',
      name: '辣妹复古夏季低腰短裤全新没穿过吊牌在扣眼',
      people_want: '1',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i2/O1CN01RmfiZ21pFeTzvxq6W_!!4611686018427380467-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '140',
    },
    {
      id_: '8',
      publish_u_id: '',
      own_u_id: '',
      name: 'ader官方报童帽.全新带盒子带包装',
      people_want: '2',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i4/O1CN01dL2j6v1MKZt9xwkxW_!!4611686018427380584-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '180',
    },
    {
      id_: '9',
      publish_u_id: '',
      own_u_id: '',
      name: '全新几乎未穿的提臀裤，款式是肉色高腰提臀长裤',
      people_want: '1',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i2/O1CN01KFeVo82DFEt23NtiV_!!4611686018427382083-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '120',
    },
    {
      id_: '10',
      publish_u_id: '',
      own_u_id: '',
      name: '东航空姐制服短袖短裙套装',
      people_want: '4',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i3/O1CN014NJUXy1WSxHwNBcQt_!!4611686018427381812-0-fleamarket.jpg_450x10000Q90.jpg_.webp',
      price: '290',
    },
    {
      id_: '11',
      publish_u_id: '',
      own_u_id: '',
      name: '鸿蒙校园点餐项目源码含文档包运行成功',
      people_want: '35',
      image_urls: 'https://img.alicdn.com/bao/uploaded/i4/O1CN01onyeow1t5M2ekLhSu_!!4611686018427382442-53-fleamarket.heic_790x10000Q90.jpg_.webp',
      price: '170'
    },
  ]
  // 图片占位资源
  detailImageUrl = 'http://10.34.82.240:8800/uploads/upload.png'
}

const v = new MyData()

export default v as MyData
