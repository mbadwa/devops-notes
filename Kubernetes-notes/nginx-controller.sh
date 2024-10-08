###STEPS###
# Create Controller
# Create Deployment
# Create Service
# Create DNS Cname Record for LB
# Create Ingress
# Test

# Create controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/aws/deploy.yaml

# Create Deployment
vim vprodep.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  selector:
    matchLabels:
      run: my-app
  replicas: 1
  template:
    metadata:
      labels:
        run: my-app
    spec:
      containers:
      - name: my-app
        image: imranvisualpath/vproappfix
        ports:
        - containerPort: 8080

kubectl apply -f vprodep.yaml


# Create service
vim vprosvc.yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
spec:
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 8080
  selector:
    run: my-app
  type: ClusterIP


kubectl apply -f vprosvc.yaml
kubectl get svc
kubectl describe svc my-app


# Create DNS Cname Record for LB
Go to your domain hosted records
Add CNAME record
hostname => Load balancer Endpoint URL


# Create Ingress
vim vproingress.yaml

kind: Ingress
metadata:
  name: vpro-ingress
  annotations:
    nginx.ingress.kubernetes.io/use-regex: "true"
spec:
  ingressClassName: nginx
  rules:
  - host: vprofile.groophy.in
    http:
      paths:
      - path: /login
        pathType: Prefix
        backend:
          service:
            name: my-app
            port:
              number: 8080

kubectl apply -f vproingress.yaml

# Update Path in ingress from /login to /
kubectl get ingress
kubectl delete ingress vpro-ingress
vim vproingress.yaml

paths:
  - path: /

kubectl apply -f vproingress.yaml
kubectl get ingress
kubectl get ingress --watch
clear
kubectl get ns
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/aws/deploy.yaml
