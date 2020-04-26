#we need to generate two builds one for latest tag and other for unique version using SHA ( fed via env variable in travis.ym)
#this is required so that the images on the K8s can be updated. If we have just latest tag then K8s would not able to distinguish 
#images 
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
kubectl set image deployments/client-deployment server=miththoobhai/multi-client:$SHA
kubectl set image deployments/worker-deployment server=miththoobhai/multi-worker:$SHA
