## Capstone Arquitecture - Recommended

#### Analysis

The application...

* it will Have a **load balancer** for divide request on different **ec2 instances**.
* it will have a **auto scaling group** for increase or decrease instances for specific trafic that it can be recive. 
* it will Have a **segurity group** for these **ec2 instances** that have private network with a rule for **allow specific trafic** from loadbalancer segurity group.
* it will have a NAT Gateway for can connect instances to the internet.
* The **security group** attached to **loadbalancer** allow only access to **port 80 from all world**.
* a database witha a **subnet group** that just have attach **private subnets**, this will have a segurity group that **allow access** just for a **specific ports** on a **specific security groups**.
