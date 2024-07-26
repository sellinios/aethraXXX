docker system prune -a
pip freeze > requirements.txt
sudo docker build --no-cache -t sellinios/backend:latest .
sudo docker push sellinios/backend:latest
sudo docker build --no-cache -t sellinios/frontend:latest .
sudo docker push sellinios/frontend:latest
microk8s kubectl set image deployment/django-deployment django=sellinios/backend:latest -n backend
microk8s kubectl set image deployment/react-deployment react=sellinios/frontend:latest -n backend
microk8s kubectl delete deployments --all -n backend
sudo microk8s enable dns
sudo microk8s enable ingress
sudo microk8s enable cert-manager
microk8s kubectl apply -f production.yaml
microk8s kubectl get pods -n backend
