#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>

#define DHTPIN 5
#define DHTTYPE DHT11

ESP8266WebServer server;
int pin_led = D4;
String ssid = "desktop1";
String password = "12345678";
DHT dht(DHTPIN,DHTTYPE);
float t=0.0;
float h = 0.0;



void setup() {
  
  
  pinMode(pin_led,HIGH);
  Serial.begin(9600);

  WiFi.disconnect();
  randomSeed(analogRead(0));
  delay(10);
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
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
server.on("/data", []() {
  Serial.println("Serving /data");
  server.sendHeader("Access-Control-Allow-Origin", "*");
  String humstring = String(h);
  String tempstring=String(t);
  
  String json = "{\"Temperature\":\""  + tempstring + "\",\"Humidity\":\""+ h +"\"}";
  server.send(200, "application/json",json);
});
  server.on("/toggle",toggleLED);
  server.begin();
  Serial.println("HTTP server started");
}

void loop() { 
  t=dht.readTemperature();
  h=dht.readHumidity();
  server.handleClient();
  MDNS.update();
}
void toggleLED()
{
  digitalWrite(pin_led,!digitalRead(pin_led));
  server.send(204,"");
}
