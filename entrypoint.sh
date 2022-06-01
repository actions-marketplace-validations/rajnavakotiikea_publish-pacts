#!/usr/bin/env bash
set -e

validate_args() {
  if [ -z "$(broker_auth_setup)" ]
  then
    echo "Error - either broker token or username+password has to be provided"
    exit 1
  fi

   if [ "$INPUT_WEBHOOK_TYPE" == "trigger_provider_job" ] && [ -z "$(provider_details)" ]
   then
     echo "Error - provider details has to be provided for 'trigger_provider_job' webhook"
   fi

   if [ "$INPUT_WEBHOOK_TYPE" == "consumer_commit_status" ] && [ -z "$(consumer_details)" ]
   then
     echo "Error - consumer details has to be provided for 'consumer_commit_status' webhook"
   fi
}

broker_auth_setup() {
  authentication=""
  if [ -z "$INPUT_BROKER_TOKEN" ]
  then
    if [ -z "$INPUT_BROKER_USERNAME" ] || [ -z "$INPUT_BROKER_PASSWORD" ]
    then
      authentication=""
    else
      authentication="--broker-username $INPUT_BROKER_USERNAME --broker-password $INPUT_BROKER_PASSWORD"
    fi
  else
    authentication="--broker-token $INPUT_BROKER_TOKEN"
  fi
  echo "$authentication"
}

publish_pacts() {
  docker run --rm \
        -v ${PWD}:${PWD} \
        pactfoundation/pact-cli \
        publish ${PWD}/pacts \
        --consumer-app-version nothing \
        --tag nothing \
        --broker-base-url https://sampleautoamtiontestraj.pactflow.io \
        --broker-token GglUlzHa8Egn_fpkhzZQLw

}

validate_args
publish_pacts

