# CloudFront module
This module creates the CloudFront resources and configures them to point to the provided S3 resources. It supports the configuration of a logging bucket for the distribution

## Cross-region replication support 
It also supports a replication bucket that the distribution's origin can be flipped to with the `failover` flag.

This can be helpful if the original S3 region goes down (assuming you notice), and you have the ability to change the value of failover and re-apply your terraform files.
