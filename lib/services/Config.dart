class Config{
  static String ip = "http://192.168.0.227:245";
  ///bgt ip: 3.66.89.22

  void setIp(String newIp){
    ip = "http://$newIp:245";
  }
}