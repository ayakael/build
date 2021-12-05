# Description
APKBUILD for dotnet 3.1.

# How to build
If built for the first time, make sure that _bootstrap=true, as build
needs either Microsoft bootstrap or repo's bootstrap to build
* abuild snapshot
* abuild -r
If you built with _bootstrap=true, push pkgrel by one and rebuild with
_bootstrap=false as build with bootstrap creates packages that confuse
dependencies between dotnet-3.1 and dotnet-5.0

# Known issues
* Build oddities here and there that the patches fix. In the process of 
upstreaming to clear them out
* A custom version of snapshot is used because Darc considers the build 
directory as the top-most git  directory. Thus, an error occurs when one 
attempts a build within aports (or other git repos). There's likely
a way to adjust this, but for now this will do.


# Patch notes

## coreclr_fix-build-on-Alpine-edge-45352.patch
   Fixes a build error for Alpine Linux. It has since been fixed in dotnet-5.0,
   see issue dotnet/runtime 45352.
## corefx_fix-build-clang10.patch
   Fixes a build error for clang 10
## core-setup_rid-plat-generation-on-alpine-fix.patch
   <dotnet/core-setup>/src/corehost/build.sh generates wrong plat_rid on Alpine
   Generated RID is expected to be alpine.x.xx-xx, while the computed RID
   is linux-musl-xxx. This patches it by matching what's expected.
## coreclr_non-portable-distrorid-fix-alpine.patch
   <dotnet/coreclr>/init-distro-id.sh generates incorrect DistroRid on Alpine.
   While the expected DistroRid (alpine-x.xx-xxx) should only include macro
   version, init-distro-id.sh includes the micro version. This patches it
   to cut off the trailing subversion off of VERSION_ID by treating it 
   the same way RHEL's VERSION_ID is treated.
## installer_generate-layout-core-setup-blob-path-fix.patch
   <dotnet/core-setup> blobs are written to $builddir/artifacts/obj/x64/Release/
   blobs/Runtime/3.1.20-alpine.3.15 while installer expects them in 3.1.20.
   This patches <dotnet/installer>/src/redist/targets/GenerateLayout.targets
   to point to actual path.
## applications-insights_fix-net40-location.patch
   Because paths on Linux are case sensitive. Applications insights looks
   for <dotnet/applications-insights>/src/Core/Managed/net40 in net40 
   while the repo has a Net40. Patch moves whatever is in Net40 to net40.
## build_coreclr-tools-path.patch
   Various steps in the build process looks for ilasm in ildasm in 
   $builddir/src/dotnet-3.1/Tools/source-built/coreclr-tools/x64 while they are
   built to $builddir/src/dotnet-3.1/Tools/source-built/coreclr-tools.
   This patches <dotnet/source-build> to look for ilasm and ildasm
   in correct path.
## build_darc-fix-alpine.patch         
   Darc has a segmentation fault on Alpine due to not chosing the correct
   binary architecture. This patch deletes all the wrong ones so that it
   is forced to chose the correct one. See issue dotnet/source-build #1868
   
