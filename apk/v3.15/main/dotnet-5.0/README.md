# Description
APKBUILD for dotnet 5.0.
 
# How to build
If built for the first time, make sure that _bootstrap=true, as build
needs either Microsoft bootstrap or repo's bootstrap to build
* abuild snapshot
* abuild -r
If you built with _bootstrap=true, push pkgrel by one and rebuild with
_bootstrap=false as build with bootstrap creates packages that confuse
dependencies between dotnet-3.1 and dotnet-5.0

# Known issues
* The build itself has some odd kinks here and there that various patches
addresses. Please feel free to share any notes from your build environment.
* A custom version of snapshot is used because Darc considers the build 
directory as the top-most git  directory. Thus, an error occurs when one 
attempts a build within aports (or other git repos). There's likely
a way to adjust this, but for now this will do.


# Patch notes

## applications-insights_fix-net40-location.patch
   Because paths on Linux are case sensitive. Applications insights looks
   for <dotnet/applications-insights>/src/Core/Managed/net40 in net40 
   while the repo has a Net40. Patch moves whatever is in Net40 to net40
## build_darc-fix-alpine.patch
   Darc has a segmentation fault on Alpine due to not chosing the correct
   binary architecture. This patch deletes all the wrong ones so that it
   is forced to chose the correct one. See dotnet/source-build issue #1868.
## runtime_add-rid-for-alpine-315.patch/_
   As of version 5.0.12, runtime does not have the RIDs for Alpine Linux 3.15.
   This patch adds them. See dotnet/core issue #6985 
## runtime_link-order.patch
   For some reason, runtime does not link in the right order. This fixes that.
## runtime_non-portable-distrorid-fix-alpine.patch
   Runtime adds the extra subversion in its calculation of Alpine's DistroRID
   when a non-portable build, but does so inconsistently. This creates an error
   when it generates its nuget package.
## sdk_telemetry-optout.patch
   Optouts of telemetry gathering

