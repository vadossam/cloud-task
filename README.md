# Cloud Engineer task: Containerized WordPress with LiteSpeed server

### Requirements
- Docker
- Docker Compose

## Configuration
Edit the `.env` file to update the default WordPress MySQL user password and database, MySQL root password
Feel free to check [Docker hub Tag page](https://hub.docker.com/repository/docker/litespeedtech/litespeed/tags) if you want to update default litespeed and php versions(LSWS_VERSION and PHP_VERSION variables).

## Installation
Clone this repository or copy the files from this repository into a new folder:
```
git clone
```
`cd ` to the cloned folder, and run:
```
docker-compose up
```








It is based on the official LiteSpeed WordPress Docker Container: [LSWS WordPress](https://docs.litespeedtech.com/cloud/docker/lsws%2bwordpress)
