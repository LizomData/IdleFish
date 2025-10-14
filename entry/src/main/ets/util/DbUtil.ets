// 数据库工具类，封装商品增删改查逻辑
import { preferences, relationalStore, ValuesBucket } from '@kit.ArkData';
import { AsyncCallback, BusinessError } from '@kit.BasicServicesKit';
import Food from '../model/modle';
import MyData from '../model/MyData';
import PreferenceUtil from './PreferencesUtil';

class DbUtil {
  // 数据库配置，包括名称与安全级别
  private STORE_CONFIG: relationalStore.StoreConfig = {
    name: "MARKET.db",
    securityLevel: relationalStore.SecurityLevel.S1
  };
  // 全局缓存的 RdbStore 实例
  private rdbStore?: relationalStore.RdbStore
  // 表名与建表语句
  private TABLE_CART = 'TABLE_GOODS'
  private SQL_CREATE_CART = `create table if not exists ${this.TABLE_CART} (
        id integer primary key autoincrement,
        id_ text,
        publish_u_id text,
        own_u_id text,
        name text,
        want_count text,
        icon_url text,
        now_price text
      )`

  // 初始化数据库连接，应用启动时调用
  init(context: Context) {
    relationalStore.getRdbStore(context, this.STORE_CONFIG,
      (err: BusinessError, rdbStore: relationalStore.RdbStore) => {
        this.rdbStore = rdbStore
        rdbStore.executeSql(this.SQL_CREATE_CART,
          async (err) => {
            console.log(`zushiyekeji Food 创建数据库 err=${err}`)
            this.err = err
            // 初始化默认数据，避免空表
            this.initData()
          })
      })
  }

  err: object | undefined | void = undefined

  async initData() {
    if (!this.err) {
      let c = await this.getTotalCount()
      if (c <= 0) {
        // 首次启动时将默认数据写入数据库
        this.batchInsertFood(MyData.homeListData)
      }
    }
  }

  // 新增单条
  async insertFood(value: Food) {
    const rowId = await this.rdbStore?.insert(this.TABLE_CART, value)
    console.log('zushiyekeji Food 增 rowId=' + rowId)
    return (rowId && rowId > -1) ? Promise.resolve(rowId) : Promise.reject('insert error')
  }

  // 批量新增
  async batchInsertFood(values: Food[]) {
    const rowId = await this.rdbStore?.batchInsert(this.TABLE_CART, values)
    console.log('zushiyekeji Food 批量增 rowId=' + rowId)
    return rowId ? Promise.resolve(rowId) : Promise.reject('batchInsert error')
  }

  // 更新
  async updateFood(item: Food) {
    if (!item.id_) {
      return Promise.reject('id error')
    }
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.equalTo('id_', item.id_)
    const rowCount = await this.rdbStore?.update(item, predicates)
    console.log('zushiyekeji Food 改 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('update error')
  }

  // 删除
  async deleteFood(id_: string) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.equalTo('id_', id_)
    const rowCount = await this.rdbStore?.delete(predicates)
    console.log('zushiyekeji Food 删 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('delete error')
  }

  // 批量删除
  async batchDeleteFood(ids: string[]) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    predicates.in('id_', ids)
    const rowCount = await this.rdbStore?.delete(predicates)
    console.log('zushiyekeji Food 批量删 rowCount=' + rowCount)
    return rowCount ? Promise.resolve(rowCount) : Promise.reject('delete error')
  }

