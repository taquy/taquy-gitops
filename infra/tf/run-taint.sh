#!/bin/bash
terraform taint 'module.compute.aws_spot_instance_request.spot_instance'
terraform taint 'module.iam.aws_iam_access_key.jenkins_node_user_key'