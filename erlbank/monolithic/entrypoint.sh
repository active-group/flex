#!/bin/sh

export RELX_REPLACE_OS_VARS=true

case "$1" in
    deploy)
        echo mycookie > $HOME/.erlang.cookie
        chmod 400 $HOME/.erlang.cookie
        ./_build/default/rel/erlbank_monolithic/bin/erlbank_monolithic foreground
        ;;
    test)
        rebar3 eunit
        ;;
    deploy-with-elk)

        if ! [ -x "$(command -v curl)" ]; then
            apk add curl
        fi

        # Wait for opensearch dashboard
        while true; do # wait for local opensearch dashboard
            echo "$(date) waiting for opensearch dashboard ..."
            curl -s -XGET "$OPENSEARCH_DASHBOARD_HOST:5601"
            if [ "$?" -eq 0 ]; then
                break
            fi
            sleep 10
        done

        # Wait for logstash
        while true; do # wait for local logstash
            echo "$(date) waiting logstash ..."
            curl -s -XGET "$LOGSTASH_HOST:9600"
            if [ "$?" -eq 0 ]; then
                break
            fi
            sleep 10
        done

        sleep 10

        # Note: the opensearch dashboard needs some time to be ready
        # Waiting after logstash is also ready does the trick.

        # Create default index
        echo "Creating opensearch dashboard index..."
        curl -XPOST -H 'Content-Type: application/json' \
             -H 'osd-xsrf: true' \
             "http://admin:admin@$OPENSEARCH_DASHBOARD_HOST:5601/api/saved_objects/index-pattern/erlbank-*" \
             '-d{"attributes":{"title":"erlbank-*","timeFieldName":"@timestamp"}}'

        echo mycookie > $HOME/.erlang.cookie
        chmod 400 $HOME/.erlang.cookie
        ./_build/default/rel/erlbank_monolithic/bin/erlbank_monolithic foreground
        ;;
    *)
        sh -c $@
        ;;
esac
