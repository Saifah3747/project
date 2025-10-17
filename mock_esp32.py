import time
import json
import random
import paho.mqtt.client as mqtt

MQTT_BROKER = 'broker.hivemq.com'
MQTT_PORT = 8000   # WebSocket
MQTT_TOPIC = 'locker/1/status'

client = mqtt.Client(transport='websockets')
client.connect(MQTT_BROKER, MQTT_PORT, 60)
client.loop_start()

RFIDS = ['RFID001', 'RFID002', 'RFID999']

while True:
    rfid = random.choice(RFIDS)
    print('Scanning RFID:', rfid)

    if rfid in ['RFID001','RFID002']:
        payload = json.dumps({
            'locker_id': 1,
            'status': 'in_use',
            'user': 'UserA' if rfid=='RFID001' else 'UserB',
            'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
        })
    else:
        payload = json.dumps({
            'locker_id': 1,
            'status': 'error',
            'user': 'Unknown',
            'timestamp': time.strftime('%Y-%m-%d %H:%M:%S')
        })

    client.publish(MQTT_TOPIC, payload)
    print('Published:', payload)
    time.sleep(5)
