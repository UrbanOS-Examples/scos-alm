#!/bin/sh

yum install -y docker
service docker start

aws configure set region ${region}
eval "$(aws ecr get-login --no-include-email)"

docker run -d --restart=always \
    -p 8080:8080 \
    -e JENKINS_HOST="${jenkins_host}" \
    -e JENKINS_PORT="${jenkins_port}" \
    -e GH_WEBHOOK_SECRET="${webhook_secret}" \
    --name github_jenkins_relay \
    ${image_name}