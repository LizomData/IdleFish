// 简单的 Toast 封装，统一提示样式
import { promptAction } from '@kit.ArkUI'

class Toast {
  // 展示短提示信息，默认持续 1 秒
  show(s: string) {
    promptAction.showToast({
      message: s,
      duration: 1000,
      bottom: '360vp'
    })
  }
}

let toast = new Toast()

export default toast as Toast
