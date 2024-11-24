import json
import time

import firebase_admin
import paho.mqtt.client as mqtt
from firebase_admin import credentials
from firebase_admin import firestore
from firebase_admin import messaging


def send_notification(parking, sensor, available):
    tokens = [
        "emScBmhUR3KC5M7LmDR3aQ:APA91bFV5mET0koSWhz5kJy6OGExYYbFg5eQnChaDppDgfh17t7tK7Ea93x8Bl-ltpQe8dmOfRNkZnYUjov4-FGU3g-oi9a9uHNteD09WExe0gwAMUUla6U",
        "fPWJi7uwRJiOws-myHOD0p:APA91bFaUXnBatAKh_T2XPZvNkSumlXqYmB-VZYwDe3l9QtEzhgSq2lTCej7Bc92MK9IC1GMkuIfT5SaZ3He7Ma7TeOu0NNTfNh7aC-dSi-u9wIOzdbvI1g"]

    for token in tokens:
        title = "Plaza disponible" if available else "Plaza ocupada"
        message = f"Plaza disponible en {parking}"
        # See documentation on defining a message payload.
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=message
            ),
            token=token,
        )

        # Send a message to the device corresponding to the provided
        # registration token.
        m = messaging.send(message)
        print(f"Notificacion enviada con {parking} {sensor} {available} {m}")


def mqtt_setup():
    # Configuración del broker y tema
    BROKER = "test.mosquitto.org"  # Puedes usar un broker público como este
    PUERTO = 1883  # Puerto por defecto para MQTT sin TLS
    TOPIC = "hackeps2024/#"

    def on_connect(client, userdata, flags, reasonCode, properties=None):
        print(f"Conexión exitosa al broker MQTT (ReasonCode: {reasonCode})")
        client.subscribe(TOPIC)

    def on_message(client, userdata, msg):  # The callback for when a PUBLISH
        try:
            print("Message received-> " + msg.topic + " " + str(msg.payload))
            payload = json.loads(msg.payload.decode("utf-8"))
            doc_ref = db.collection("parkings").document(payload["parking"]).collection("sensors").document(
                payload["sensor"])
            doc_ref.update({"timestamp": time.time(), "available": payload["value"] == 1})
            col_ref = db.collection("parkings").document(payload["parking"]).collection("sensors_historic")
            col_ref.add({"timestamp": time.time(), "available": payload["value"] == 1, "sensor": payload["sensor"]})

            send_notification(payload["parking"], payload["sensor"], payload["value"])
        except:
            pass

    # Crear client MQTT
    client = mqtt.Client(protocol=mqtt.MQTTv5)  # Usa el protocolo MQTT v5

    # Asignar callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    try:
        # Conectar al broker
        client.connect(BROKER, PUERTO, keepalive=60)

        # Iniciar el loop en segundo plano
        client.loop_forever()

    finally:
        # Detener el loop y desconectar
        client.loop_stop()
        client.disconnect()
        print("Desconexión exitosa")


if __name__ == '__main__':
    cred = credentials.Certificate("credentials.json")
    firebase_admin.initialize_app(cred)
    db = firestore.client()
    # mqtt_setup()

    for i in range(5):
        for j in range(25):
            docRef = db.collection("parkings").document(f"p{i + 1}")
            docRef.set({"name": f"Parking {i + 1}", "id":f"p{i + 1}"})
            docRef.collection("sensors").document(f"s{j + 1}").set(
                {"timestamp": time.time(), "available": True, "spot": j + 1})
