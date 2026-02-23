rem this ensures the network always exists in case it does not
docker network create --driver bridge harmony-link-network
docker compose up -d