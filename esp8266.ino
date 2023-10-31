#include <ESP8266WebServer.h>
#include <ESP8266mDNS.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <Adafruit_Sensor.h>
#include <FS.h>
#include <Preferences.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <WiFiClient.h>
#include <ESP8266HTTPClient.h>
#include <base64.h>
#include <iostream>
#include <string>

#define DHTPIN 5
#define DHTTYPE DHT11
String serverName = "http://192.168.137.80:245";
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
using namespace std;

Preferences preferences;

void setup() {
  preferences.begin("esp");
  pinMode(pin_led,HIGH);
  Serial.begin(9600);
  WiFi.disconnect();

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
  username = preferences.getString("username","User");
  password = preferences.getString("password","User");
  String configuration = preferences.getString("minTemp","0");
  Serial.println("zzz");
  Serial.println(configuration);
  if(configuration=="0")
  {
    getconfiguration();
    
  }
  if(username=="User")
  {
    
    setAcces();
  }
  
  server.on("/toggle",toggleLED);
  server.on("/sim",sim);
  server.on("/clear", clearr);
  
  server.begin();
  Serial.println("HTTP server started");
}


void loop() { 
  int over = 0;
  String alertmessage;
  HTTPClient http;
  delay(10000);
    t=dht.readTemperature();
  h=dht.readHumidity();
  String humstring = String(h);
  String tempstring = String(t);
  String servnamedata = serverName+"/data";
  http.begin(client, servnamedata);

  username = preferences.getString("username","User");
  password = preferences.getString("password","User");

  String postvalue = username+":" +password;
  int overheat = preferences.getInt("maxTemp",100);
  int overcooling = preferences.getInt("minTemp",1);
  int overhum1 = preferences.getInt("maxHumidity",100);
  int overhum2 = preferences.getInt("minHumidity",1);


  String base64code = base64::encode(postvalue);

  Serial.println("DATA");
  Serial.println(t);
  Serial.println(h);
  Serial.println(overheat);
  Serial.println(overcooling);
  Serial.println(overhum1);
  Serial.println(overhum2);
  Serial.println(over);

  
  if(t>overheat  || t<overcooling || h>overhum1 || h<overhum2)
  {
    over= 1;  
    if(t>overheat || t<overcooling)
    {
      if(t>overheat)
      {
        alertmessage = "Temperature to High";
      }
      else{
        alertmessage = "Temperature to Low" ;
        }
    }
    else{
          if(h>overhum1)
          {
            alertmessage = "Humidity to High";  
          }
          else
          {
            alertmessage = "Humidity to Low";  
          }
      
      }
  }
 Serial.println(alertmessage);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("Authorization","Basic " + base64code);
  int httpResponseCode = http.POST("{\"Alertmessage\":\""  + alertmessage+"\"}");

    Serial.println(httpResponseCode);
    Serial.println("Sended");
    
  http.end();
  Serial.println("Over");
  Serial.println(over);
  Serial.println(preferences.getString("SimulateOverHeat","false"));
  if(over==1 || preferences.getString("SimulateOverHeat","false")=="True")
  {
    if(preferences.getString("SimulateOverHeat","false")=="True")
    {
      alertmessage = "Simulated overheat alert";
      preferences.putString("SimulateOverHeat","false");
    }
    sendalert(alertmessage,base64code);

    
      http.end();
  }
  server.handleClient();
  MDNS.update();
  over=0; 
}




void setAcces()
{
   username = preferences.getString("username","User");
   password = preferences.getString("password","User");
   Serial.println("====");
   Serial.println(username);
   String postvalue = username+":" +password;
   String base64code = base64::encode(postvalue);
    Serial.println("1");
    HTTPClient http;




    http.begin(client,"http://192.168.137.80:245/device/register");
    DynamicJsonDocument jsonBuffer(1024);
    http.addHeader("Content-Type", "application/json");
    http.POST("{\"Key\":\"value\"}");
      
      deserializeJson(jsonBuffer,http.getString());
      Serial.println(http.getString());
      JsonObject root = jsonBuffer.as<JsonObject>();
       username = String(root["username"]); 
       Serial.print("To syn j");
       Serial.println(root);
       password = String(root["password"]); 

    Serial.println(preferences.getString("password","User"));
    Serial.println("haslo");
    Serial.println(username);
    
    http.end(); //Close connection
  
  preferences.putString("username",username);
  preferences.putString("password",password);
  Serial.println("||||||");
  Serial.println(preferences.getString("username","User"));
  }
  
  void getconfiguration(){
    HTTPClient http;

     username = preferences.getString("username","User");
     password = preferences.getString("password","User");
     Serial.println(username);
     String postvalue = username+":" +password;
     String base64code = base64::encode(postvalue);

    http.begin(client,"http://192.168.137.80:245/config");
    http.addHeader("Authorization","Basic " + base64code);
     DynamicJsonDocument configuration(1024);
     int code = http.GET();
     if(code=200)
     {
      deserializeJson(configuration,http.getString());
      Serial.println(http.getString());
      JsonObject root2 = configuration.as<JsonObject>();
       String mintemp = String(root2["minTemp"]); 
       Serial.print("To syn j2");
       Serial.println(root2);
       preferences.putString("maxTemp",String(root2["maxTemp"])); 
       preferences.putString("minTemp", String(root2["frequency"]));
       preferences.putString("minHumidity",String(root2["minHumidity"]));
       preferences.putString("maxHumidity",String(root2["maxHumidity"]));
       
      
      }
      else{
        basiconfig();
        }
      http.end();
    }
void toggleLED()
{
  digitalWrite(pin_led,!digitalRead(pin_led));
  setAcces();
  
  server.send(204,"");
}


void sendalert(String alertmessage, String base64code){
    HTTPClient http;
      String alertserv = serverName + "/alert"; 
      http.begin(client,alertserv);
      http.addHeader("Content-Type", "application/json");
      http.addHeader("Authorization","Basic " + base64code);
      int httpResponseCode = http.POST("\""+alertmessage+"\"");

    Serial.println(httpResponseCode);
    Serial.println("Sended2");
    http.end();
  
  }

  
void sim(){
  preferences.putString("SimulateOverHeat","True");
  Serial.println("Overheat");
  Serial.println(preferences.getString("SimulateOverHeat","false"));
  }

  
void clearr(){

    Serial.println("Cleared");
  } 

  
void basiconfig(){
      preferences.putInt("maxTemp",100);
    preferences.putInt("minTemp",1);
    preferences.putInt("maxHumidity",100);
    preferences.putInt("minHumidity",1);
  
  }
 
