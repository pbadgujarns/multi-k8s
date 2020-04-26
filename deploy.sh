docker build -t miththoobhai/multi-client:latest -t miththoobhai/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t miththoobhai/multi-server:latest -t miththoobhai/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t miththoobhai/multi-worker:latest -t miththoobhai/multi-worker:$SHA  -f ./worker/Dockerfile ./worker

docker push miththoobhai/multi-client:latest
docker push miththoobhai/multi-server:latest
docker push miththoobhai/multi-worker:latest

docker push miththoobhai/multi-client:$SHA
docker push miththoobhai/multi-server:$SHA
docker push miththoobhai/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=miththoobhai/multi-server:$SHA
kubectl set image deployments/client-deployment client=miththoobhai/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=miththoobhai/multi-worker:$SHA