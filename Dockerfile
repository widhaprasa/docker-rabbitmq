FROM rabbitmq:3.11.2-alpine

RUN apk --no-cache add curl

RUN curl -L https://github.com/rabbitmq/rabbitmq-message-timestamp/releases/download/v3.11.1/rabbitmq_message_timestamp-3.11.1.ez > rabbitmq_message_timestamp-3.11.1.ez && \
        mv rabbitmq_message_timestamp-3.11.1.ez plugins/

RUN set eux; \
        rabbitmq-plugins enable --offline rabbitmq_mqtt; \
        rabbitmq-plugins enable --offline rabbitmq_management; \
        rabbitmq-plugins enable --offline rabbitmq_message_timestamp; \
# make sure the metrics collector is re-enabled (disabled in the base image for Prometheus-style metrics by default)
        rm -f /etc/rabbitmq/conf.d/management_agent.disable_metrics_collector.conf; \
# grab "rabbitmqadmin" from inside the "rabbitmq_management-X.Y.Z" plugin folder
# see https://github.com/docker-library/rabbitmq/issues/207
        cp /plugins/rabbitmq_management-*/priv/www/cli/rabbitmqadmin /usr/local/bin/rabbitmqadmin; \
        [ -s /usr/local/bin/rabbitmqadmin ]; \
        chmod +x /usr/local/bin/rabbitmqadmin; \
        apk add --no-cache python3; \
        rabbitmqadmin --version

EXPOSE 15671 15672
EXPOSE 1883
