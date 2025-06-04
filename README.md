# docker-nginx

A lightweight and customizable Docker image for serving static web applications using Nginx. 
Ideal for deploying frontend projects like single-page applications (SPAs), static websites, 
and documentation portals with optimal performance and minimal configuration.

## Table of Contents

- [Features](#features)
- [Usage](#usage)
  - [Basic Usage](#basic-usage)
  - [Docker Compose](#docker-compose)
- [Configuration](#configuration)
  - [Environment Variables](#environment-variables)
  - [Custom Configuration](#custom-configuration)
  - [Volume Mounts](#volume-mounts)
- [Monitoring](#monitoring)
- [Utilities](#utilities)
  - [wait-for-it.sh](#wait-for-itsh)
- [Error Handling](#error-handling)
- [Building and Publishing](#building-and-publishing)

## Features

- Based on official Nginx 1.25.5 image
- Optimized for serving static content
- Custom error pages for common HTTP status codes
- Environment variable substitution in static content
- Monitoring endpoint for health checks and metrics
- Configurable through volume mounts and environment variables
- Timezone set to America/Sao_Paulo by default
- Datadog logging integration

## Usage

### Basic Usage

Run the container with default settings:

```bash
docker run -d \
  --name nginx \
  -p 80:80 \
  -p 81:81 \
  -v $(pwd)/logs/nginx/:/var/log/nginx/ \
  -v $(pwd)/path-to-your-content/:/opt/www/ \
  api.repoflow.io/desiderati/docker/library/nginx:latest
```

### Docker Compose

Create a `docker-compose.yml` file:

```yaml
services:
  nginx:
    container_name: nginx
    image: 'api.repoflow.io/desiderati/docker/library/nginx:latest'
    ports:
      - '80:80'
      - '81:81'
    environment:
      - GVAR_HELLO_WORLD_MSG=Hello, World!
    volumes:
      - ./logs/nginx/:/var/log/nginx/
      - ./path-to-your-content/:/opt/www/
```

Run with Docker Compose:

```bash
docker-compose up -d
```

## Configuration

### Environment Variables

- `TZ`: Timezone (default: America/Sao_Paulo)
- `NGINX_ENTRYPOINT_QUIET_LOGS`: Set to any value to suppress entrypoint logs
- `GVAR_*`: Any environment variable prefixed with `GVAR_` will be available for substitution in static content

Example of using environment variables for content substitution:

1. Set an environment variable:
   ```
   -e GVAR_APP_VERSION=1.0.0
   ```

2. In your HTML file:
   ```html
   <p>App Version: __GVAR_APP_VERSION__</p>
   ```

3. Nginx will replace `__GVAR_APP_VERSION__` with `1.0.0` when serving the file.

### Custom Configuration

You can customize the Nginx configuration by mounting your own configuration files:

```bash
docker run -d \
  --name nginx \
  -p 80:80 \
  -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
  -v $(pwd)/nginx.server-default.conf:/etc/nginx/conf.d/nginx.server-default.conf \
  -v $(pwd)/path-to-your-content/:/opt/www/ \
  api.repoflow.io/desiderati/docker/library/nginx:latest
```

### Volume Mounts

Common volume mounts:

- `/opt/www`: Web content root directory
- `/etc/nginx/conf.d/`: Server configuration directory
- `/var/log/nginx/`: Log directory
- `/etc/nginx/html/http-error/`: Custom error pages directory

## Monitoring

The image includes a status endpoint for monitoring:

- URL: http://localhost:81/nginx_status
- Uses the `stub_status` module
- Useful for health checks and metrics collection

## Utilities

### wait-for-it.sh

The image includes the `wait-for-it.sh` utility script that can be used 
to wait for a service to be available before starting Nginx. 
This is useful when your application depends on other services being available.

Example usage:

```bash
docker run -d \
  --name nginx \
  -p 80:80 \
  -v $(pwd)/path-to-your-content/:/opt/www/ \
  api.repoflow.io/desiderati/docker/library/nginx:latest \
  wait-for-it database:5432 -- nginx -g "daemon off;"
```

This will wait for the database service to be available on port 5432 before starting Nginx.

## Error Handling

Custom error pages are provided for common HTTP status codes:
- 400, 401, 403, 404, 500, 501, 502, 503

You can customize these pages by mounting your own error pages:
``
```bash
docker run -d -p 80:80 \
  -v $(pwd)/path-to-your-custom-error-pages/:/etc/nginx/html/http-error/ \
  -v $(pwd)/path-to-your-content/:/opt/www/ \
  api.repoflow.io/desiderati/docker/library/nginx:latest
```

## Building and Publishing

1. Retrieve the login command to use to authenticate your Docker client to your registry:

   ```bash
   docker login -u <USER> api.repoflow.io
   ```

2. Build your Docker image using the following command. You can skip this step if your image is already built:

   ```bash
   docker build --progress=plain -t nginx:1.25.5.2 .
   ```

   > Note: Remember to disconnect any VPN from your local machine.

3. After the build completes, tag your image, so you can push the image to your repository:

   ```bash
   docker tag nginx:1.25.5.2 api.repoflow.io/desiderati/docker/nginx:1.25.5.2
   docker tag nginx:1.25.5.2 api.repoflow.io/desiderati/docker/nginx:latest
   ```

4. Run the following command to push this image to your repository:

   ```bash
   docker push api.repoflow.io/desiderati/docker/nginx:1.25.5.2
   docker push api.repoflow.io/desiderati/docker/nginx:latest
   ```

### Commands

    ```bash
    docker build --progress=plain -t nginx:1.25.5.2 .
    docker tag nginx:1.25.5.2 api.repoflow.io/desiderati/docker/nginx:1.25.5.2
    docker tag nginx:1.25.5.2 api.repoflow.io/desiderati/docker/nginx:latest
    docker push api.repoflow.io/desiderati/docker/nginx:1.25.5.2
    docker push api.repoflow.io/desiderati/docker/nginx:latest
    ```

## License

This project is licensed under the MIT License.
