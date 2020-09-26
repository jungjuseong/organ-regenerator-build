# This script builds a Cura release using the cura-build-environment Windows docker image.

param (
# Docker parameters
[string]$DockerImage = "ultimaker/cura-build-environment:python3.7-win1809-latest",

# Branch parameters
[string]$CuraBranchOrTag = "4.5",
[string]$UraniumBranchOrTag = "master",
[string]$OrganRegenEngineBranchOrTag = "master",
[string]$CuraBinaryDataBranchOrTag = "master",
[string]$FdmMaterialsBranchOrTag = "master",
[string]$LibCharonBranchOrTag = "master",

# Cura release parameters
  [int32]$CuraVersionMajor=1,
  [int32]$CuraVersionMinor=1,
  [int32]$CuraVersionPatch=1,
  [string]$CuraVersionExtra = "",

  [string]$CuraBuildType = "Debug",
  [string]$NoInstallPlugins = "PrepareStage;",
  [string]$CloudApiRoot = "https://api.ultimaker.com",
  [string]$CloudAccountApiRoot = "https://account.ultimaker.com",
  [int32]$CloudApiVersion = "1",
  [boolean]$EnableDebugMode = $true,
  [boolean]$EnableOrganRegenEngineExtraOptimizationFlags = $true,
  [string]$CuraWindowsInstallerType = "EXE",

  [string]$CuraMsiProductGuid = "{3F2504E0-4F89-11D3-9A0C0305E82C3301}",
  [string]$CuraMsiUpgradeGuid = "{3F2504E0-4F89-11D3-9A0C0305E82C3302}",

  [boolean]$IsInteractive = $true,
  [boolean]$BindSshVolume = $false
)

$ErrorActionPreference = "Stop"

$outputDirName = "windows-installers"
$buildOutputDirName = "build"

New-Item $outputDirName -ItemType "directory" -Force
$repoRoot = Join-Path $PSScriptRoot -ChildPath "..\..\.." -Resolve
$outputRoot = Join-Path (Get-Location).Path -ChildPath $outputDirName -Resolve

Write-Host $repoRoot
Write-Host $outputRoot

$CURA_DEBUG_MODE = "ON"

$ORGANREGEN_ENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS = "OFF"
if ($EnableOrganRegenEngineExtraOptimizationFlags) {
  $ORGANREGEN_ENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS = "ON"
}

$CPACK_GENERATOR = "NSIS"

$dockerExtraArgs = New-Object Collections.Generic.List[String]
if ($IsInteractive) {
  $dockerExtraArgs.Add("-it")
}

if ($BindSshVolume) {
  $oldPath = pwd
  cd ~
  $homePath = pwd
  cd $oldPath
  $sshPath = "$homePath\.ssh"
  $dockerExtraArgs.Add("--volume")
  $dockerExtraArgs.Add("${sshPath}:C:\Users\ContainerAdministrator\.ssh")
}

& docker.exe run $dockerExtraArgs `
  --rm `
  --volume ${repoRoot}:C:\cura-build-src `
  --volume ${outputRoot}:C:\cura-build-volume `
  --env CURA_BUILD_SRC_PATH=C:\cura-build-src `
  --env CURA_BUILD_ENV_PATH=C:\cura-build-environment `
  --env CURA_BUILD_OUTPUT_PATH=C:\cura-build-output `
  --env CURA_BRANCH_OR_TAG=$CuraBranchOrTag `
  --env URANIUM_BRANCH_OR_TAG=$UraniumBranchOrTag `
  --env ORGANREGEN_ENGINE_BRANCH_OR_TAG=$OrganRegenEngineBranchOrTag `
  --env CURABINARYDATA_BRANCH_OR_TAG=$CuraBinaryDataBranchOrTag `
  --env FDMMATERIALS_BRANCH_OR_TAG=$FdmMaterialsBranchOrTag `
  --env LIBCHARON_BRANCH_OR_TAG=$LibCharonBranchOrTag `
  --env CURA_VERSION_MAJOR=$CuraVersionMajor `
  --env CURA_VERSION_MINOR=$CuraVersionMinor `
  --env CURA_VERSION_PATCH=$CuraVersionPatch `
  --env CURA_VERSION_EXTRA=$CuraVersionExtra `
  --env CURA_BUILD_TYPE=$CuraBuildType `
  --env CURA_NO_INSTALL_PLUGINS=$NoInstallPlugins `
  --env CURA_CLOUD_API_ROOT=$CuraCloudApiRoot `
  --env CURA_CLOUD_API_VERSION=$CuraCloudApiVersion `
  --env CURA_CLOUD_ACCOUNT_API_ROOT=$CuraCloudAccountApiRoot `
  --env CURA_DEBUG_MODE=$CURA_DEBUG_MODE `
  --env ORGANREGEN_ENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS=$ORGANREGEN_ENGINE_ENABLE_MORE_COMPILER_OPTIMIZATION_FLAGS `
  --env CPACK_GENERATOR=$CPACK_GENERATOR `
  --env CURA_MSI_PRODUCT_GUID=$CuraMsiProductGuid `
  --env CURA_MSI_UPGRADE_GUID=$CuraMsiUpgradeGuid `
  $DockerImage `
  powershell.exe -Command cmd /c "C:\cura-build-src\scripts\python3.7\windows\build_in_docker.cmd"
