# kubectl Cheat Sheet

## kubectl autocomplete 

For Debian based distro
    
    sudo apt-get install -y bash-completion

For Red-hat based distro
    
    sudo yum install bash-completion

Setup kubectl autocomplete
    
    source < (kubectl completion bash)

Add autocompletion permanently
    
    echo "source < (kubectl completion bash)" >> ~/.bashrc

## kubectl aliases
    
Set aliases
    
    alias k=kubectl
    alias kg='kubectl get'
    alias kd='kubectl describe'
    alias ka='kubectl apply'
    alias kdelf='kubectl delete -f'
    alias kl='kubectl logs'

## Cluster management

Set your kube-context
    
    kubectl config use-context <context-name>

View available contexts
    
    kubectl config get-contexts

Show nodes in the cluster
    
    kubectl get nodes

Sort nodes by CPU
    
    kubectl get nodes --sort-by=.status.capacity.cpu

Display detailed node information
    
    kubectl describe node <node-name>

## Namespaces

List all namespaces
    
    kubectl get namespaces

Create a new namespace
    
    kubectl create namespace <namespace-name>

Watch for changes in a namespace
    
    kubectl get all --watch --namespace=<namespace-name>

Delete all resources within a namespace
    
    kubectl delete all --all --namespace=<namespace-name>

## Resource Types

List specific resource type
    
    kubectl get <resource-type>

Display detailed information about a resource type
    
    kubectl get <resource-type> <resource-name> -o yaml

Display resource utilization
    
    kubectl top <resource-type>

Export resource definitions to yaml
    
    kubectl get <resources-type> <resource-name> -o yaml > <resource-definition.yaml>

## Security

Display service account details 
    
    kubectl get serviceaccount <service-account-name> -n <namespace>

Show role details
    
    kubectl get clusterrole <cluster-role-name>

## Events

Filter events by resource type
    
    kubectl get events --field-selector involveObject.kind=<resource-type>

Describe an event in a namespace
    
    kubectl describe event <event-name> -n <namespace>

Watch events as they occur
    
    kubectl get events --watch

Filter events by a type
    
    kubectl get events --field-selector type=<event-type>

## Pods

Get detailed information about a pod

    kubectl describe pod <pod-name>

Execute commands in a pod

    kubectl exec -t <pod-name> -- <command>

Enable port forwarding for pod access

    kubectl port-forward <pod-name> <local-port>:<pod-port>

Create debug container in a pod

    kubectl debug -it <pod-name> --image=<debug-container-image>

## Deployments

List all deployments 

    kubectl get deployments

Describe a deployment
    
    kubectl describe deployment <deployment-name>

Check deployment rollout status

    kubectl rollout status deployment/<deployment-name>

View history of deployment changes 

    kubectl rollout history deployment/<deployment-name>

Rollback deployment

    kubectl rollout undo deployment/<deployment-name> --to-revision=<revision-number>

Scale a deployment

    kubectl scale deployment/<deployment-name> --replicas=<replica-count>

## Config Maps and Secrets

Create a ConfigMap from a file

    kubectl create a configmap <configmap-name> --from-file=<file-path>

Create a ConfigMap from key-value pairs

    kubectl create configmap <configmap-name> --from-literal=<key>=<value>

View ConfigMaps in a namespace

    kubectl get configmaps

Describe a ConfigMap

    kubectl describe configmap <configmap-name>

Apply a ConfigMap to a pod

    kubectl apply-f <pod-configmap.yaml>

Create a Secret from a file

    kubectl create secret generic <secret-name> --from-file=<file-path>

Create a Secret with key-value pairs

    kubectl create secret generic <secret-name> --from-literal=<key>=<value>

View Secrets in a namespace

    kubectl get secrets

Describe a Secret

    kubectl describe secret <secret-name>

Apply a Secret to a pod

    kubectl apply -f <pod-secret.yaml>

Decode a Secret's data value

    kubectl get secret <secret-name> -o jsonpath='{.data.<key>}' | base64 --decode

## Services and Networking

Expose a deployment as a service

    kubectl expose deployment <deployment-name> --port=<external-port> --target-port=<internal-port> --type=<service-type>

List all services in a namespace

    kubectl get services

Describe a service

    kubectl describe service <service-name>

Access a service externally using

    port-forwarding kubectl port-forward service/<service-name> <local-port>:<service-port>

Create a NetworkPolicy to control pod communication

    kubectl apply -f <network-policy.yaml>

List all NetworkPolicies in a namespace

    kubectl get network policies

Describe a NetworkPolicy

    kubectl describe networkpolicy <network-policy-name>

Delete a service 

    kubectl delete service <service-name>

Delete a NetworkPolicy

    kubectl delete networkpolicy <network-policy-name>

## Creating, Updating, and Patching Resources

Create a resource from a file or URL

    kubectl create -f <filename>

Apply changes to a resource using a file or URL

    kubectl apply -f <filename>

Update the image of a container in a deployment

    kubectl set image deployment/<deployment-name> <container-name>=<new-image>

Patch a resource using a strategic merge patch from a file

    kubectl patch <resource-type> <resource-name> --type=strategic --patch "$(cat <patch-file.yaml>)"

Patch a resource using a JSON merge patch from a file

    kubectl patch <resource-type> <resource-name> --type=json --patch "$(cat <patch-file.json>)"

Edit a resource in your preferred editor 

    kubectl edit <resource-type> <resource-name>

Replace a resource using a file or URL

    kubectl replace -f <filename>

Apply a declarative configuration

    kubectl apply -f <directory>

Scale the number of replicas in a deployment

    kubectl scale deployment/<deployment-name> --replicas=<num>



