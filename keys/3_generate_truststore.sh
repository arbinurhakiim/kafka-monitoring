#!/bin/bash

# Add -storetype PKCS12 to ensure the truststore is in the correct format
keytool -importcert -keystore artifacts/kafka.truststore.jks -alias CARoot -file artifacts/ca.crt -storepass YourStrongPassword! -noprompt -storetype PKCS12

keytool -exportcert -keystore artifacts/kafka.truststore.jks -alias CARoot -rfc -file artifacts/ca.pem -storepass YourStrongPassword! -storetype PKCS12