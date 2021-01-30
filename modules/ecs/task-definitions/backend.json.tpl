[
    {
        "name": "${service_name}",
        "image": "${image_url}",
        "essential": true,
        "portMappings": [
            {
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
            "traefik.enable": "true",
            "traefik.http.routers.backend.rule": "Host(`${alb_dns}`)",
            "traefik.http.routers.backend.entrypoints": "web"
        }
    }
]
