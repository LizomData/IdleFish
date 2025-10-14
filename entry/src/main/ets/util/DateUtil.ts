class DateUtil {

  // 返回当前时间戳，单位毫秒
  getMs() {
    return new Date().getTime()
  }

  // 生成以日期时间组成的订单号，确保唯一性
  generateOrderCode() {
    var date = new Date();
    var year = date.getFullYear();
    var month = this.padZero(date.getMonth() + 1);
    var day = this.padZero(date.getDate());
    var hours = this.padZero(date.getHours());
    var minutes = this.padZero(date.getMinutes());
    var seconds = this.padZero(date.getSeconds());

    return `c${year}${month}${day}${hours}${minutes}${seconds}`;
  }

  // 返回当前时间的格式化字符串
  generateDateStr() {
    return this.formatDate(new Date())
  }

  // 按指定格式输出日期时间：yyyy-MM-dd HH:mm:ss
  formatDate(date: Date) {
    var year = date.getFullYear();
    var month = this.padZero(date.getMonth() + 1);
    var day = this.padZero(date.getDate());
    var hours = this.padZero(date.getHours());
    var minutes = this.padZero(date.getMinutes());
    var seconds = this.padZero(date.getSeconds());

    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  // 不足两位的数字补零
  private padZero(num) {
    return num < 10 ? '0' + num : num;
  }
}

var dateUtil = new DateUtil()

export default dateUtil as DateUtil


