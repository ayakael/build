
# Description
APKBUILD for dotnet 5.0.

# Known issues
The build itself has some odd kinks here and there that various patches
addresses. Please feel free to share any notes from your build environment.

# Patch notes

* runtime_add-rid-for-alpine-315.patch/_
   As of version 5.0.12, runtime does not have the RIDs for Alpine Linux 3.15.
   This patch adds them. See dotnet/core issue #6985 
* runtime_link-order.patch
   For some reason, runtime does not link in the right order. This fixes that.
* runtime_non-portable-distrorid-fix-alpine.patch
   Runtime adds the extra subversion in its calculation of Alpine's DistroRID
   when a non-portable build, but does so inconsistently. This creates an error
   when it generates its nuget package.
* build_darc-fix-alpine.patch
   Darc has a segmentation fault on Alpine due to not chosing the correct
   binary architecture. This patch deletes all the wrong ones so that it
   is forced to chose the correct one. See dotnet/source-build issue #1868.
* sdk_telemetry-optout.patch
   Optouts of telemetry gathering

