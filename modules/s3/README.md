# S3 module

This submodule creates the resources required for an S3 hosted website. It creates a separate logging bucket by default.

## Cross-Region Replication
If cross-region replication is set, as well as the `replication_aws_region` this module will also create a target replication bucket and it's own logging bucket in the specified replication region. It will also create the requires IAM resources to allow the replication
