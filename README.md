pip-review --local --auto
pip freeze > requirements.txt
docker info | grep Swarm
docker service ls
docker stack deploy -c docker-stack.yml aethra
./deploy-swarm.sh

docker service logs aethra_backend
docker service logs aethra_db
docker service logs aethra_frontend
docker service logs aethra_nginx

docker service inspect aethra_backend
docker service inspect aethra_db
docker service inspect aethra_frontend
docker service inspect aethra_nginx

tree -L 5 -I 'node_modules|build|venv|staticfiles'

docker stack rm aethra
docker system prune -a
