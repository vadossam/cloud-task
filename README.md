# Cloud Engineer task: Containerized WordPress with LiteSpeed server

### Requirements
- Docker
- Docker Compose

## Configuration
Edit the `.env` file to update the default WordPress MySQL user password and database, MySQL root password.
Feel free to check [Docker hub Tag page](https://hub.docker.com/repository/docker/litespeedtech/litespeed/tags) if you want to update default litespeed and php versions (LSWS_VERSION and PHP_VERSION variables).

## Installation
Clone this repository or copy the files from this repository into a new folder:
```
git clone https://github.com/vadossam/cloud-task.git
```
`cd cloud-task` to the cloned folder, and run:
```
docker-compose up
```
or in detached mode:
```
docker-compose up -d
```
After containers are built and started, you can navigate to *http://localhost* or *http://SERVER_IP* to set up WordPress admin details.

## Status page
LiteSpeed status info can accessed in browser or via command line:
```
curl http://localhost:7080/status
curl http://SERVER_IP:7080/status
```
\
*It is based on the official LiteSpeed WordPress Docker Container: [LSWS WordPress](https://docs.litespeedtech.com/cloud/docker/lsws%2bwordpress)*
