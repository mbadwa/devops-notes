kops create cluster --name=mbadwa.com \
--state=s3://kops-mbadwa-bucket --zones=us-east-1a,us-east-1b \
--node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=mbadwa.com \
--node-volume-size=8 --master-volume-size=8


kops create cluster --name=kops.mbadwa.com \
--state=s3://kops-mbadwa-bucket --zones=us-east-1a,us-east-1b \
--node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=kops.mbadwa.com \
--node-volume-size=8 --master-volume-size=8


# Finally, configure your cluster with: 
kops update cluster --name mbadwa.com --state=s3://kops-mbadwa-bucket --yes --admin

# Validate cluster after 10 - 20 min
kops validate cluster --state=s3://kops-mbadwa-bucket
  
# kOps Cluster Clean Uninstallation
kops delete cluster --name=kubevpro.mbadwa.com --state=s3://kops-mbadwa-bucket --yes