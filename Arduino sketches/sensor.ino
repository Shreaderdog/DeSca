#include "ESP8266WiFi.h"

//
// Config
//

const char* ssid = "dd-wrt"; // Router name (dd-wrt)
const char* password = ""; // Router password

int port = 1025; // Web server port
int loopDelay = 200; // Delay of main loop (ms)

float minInital = 20.00; // Minimum possible initial value
float maxInitial = 80.00; // Maximum possible initial value
float minFluctuation = -0.80; // Minimum possible fluctuation
float maxFluctuation = 0.80; // Maximum possible fluctuation
float lowestValue = 0; // Lowest value possible
float highestValue = 100; // Highest value possible
int anomalyChance = 10; // Chance of an anomaly to occur (1/x chance)


//
// Functions for generating random integers/floats
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
float sensorValue = RandomFloat(minInital, maxInitial);
char *anomalies[5] = {"-69.42", "-6.25", "-6.67", "-103.53", "-999.99"};

void setup(void)
{
  Serial.begin(9600);
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  
  while (WiFi.status() != WL_CONNECTED) {
     delay(500);
     Serial.print("*");
  }
  
  Serial.println("\nWiFi connection Successful");
  Serial.print("The IP Address of ESP8266 Module is: " + WiFi.localIP().toString());

  wifiServer.begin();
}

void loop() 
{
  // Check if a client is connected to the server
  WiFiClient client = wifiServer.available();

  // If so, generate the sensor data and send to client
  if (client) {
    float flucuation = RandomFloat(minFluctuation, maxFluctuation);
    float newValue = sensorValue + flucuation;

    // Check if the sensor data is within the constraints
    if (lowestValue < newValue && newValue < highestValue) {
      sensorValue = newValue;
    }

    // Send the sensor data. Allow for a chance of an anomaly being sent
    if (RandomInt(1, anomalyChance) == 1) {
      client.print(String(anomalies[RandomInt(0, 4)]));
    } else {
      client.print(String(sensorValue));
    }
    client.stop();
  }
}