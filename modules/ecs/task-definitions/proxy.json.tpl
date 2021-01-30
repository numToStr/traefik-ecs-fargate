[
    {
        "name": "${service_name}",
        "image": "${image_url}",
        "essential": true,
        "command": [
            "traefik",
            "--api.insecure",
            "--api.dashboard",
            "--accesslog=true",
            "--log.level=DEBUG",
            "--log.format=json",
            "--entryPoints.web.address=:80",
            "--providers.ecs.region=${region}",
            "--providers.ecs.clusters=${cluster_name}",
            "--providers.ecs.exposedByDefault=true"
        ],
        "portMappings": [
            {
                "hostPort": 80,
                "containerPort": 80
            }
        ],
        "logConfiguration": {
            "logDriver": "awslogs",
            "options": {
                "awslogs-create-group": "true",
                "awslogs-group": "ecs/${cluster_name}/${service_name}",
                "awslogs-region": "${region}",
                "awslogs-stream-prefix": "ecs"
            }
        },
        "dockerLabels": {
            "traefik.enable": "false"
        }
    }
]
