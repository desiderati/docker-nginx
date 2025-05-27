# docker-nginx

A lightweight and customizable Docker image for serving static web applications using Nginx. Ideal for deploying frontend projects like single-page applications (SPAs), static websites, and documentation portals with optimal performance and minimal configuration.

## How to build

1. Retrieve the login command to use to authenticate your Docker client to your registry:

   `docker login -u <USER> api.repoflow.io`

2. Build your Docker image using the following command. You can skip this step if your image is already built:

   `docker build --progress=plain -t nginx:1.25.5.2 .`

   > Ps.: Remember to disconnect any VPM from your local machine.

3. After the build completes, tag your image, so you can push the image to your repository:

   `docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:1.25.5.2`
   `docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:latest`

4. Run the following command to push this image to your repository:

   `docker push api.repoflow.io/herd.io/docker/nginx:1.25.5.2`
   `docker push api.repoflow.io/herd.io/docker/nginx:latest`

### Example

   ```
   docker build --progress=plain -t nginx:1.25.5.2 .
   docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:1.25.5.2
   docker tag nginx:1.25.5.2 api.repoflow.io/herd.io/docker/nginx:latest
   docker push api.repoflow.io/herd.io/docker/nginx:1.25.5.2
   docker push api.repoflow.io/herd.io/docker/nginx:latest
   ```
