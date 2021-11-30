# Set location for AppHost lookup
[ -z "$DOTNET_ROOT" ] && export DOTNET_ROOT=/usr/share/dotnet

# Add dotnet tools directory to PATH
DOTNET_TOOLS_PATH="$HOME/.dotnet/tools"
case "$PATH" in
    *"$DOTNET_TOOLS_PATH"* ) true ;;
    * ) PATH="$PATH:$DOTNET_TOOLS_PATH" ;;
esac

# Extract self-contained executables under HOME to avoid multi-user issues from using the default '/var/tmp'
[ -z "$DOTNET_BUNDLE_EXTRACT_BASE_DIR" ] && export DOTNET_BUNDLE_EXTRACT_BASE_DIR="${XDG_CACHE_HOME:-"$HOME"/.cache}/dotnet_bundle_extract"
