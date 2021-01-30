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
            "--providers.ecs.exposedByDefault=false"
        ],
        "environment": [
            {
                "name": "CLUSTER_NAME",
                "value": "${cluster_name}"
            }
        ],
        "portMappings": [
            {
                "hostPort": 80,
                "containerPort": 80
            },
            {
                "containerPort": 8080,
                "hostPort": 8080
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
        }
    }
]
