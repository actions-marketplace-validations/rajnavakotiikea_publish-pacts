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
  broker_auth="$(broker_auth_setup)"

  optional_args=''
  if [ -n "${INPUT_REPOSITORY_BRANCH}" ]
  then
    optional_args="${optional_args} --branch ${INPUT_REPOSITORY_BRANCH}"
  fi
   if [ "${INPUT_TAG_WITH_GIT_BRANCH}" == "true" ]
   then
     optional_args="${optional_args} --tag-with-git-branch"
  fi

  if [ -n "${INPUT_BUILD_URL}" ]
  then
    optional_args="${optional_args} --build-url ${INPUT_BUILD_URL}"
  fi

  if [ "${INPUT_MERGE}" == "true" ]
  then
    optional_args="${optional_args} --merge"
  fi


  docker run --rm \
        -v ${PWD}:${PWD} \
        pactfoundation/pact-cli \
        publish ${INPUT_PACT_FILE_DIR} \
        --consumer-app-version ${INPUT_CONSUMER_APP_VERSION} \
        --tag ${INPUT_TAG} \
        --broker-base-url ${INPUT_BROKER_BASE_URL} \
        $broker_auth $optional_args
}

validate_args
publish_pacts