  async getTotalCount(): Promise<number> {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    //predicates.like('name', name)
    const resultSet = await this.rdbStore?.query(predicates)
    const list: Food[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        publish_u_id: resultSet.getString(resultSet.getColumnIndex('publish_u_id')),
        own_u_id: resultSet.getString(resultSet.getColumnIndex('own_u_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        want_count: resultSet.getString(resultSet.getColumnIndex('want_count')),
        icon_url: resultSet.getString(resultSet.getColumnIndex('icon_url')),
        now_price: resultSet.getString(resultSet.getColumnIndex('now_price')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询所有 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list.length
  }

  // 查询
  async queryFoodListByName(name: string) {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    predicates.contains('name', name)
    const resultSet = await this.rdbStore?.query(predicates)
    const list: Food[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        publish_u_id: resultSet.getString(resultSet.getColumnIndex('publish_u_id')),
        own_u_id: resultSet.getString(resultSet.getColumnIndex('own_u_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        want_count: resultSet.getString(resultSet.getColumnIndex('want_count')),
        icon_url: resultSet.getString(resultSet.getColumnIndex('icon_url')),
        now_price: resultSet.getString(resultSet.getColumnIndex('now_price')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food like查询 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }

  // 查询
  async queryFoodListMeBuy() {
    // 读取当前登录用户，仅查询属于自己的 “买入” 数据
    let user_id: preferences.ValueType = await PreferenceUtil.getPreferenceValue('user_name', '')
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    if (user_id) {
      predicates.equalTo('own_u_id', user_id.toString())
    }
    const resultSet = await this.rdbStore?.query(predicates)
    const list: Food[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        publish_u_id: resultSet.getString(resultSet.getColumnIndex('publish_u_id')),
        own_u_id: resultSet.getString(resultSet.getColumnIndex('own_u_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        want_count: resultSet.getString(resultSet.getColumnIndex('want_count')),
        icon_url: resultSet.getString(resultSet.getColumnIndex('icon_url')),
        now_price: resultSet.getString(resultSet.getColumnIndex('now_price')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询我买的 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }


  // 发布查询
  async queryFoodListMePublish() {
    // 查询当前用户发布的商品列表
    let user_id: preferences.ValueType = await PreferenceUtil.getPreferenceValue('user_name', '')
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    //predicates.orderByDesc('date_added')
    // 如果有 id
    if (user_id) {
      predicates.equalTo('publish_u_id', user_id.toString())
    }
    const resultSet = await this.rdbStore?.query(predicates)
    const list: Food[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        publish_u_id: resultSet.getString(resultSet.getColumnIndex('publish_u_id')),
        own_u_id: resultSet.getString(resultSet.getColumnIndex('own_u_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        want_count: resultSet.getString(resultSet.getColumnIndex('want_count')),
        icon_url: resultSet.getString(resultSet.getColumnIndex('icon_url')),
        now_price: resultSet.getString(resultSet.getColumnIndex('now_price')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询我买的 list=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }

  // 查询
  async queryFoodList() {
    const predicates = new relationalStore.RdbPredicates(this.TABLE_CART)
    // 添加日期倒序排列
    predicates.orderByDesc('id')
    // 如果有 id
    // if (id_) {
    //   predicates.equalTo('id_', id_)
    // }
    const resultSet = await this.rdbStore?.query(predicates)
    const list: Food[] = []
    while (resultSet && resultSet.goToNextRow()) {
      // 获取数据
      const data: Food = {
        id_: resultSet.getString(resultSet.getColumnIndex('id_')),
        publish_u_id: resultSet.getString(resultSet.getColumnIndex('publish_u_id')),
        own_u_id: resultSet.getString(resultSet.getColumnIndex('own_u_id')),
        name: resultSet.getString(resultSet.getColumnIndex('name')),
        want_count: resultSet.getString(resultSet.getColumnIndex('want_count')),
        icon_url: resultSet.getString(resultSet.getColumnIndex('icon_url')),
        now_price: resultSet.getString(resultSet.getColumnIndex('now_price')),

      }
      // 追加到数组中
      list.push(data)
    }
    console.log('zushiyekeji Food 查询所有 list2=' + JSON.stringify(list))
    // 释放资源
    resultSet?.close()
    return list
  }
}

let util2 = new DbUtil()

export default util2 as DbUtil
