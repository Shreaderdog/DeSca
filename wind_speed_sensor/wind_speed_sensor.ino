#include "ESP8266WiFi.h"

const char* ssid = "dd-wrt"; //Enter SSID
const char* password = ""; //Enter Password

WiFiServer wifiServer(80);

void setup(void)
{ 
  Serial.begin(9600);
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) 
  {
     delay(500);
     Serial.print("*");
  }
  
  Serial.println("\nWiFi connection Successful");
  Serial.print("The IP Address of ESP8266 Module is: " + WiFi.localIP().toString());

  wifiServer.begin();
}

void loop() 
{
  WiFiClient client = wifiServer.available();

  // while a client is connected this section is only ran once... initally. So this is ran synchronously
  
  if (client) {
    // need to do further testing on:
    // - where to put sensor data generation code
    // - could this all be ran asynchronously?
    while (client.connected()) {
      client.println("hello world");
      
      delay(10);
    }
    client.stop();
  }
}
