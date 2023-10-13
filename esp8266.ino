#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>

ESP8266WebServer server;
int pin_led = D4;
String ssid = "desktop1";
String password = "12345678";




void setup() {
  pinMode(pin_led,HIGH);
  Serial.begin(115200);
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
  int rando = random(0,100);
  
  
  
  String smt=String(rando);
  
  String json = "{\"Temperature\":\""  + smt + "\""+"}";
  server.send(200, "application/json",json);
});
  server.on("/toggle",toggleLED);
  server.begin();
  Serial.println("HTTP server started");
}

void loop() { 
  server.handleClient();
  MDNS.update();
}
void toggleLED()
{
  digitalWrite(pin_led,!digitalRead(pin_led));
  server.send(204,"");
}
