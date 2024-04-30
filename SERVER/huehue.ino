#include <WiFi.h>
#include "PubSubClient.h"
#define YELLOW_LED 12
#define GREEN_LED 14
#define BLUE_LED 26
#define RED_LED 27
#define IR 33

void togglePin(int pin) {
  digitalWrite(pin, !digitalRead(pin));
}
void toggleAll() {
  togglePin(YELLOW_LED);
  togglePin(GREEN_LED);
  togglePin(BLUE_LED);
  togglePin(RED_LED);
}

const char* mqttServer = "broker.emqx.io";
const char* mqttTopic = "nishant/again";
const int port = 1883;
char clientId[50];
const char* WifiSSID = "hiddentesla59";
const char* WifiPassword = "tesla123";
int LastIRState = LOW;

WiFiClient espClient;
PubSubClient client(espClient);

void setup() {
  Serial.begin(115200);
  pinMode(BLUE_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  pinMode(YELLOW_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(IR, INPUT);
  WifiConnect();
  client.setServer(mqttServer, port);
  client.setCallback(callback);
  LastIRState = digitalRead(IR);
}

void mqttReconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT (re)connection...");
    long r = random(1000);
    sprintf(clientId, "clientId-%ld", r);
    if (client.connect(clientId)) {
      Serial.print(clientId);
      Serial.println(" connected");
      client.subscribe(mqttTopic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(mqttTopic);
      delay(5000);
    }
  }
}

void callback(char* topic, byte* message, unsigned int length) {
  if (String(topic) != String(mqttTopic))
    return;
  
  String stMessage;
  
  for (int i = 0; i < length; i++) {
    stMessage += (char)message[i];
  }
  switch(stMessage.charAt(0)) {
    case 'b':
      togglePin(BLUE_LED);
      break;
    case 'r':
      togglePin(RED_LED);
      break;
    case 'y':
      togglePin(YELLOW_LED);
      break;
    case 'g':
      togglePin(GREEN_LED);
      break;
    default:
      break;
  }
}

void WifiConnect() {
  Serial.print("Connecting to WiFi");
  WiFi.begin(WifiSSID, WifiPassword, 6);
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }
  Serial.println(" Connected!");
}

void loop() {
  delay(100); // TODO: Build something amazing!
  if (!client.connected()) {
    mqttReconnect();
  }
  int CurrentIRState = digitalRead(IR);
  if (CurrentIRState != LastIRState) {
    toggleAll();
  }
  client.loop();
}
