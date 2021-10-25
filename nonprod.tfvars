###############################################################################
##########   NON PROD VARS - CHEESEBURGER WITH FRIES (RSTUDIO) ################
###############################################################################

resource "aws_emr_cluster" "cluster" {
  name          = "Research EMR R Cluster"
  release_label = "emr-5.23.0"
  applications  = ["Hadoop", "Spark"]

  step = [ 
    {
      action_on_failure = "CONTINUE"
      name              = "install base"
      hadoop_jar_step = [ 
        {
          args = [ "s3://buildenv/lotto.sh" ]
          jar = "s3://elasticmapreduce/libs/script-runner/script-runner.jar"
          main_class = null
          properties = null
        } 
      ]
    } 
  ]

  termination_protection            = true
  keep_job_flow_alive_when_no_steps = true

  ec2_attributes {
    subnet_id                          = aws_subnet.main.id
    emr_managed_master_security_group  = aws_security_group.master_access.id
    emr_managed_slave_security_group   = aws_security_group.allow_access.id
    instance_profile                   = aws_iam_instance_profile.iam_emr_profile_role.arn
    key_name                           = "nicolelabemrTf"

    
  }

  master_instance_group {
    instance_type = "c1.xlarge"
  }

  core_instance_group {
    instance_type  = "c1.xlarge"
    instance_count = 1
  }

  tags = {
    role = "rolename"
    env  = "env"
  }


  configurations_json = <<EOF
  [
    {
      "Classification": "hadoop-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    },
    {
      "Classification": "spark-env",
      "Configurations": [
        {
          "Classification": "export",
          "Properties": {
            "JAVA_HOME": "/usr/lib/jvm/java-1.8.0"
          }
        }
      ],
      "Properties": {}
    }
  ]
EOF

  service_role = aws_iam_role.iam_emr_service_role.arn

}

role_arn            = "r_tr_nonprod"
region              = "us-gov-west-1"
app_name            = "research"
vpc_cidr            = "172.16.13.0/25"
app_cidr_az1        = "172.16.13.0/27"
app_cidr_az2        = "172.16.13.32/27"
lb_cidr_az1         = "172.16.13.96/28"
lb_cidr_az2         = "172.16.13.112/28"
prefix              = "fs-dev"
