docker build --progress=plain -t nginx:1.25.5.2 .
docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:1.25.5.2
docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:latest
docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:1.25.5.2
docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:latest
docker push api.repoflow.io/herd.io/docker/nginx:1.25.5.2
docker push api.repoflow.io/herd.io/docker/nginx:latest
