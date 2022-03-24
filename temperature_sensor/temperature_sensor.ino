#include "ESP8266WiFi.h"

//
// Config
//

const char* ssid = "dd-wrt"; // Router name (dd-wrt)
const char* password = ""; // Router password

int port = 1025; // Web server port
int loopDelay = 200; // Delay of main loop (ms)

float minInital = 20.00; // Minimum possible initial value of temperature
float maxInitial = 90.00; // Maximum possible initial value of temperature
float minFluctuation = -0.30; // Minimum possible fluctuation of the temperature
float maxFluctuation = 0.30; // Maximum possible fluctuation of the temperature
int anomalyChance = 5; // Chance of an anomaly to occur (1/x chance)

//
//
//

int RandomInt(int a, int b) {
    return rand() % ((b - a) + 1) + a;
}

float RandomFloat(float a, float b) {
    float random = ((float) rand()) / (float) RAND_MAX;
    float diff = b - a;
    float r = random * diff;
    return a + r;
}

WiFiServer wifiServer(port);
float temp = RandomFloat(minInital, maxInitial);
char *anomalies[4] = {"test", "11111111111", "-334234", "@@#$^^$"};

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

  if (client) {
    temp += RandomFloat(minFluctuation, maxFluctuation);
    
    if (RandomInt(1, anomalyChance) == 1) {
      client.println(String(anomalies[RandomInt(0, 3)]));
    } else {
      client.println(String(temp));
    }
    client.stop();
  }
}
