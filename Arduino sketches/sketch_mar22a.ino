/* Part of the web3 library we found */
#include <CaCert.h>
#include <Contract.h>
#include <Log.h>
#include <Util.h>
#include <Web3.h>

/* Enables wifi capabilities */
#include <WiFi.h>
#include <WiFiClient.h>
#include <WiFiServer.h>
#include <WiFiUdp.h>

/* Connects to wifi and sets up connection to blockchain client */
#define ENV_SSID     "dd-wrt"
#define ENV_WIFI_KEY ""
#define INFURA_HOST "rinkeby.infura.io"
#define INFURA_PATH "461bbf05596c4946a19bb81f6052b5be"

Web3 web3(INFURA_HOST, INFURA_PATH);    /* Initializes blockchain connection (error here) */

/* Prints out version of our web3 client */
web3.Web3ClientVersion(result);
USE_SERIAL.println(result);
