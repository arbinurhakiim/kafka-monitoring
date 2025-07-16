#!/bin/bash

echo "------------------------------------------"
echo "GENERATING KEYSTORE FOR 1ST BROKER"
echo "------------------------------------------"
# Create the keystore for broker 1
keytool -genkeypair -keystore artifacts/kafka-broker1.keystore.jks -alias broker1 -keyalg RSA -validity 365 -storepass YourStrongPassword! -keypass YourStrongPassword! -dname "CN=kafka-1" -storetype PKCS12 -ext "SAN=dns:kafka-1,dns:localhost"
# Create a certificate signing request (CSR) for broker 1
keytool -certreq -keystore artifacts/kafka-broker1.keystore.jks -alias broker1 -file artifacts/broker1.csr -storepass YourStrongPassword!
# Sign the CSR with your CA
openssl x509 -req -in artifacts/broker1.csr -CA artifacts/ca.crt -CAkey artifacts/ca.key -CAcreateserial -out artifacts/broker1-signed.crt -days 365 -extfile <(printf "subjectAltName=DNS:kafka-1,DNS:localhost")
# Import the CA's certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker1.keystore.jks -alias CARoot -file artifacts/ca.crt -storepass YourStrongPassword! -noprompt
# Import the signed certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker1.keystore.jks -alias broker1 -file artifacts/broker1-signed.crt -storepass YourStrongPassword!

echo "------------------------------------------"
echo "GENERATING KEYSTORE FOR 2ND BROKER"
echo "------------------------------------------"
# Create the keystore for broker 2
keytool -genkeypair -keystore artifacts/kafka-broker2.keystore.jks -alias broker2 -keyalg RSA -validity 365 -storepass YourStrongPassword! -keypass YourStrongPassword! -dname "CN=kafka-2" -storetype PKCS12 -ext "SAN=dns:kafka-2,dns:localhost"
# Create a certificate signing request (CSR) for broker 2
keytool -certreq -keystore artifacts/kafka-broker2.keystore.jks -alias broker2 -file artifacts/broker2.csr -storepass YourStrongPassword!
# Sign the CSR with your CA
openssl x509 -req -in artifacts/broker2.csr -CA artifacts/ca.crt -CAkey artifacts/ca.key -CAcreateserial -out artifacts/broker2-signed.crt -days 365 -extfile <(printf "subjectAltName=DNS:kafka-2,DNS:localhost")
# Import the CA's certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker2.keystore.jks -alias CARoot -file artifacts/ca.crt -storepass YourStrongPassword! -noprompt
# Import the signed certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker2.keystore.jks -alias broker2 -file artifacts/broker2-signed.crt -storepass YourStrongPassword!

echo "------------------------------------------"
echo "GENERATING KEYSTORE FOR 3RD BROKER"
echo "------------------------------------------"
# Create the keystore for broker 3
keytool -genkeypair -keystore artifacts/kafka-broker3.keystore.jks -alias broker3 -keyalg RSA -validity 365 -storepass YourStrongPassword! -keypass YourStrongPassword! -dname "CN=kafka-3" -storetype PKCS12 -ext "SAN=dns:kafka-3,dns:localhost"
# Create a certificate signing request (CSR) for broker 3
keytool -certreq -keystore artifacts/kafka-broker3.keystore.jks -alias broker3 -file artifacts/broker3.csr -storepass YourStrongPassword!
# Sign the CSR with your CA
openssl x509 -req -in artifacts/broker3.csr -CA artifacts/ca.crt -CAkey artifacts/ca.key -CAcreateserial -out artifacts/broker3-signed.crt -days 365 -extfile <(printf "subjectAltName=DNS:kafka-3,DNS:localhost")
# Import the CA's certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker3.keystore.jks -alias CARoot -file artifacts/ca.crt -storepass YourStrongPassword! -noprompt
# Import the signed certificate into the broker's keystore
keytool -importcert -keystore artifacts/kafka-broker3.keystore.jks -alias broker3 -file artifacts/broker3-signed.crt -storepass YourStrongPassword!

echo "------------------------------------------"
echo "CLEANING UP CSR AND SIGNED CRT..."
echo "------------------------------------------"
rm "artifacts/broker1.csr"
rm "artifacts/broker1-signed.crt"
rm "artifacts/broker2.csr"
rm "artifacts/broker2-signed.crt"
rm "artifacts/broker3.csr"
rm "artifacts/broker3-signed.crt"
rm "artifacts/kafka-exporter.csr"
rm "artifacts/python-consumer.csr"
rm "artifacts/python-producer.csr"

echo "------------------------------------------"
echo "GENERATING CERTIFICATE AND PRIVATE KEY FOR KAFKA-EXPORTER"
echo "------------------------------------------"
openssl genrsa -out "artifacts/kafka-exporter.key" 2048
openssl req -new -key "artifacts/kafka-exporter.key" -out "artifacts/kafka-exporter.csr" -subj "/CN=kafka-exporter"
openssl x509 -req -in "artifacts/kafka-exporter.csr" \
    -CA "artifacts/ca.crt" \
    -CAkey "artifacts/ca.key" \
    -CAcreateserial \
    -CAserial "artifacts/ca.srl" \
    -out "artifacts/kafka-exporter.crt" \
    -days "365"
rm "artifacts/kafka-exporter.csr"

echo "------------------------------------------"
echo "GENERATING CERTIFICATE AND PRIVATE KEY FOR PYTHON CONSUMER"
echo "------------------------------------------"
openssl genrsa -out "artifacts/python-consumer.key" 2048
openssl req -new -key "artifacts/python-consumer.key" -out "artifacts/python-consumer.csr" -subj "/CN=python-consumer"
openssl x509 -req -in "artifacts/python-consumer.csr" \
    -CA "artifacts/ca.crt" \
    -CAkey "artifacts/ca.key" \
    -CAcreateserial \
    -CAserial "artifacts/ca.srl" \
    -out "artifacts/python-consumer.crt" \
    -days "365"
rm "artifacts/python-consumer.csr"

echo "------------------------------------------"
echo "GENERATING CERTIFICATE AND PRIVATE KEY FOR PYTHON PRODUCER"
echo "------------------------------------------"
openssl genrsa -out "artifacts/python-producer.key" 2048
openssl req -new -key "artifacts/python-producer.key" -out "artifacts/python-producer.csr" -subj "/CN=python-producer"
openssl x509 -req -in "artifacts/python-producer.csr" \
    -CA "artifacts/ca.crt" \
    -CAkey "artifacts/ca.key" \
    -CAcreateserial \
    -CAserial "artifacts/ca.srl" \
    -out "artifacts/python-producer.crt" \
    -days "365"
rm "artifacts/python-producer.csr"