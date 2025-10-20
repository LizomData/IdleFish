import { ValuesBucket } from "@kit.ArkData";
// import { m as initData } from 'ohbuild';

// 商品数据结构，兼容 RDB 插入使用的 ValuesBucket
export default interface Food extends ValuesBucket {
  id_: string
  // 发布者用户 ID
  publish_u_id: string
  // 当前持有者用户 ID
  own_u_id: string
  // 商品名称或标题
  name: string
  // 想要人数或收藏量
  people_want: string
  // 商品图片地址
  image_urls: string
  // 商品现价
  price: string

}

export interface TabBean {
  // 标签标题
  title: string;
}

export interface NavigationTabBean {
  // tab 文案
  title: string;
  // 选中状态图标
  iconSelected: Resource;
  // 未选中状态图标
  iconNormal: Resource;
}

export interface ItemType {
  id?: number;
  title?: string | Resource;
  img?: string | Resource;
}

export class RouteParam {
  // 路由透传的业务数据
  content?: Object;
  // 返回时执行的回调
  onBack: ((data: PageBackParam ) => void )| undefined = undefined

}

export declare class PageBackParam{

}

export interface recommendListType {
  img: Resource
  title: string
  count: string
}

export interface recommendDailyType {
  img: Resource
  title: string
  type: string
  top: string
  bottom: string
}
// initData('secondTransaction')
export interface FindItemBean {
  // 发布者头像
  avatar: Resource
  // 商品封面或动态图片
  cover: Resource
  // 用户昵称
  name: string
  // 内容描述
  content: string
  // 用户等级
  level: number
}

export interface MineItem {
  // 列表项图标
  img: Resource,
  // 功能名称
  name: string,
  // 辅助描述
  des: string,
}
