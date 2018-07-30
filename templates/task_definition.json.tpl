[
  {
    "name": "${name}",
    "image": "${image}",
    "memory": ${memory},
    "essential": true,
    "command": ${command},
    "environment" : [{ "name" : "ELB_NAME", "value" : "${elb_name}" }],
    "portMappings": [
      {
        "containerPort": ${port},
        "hostPort": ${port}
      },
      {
        "containerPort": 50000,
        "hostPort": 50000
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
