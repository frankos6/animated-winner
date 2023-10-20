#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <FS.h>
#include <Preferences.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>

#define DHTPIN 5
#define DHTTYPE DHT11
String serverName = "Some server name";
ESP8266WebServer server;
WiFiClient client;
int pin_led = D4;
String ssid = "desktop1";
String passwordd = "12345678";
DHT dht(DHTPIN,DHTTYPE);
float t=0.0;
float h = 0.0;
String username;
String password;

Preferences preferences;

void setup() {
  preferences.begin("esp");
  pinMode(pin_led,HIGH);
  Serial.begin(9600);

  WiFi.disconnect();
  randomSeed(analogRead(0));
  delay(10);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, passwordd);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.print("Successfully connected.");
  Serial.println("\nGot IP: ");  
  Serial.print(WiFi.localIP());
  if(MDNS.begin("esp8266")) {
    Serial.println("MDNS responder started");
  }
setAcces();
server.on("/data", []() {
  Serial.println("Serving /data");
  server.sendHeader("Access-Control-Allow-Origin", "*");
  username = preferences.getString("username","User");
  password = preferences.getString("password","User");
  
  String humstring = String(h);
  String tempstring=String(t);
  
  String json = "{\"Temperature\":\""  + tempstring + "\",\"Humidity\":\""+ h +"\", \"Username\":\""+username+"\",\"Password\":\""+password+"\"}";
  server.send(200, "application/json",json);
});
  server.on("/toggle",toggleLED);
  preferences.begin("esp82");
  
  server.begin();
  Serial.println("HTTP server started");
}

void loop() { 
  delay(10000);
  http.begin(client, serverName);
  //change server name !!!
  username = preferences.getString("username","User");
  password = preferences.getString("password","User");
  String postvalue = "username=" +username+"&password =" +password+"&t="+t+"&h="+h;
  //String httpRequestData = "api_key=tPmAT5Ab3j7F9&sensor=BME280&value1=24.25&value2=49.54&value3=1005.14";
  
  t=dht.readTemperature();
  h=dht.readHumidity();
  server.handleClient();
  MDNS.update();
}
void setAcces()
{
   username = preferences.getString("username","User");
   password = preferences.getString("password","User");
  Serial.println("====");
  Serial.println(username);
   if(username=="User")
  {
    Serial.println("1");
  HTTPClient http; //Object of class HTTPClient
    http.begin(client,"http://jsonplaceholder.typicode.com/users/1");
    int httpCode = http.GET();

    if (httpCode > 0) 
    {

  
      DynamicJsonDocument jsonBuffer(1024);
      deserializeJson(jsonBuffer,http.getString());
      Serial.println(http.getString());
      JsonObject root = jsonBuffer.as<JsonObject>();
       username = String(root["name"]); 
       password = String(root["username"]); 
    
    Serial.println(preferences.getString("password","User"));
    Serial.println("haslo");
    Serial.println(username);
    }
    
    http.end(); //Close connection

  }
  preferences.putString("username",username);
  preferences.putString("password",password);
  Serial.println("||||||");
  Serial.println(preferences.getString("username","User"));
  }
void toggleLED()
{
  digitalWrite(pin_led,!digitalRead(pin_led));
  setAcces();
  
  server.send(204,"");
}
