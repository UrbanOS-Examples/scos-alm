[
  {
    "name": "${name}",
    "image": "${image}",
    "memory": ${memory},
    "essential": true,
    "command": ${command},
    "environment" : [
        { "name" : "ELB_NAME", "value" : "${elb_name}" },
        { "name" : "LDAP_BINDUSER_PWD", "value" : "${ldap_binduser_pwd}" }
    ],
    "portMappings": [
      {
        "containerPort": ${jenkins_port},
        "hostPort": ${jenkins_port}
      },
      {
        "containerPort": ${jnlp_port},
        "hostPort": ${jnlp_port}
      }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${directory_name}",
        "containerPath": "/var/${directory_name}"
      },
      {
        "sourceVolume": "docker-socket",
        "containerPath": "/var/run/docker.sock"
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${log_group}",
        "awslogs-region": "${region}"
      }
    }
  }
]
