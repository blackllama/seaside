#
# variables
#

$name                           = "seaside"
$environment                    = "dev-east-1"
$aws_region_id                  = "us-east-1"
$aws_profile_name               = "seaside-infra"

$aws_codedeploy_app             = "$name-$environment-codedeploy-app"
$aws_codedeploy_bucket          = "$name-$environment-codedeploy-bucket"
$aws_codedeploy_group_web       = "$name-$environment-aws-codedeploy-group-web"
$aws_codedeploy_deploy_config   = "CodeDeployDefault.OneAtATime"

#
# functions
#

function log($info) {
  write-host ""
  write-host "--------------------------------------------------------------------"
  write-host $info
  write-host "--------------------------------------------------------------------"
  write-host ""
}

#
# codedeploy
#

$path = "./web.zip"
log("uploading codedeploy package $path to s3")
aws s3 cp $path s3://$aws_codedeploy_bucket/web.zip --profile $aws_profile_name

log("deploying...")
aws deploy create-deployment --application-name $aws_codedeploy_app --deployment-group-name $aws_codedeploy_group_web --s3-location bucket=$aws_codedeploy_bucket,bundleType=zip,key=web.zip --deployment-config-name $aws_codedeploy_deploy_config --ignore-application-stop-failures --profile $aws_profile_name