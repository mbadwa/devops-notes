kops create cluster --name=mbadwa.com \
--state=kops-mbadwa-bucket --zones=us-east-1a,us-east-1b \
--node-count=2 --node-size=t3.small --master-size=t3.medium --dns-zone=mbadwa.com \
--node-volume-size=8 --master-volume-size=8