#
# variables
#

$dotnet_runtime             = "ubuntu.14.04-x64"
$dotnet_configuration       = "Release"

$paths = @(
  "../../src/Seaside.Web.Api"
)

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
# build dotnet code
#

log("restoring nuget packages")

dotnet restore ../../

foreach ($path in $paths) {
  if (!(test-path -Path $path)) {
    throw "Build path $path does not exist"
  }
  
  log("building $path")

  dotnet build    --configuration $dotnet_configuration --runtime $dotnet_runtime $path
  dotnet publish  --configuration $dotnet_configuration --runtime $dotnet_runtime $path
}

#
# package for codedeploy
#

log("packaging web.zip")

$path         = "./web"
$app          = "seasideweb"
$codedeploy   = "../codedeploy/web"
$bin          = "../../src/Seaside.Web.Api/bin"
$zip          = "./web.zip"

if (test-path -path $path) {
  remove-item -recurse -force $path
}

new-item $path -itemtype directory | out-null
new-item "$path/$app" -itemtype directory | out-null

copy-item "$bin/$dotnet_configuration/netcoreapp1.0/publish/*" "$path/$app" | out-null
copy-item "$codedeploy/*" $path -recurse -force | out-null

if (test-path -path $zip) {
  log("removing previous $zip")
  remove-item $zip
}

compress-archive -path "$path/*" -destinationPath $zip
remove-item $path -recurse -force
