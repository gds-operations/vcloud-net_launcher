#!/bin/bash -x
set -e
bundle install --path "${HOME}/bundles/${JOB_NAME}"
# commented out for now as there are no unit tests
# and rake aefault is currently integration test
# bundle exec rake

RUBYOPT="-r ./tools/fog_credentials" bundle exec rake integration

bundle exec rake publish_gem
