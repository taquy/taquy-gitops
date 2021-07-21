#!/bin/bash
terraform taint 'module.compute.aws_spot_instance_request.spot_instance'
terraform taint 'module.iam.aws_iam_access_key.jenkins_node_user_key'
terraform taint 'module.compute.data.aws_s3_bucket_object.user_data_obj'
terraform taint 'module.compute.data.template_file.user_data_tpl'