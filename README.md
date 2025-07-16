# kafka-monitoring

This project aims to provide a proper monitoring platform on a Kafka node, with SSL security implementation to ensure a more secure Kafka cluster.

---

### **How to run:**

1.  **Create a virtual environment and install dependencies:**
    It is recommended to use a virtual environment to manage the project's dependencies.
    ```bash
    python3 -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    ```

2.  **Generate Certificates and Keys:**
    Run the following scripts in the `keys` folder in order. These scripts will generate the necessary SSL certificates and keys for securing your Kafka cluster.

    * `1_generate_ca.sh`: This script creates a new Certificate Authority (CA) which will be used to sign the certificates for the Kafka brokers and clients.
        ```bash
        bash keys/1_generate_ca.sh
        ```

    * `2_generate_keystore.sh`: This script generates the keystores for each of the three Kafka brokers. It also creates certificates for the `kafka-exporter`, and the Python producer and consumer.
        ```bash
        bash keys/2_generate_keystore.sh
        ```

    * `3_generate_truststore.sh`: This script creates a truststore that contains the CA's certificate. This allows the Kafka brokers and clients to trust the certificates signed by our CA.
        ```bash
        bash keys/3_generate_truststore.sh
        ```

3.  **Start the environment:**
    Use `docker-compose` to start all the services, including Zookeeper, Kafka brokers, Kafka-UI, Kafka-Exporter, Prometheus, and Grafana.
    ```bash
    docker-compose up -d
    ```

4.  **Produce and Consume Messages:**
    * **Start the consumer:** Open a new terminal and run the consumer script to start listening for messages on the `sample-topic`.
        ```bash
        python app/consumer.py
        ```

    * **Start the producer:** In another terminal, run the producer script to start sending messages to the `sample-topic`.
        ```bash
        python app/producer.py
        ```

5.  **Access Monitoring and Management UIs:**
    * **Kafka-UI:** Open your web browser and navigate to [http://localhost:8090](http://localhost:8090) to access the Kafka-UI.
    * **Grafana:** Open your web browser and navigate to [http://localhost:3000](http://localhost:3000) to access the Grafana dashboard. The default credentials are `admin` for both username and password.

---

### **Cleanup**

To stop and remove all the containers and volumes created by `docker-compose`, run the following command:
```bash
docker-compose down -v