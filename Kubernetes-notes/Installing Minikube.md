# Installing Minikube on Ubuntu 20.04 LTS (Focal Fossa)

## Overview

Before learning about Minikube, we should at least know about Kubernetes, because Minikube is one kind of Kubernetes which is commonly used.

Kubernetes is a portable, extensible, open source platform for managing containerized workloads and services, that facilitates both declarative configuration and automation. In other words, Kubernetes is a container manager which manages several containers to serve at one end and prevents the service of being down or overloaded by weighing all loads and balancing them throughout all containers at the same time. Put simply, Kubernetes is a multi-service manager. For more information about Kubernetes, please read the concept from its official website [Kubernetes Concepts](https://kubernetes.io/docs/concepts/overview/)

Minikube is a lightweight Kubernetes implementation that creates a VM on your local machine and deploys a simple cluster containing only one node (node = machine/server). Minikube is available for Linux, macOS, and Windows systems. Minikube is the simplest and easiest to use type of Kubernetes if you have only one single server to run.

## Prerequisites

- A server running on one of the following operating systems: Ubuntu 22.04, 20.04, 18.04, 16.04 or any other Debian-based distribution like Linux Mint
- It’s recommended that you use a fresh installed OS to prevent any unexpected issues
- Access to the root user
  
## Installation Steps

**Step 1.** Installing Docker

We will be using Docker container as a base for Minikube. In case Docker is not installed yet on your Ubuntu system then use following link to install it: [Installing Docker Engine](docker-engine.sh) on Ubuntu 22.04 LTS

**Step 2.** Updating system packages and installing Minikube dependencies

    $ sudo apt update
    $ sudo apt install -y curl wget apt-transport-https

**Step 3.** Installing Minikube

Use the following curl command to download latest minikube binary

    $ curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

Once the binary is downloaded, use the following command to install Minikube

    $ sudo install minikube-linux-amd64 /usr/local/bin/minikube

Verifying Minikube installation

    $ minikube version
    minikube version: v1.33.1
    commit: 5883c09216182566a63dff4c326a6fc9ed2982ff

**Step 4.** Installing kubectl utility

kubectl is a command line used to interact with Kubernetes cluster. It is used for managing deployments, replica sets, services, etc. Use the following command to download the latest version of kubectl.

    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/"curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt"/bin/linux/amd64/kubectl

Once kubectl is downloaded then set the executable permissions on kubectl binary and move it to the path /usr/local/bin.

    $ chmod +x kubectl
    $ sudo mv kubectl /usr/local/bin/

Now, verify the kubectl version

    $ kubectl version -o yaml
    clientVersion:
        buildDate: "2024-08-13T07:37:34Z"
        compiler: gc
        gitCommit: 9edcffcde5595e8a5b1a35f88c421764e575afce
        gitTreeState: clean
        gitVersion: v1.31.0
        goVersion: go1.22.5
        major: "1"
        minor: "31"
        platform: linux/amd64
    kustomizeVersion: v5.4.2

**Step 5.** Starting Minikube

As we already stated in the beginning that we would be using docker as base for Minikube. To start the minikube with the docker driver, run the following command:

    $ minikube start — driver=docker

In case Minikube cannot start because there is error regarding the Docker driver. Possible error:

    $ minikube start --driver=docker
    😄  minikube v1.32.0 on Ubuntu 20.04 (amd64)
    ✨  Using the docker driver based on existing profile
    🛑  The "docker" driver should not be used with root privileges. If you wish to continue as root, use --force.
    💡  If you are running minikube within a VM, consider using --driver=none:
    📘    https://minikube.sigs.k8s.io/docs/reference/drivers/none/
    💡  Tip: To remove this root owned cluster, run: sudo minikube delete

    ❌  Exiting due to DRV_AS_ROOT: The "docker" driver should not be used with root privileges.

Use the following command to force start:

    $ minikube start --driver=docker --force

The output would be like below:

    $ minikube start --driver=docker --force
    😄  minikube v1.32.0 on Ubuntu 20.04 (amd64)
    ❗  minikube skips various validations when --force is supplied; this may lead to unexpected behavior
    ✨  Using the docker driver based on existing profile
    🛑  The "docker" driver should not be used with root privileges. If you wish to continue as root, use --force.
    💡  If you are running minikube within a VM, consider using --driver=none:
    📘    https://minikube.sigs.k8s.io/docs/reference/drivers/none/
    💡  Tip: To remove this root owned cluster, run: sudo minikube delete
    👍  Starting control plane node minikube in cluster minikube
    🚜  Pulling base image ...
    🔄  Restarting existing docker container for "minikube" ...
    🐳  Preparing Kubernetes v1.28.3 on Docker 24.0.7 ...
    🔗  Configuring bridge CNI (Container Networking Interface) ...
    🔎  Verifying Kubernetes components...
    💡  Some dashboard features require the metrics-server addon. To enable all features please run:

            minikube addons enable metrics-server


    🌟  Enabled addons: storage-provisioner, default-storageclass
    🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

Perfect, the above picture confirms that Minikube cluster has been configured and started successfully.

**Step 6.** Verifying Installation

Use the following command to verify Minikube:

    $ minikube status
    minikube
    type: Control Plane
    host: Running
    kubelet: Running
    apiserver: Running
    kubeconfig: Configured

Use the following command to verify Kubernetes:

    $ kubectl cluster-info
    Kubernetes control plane is running at https://192.168.49.2:8443
    CoreDNS is running at https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

    To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.

Use the following command to test Kubernetes:

    $ kubectl get nodes
    NAME       STATUS   ROLES           AGE   VERSION
    minikube   Ready    control-plane   25h   v1.28.3

